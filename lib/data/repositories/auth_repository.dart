import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user_repository.dart';

class AuthRepository {
  final _profile = 'https://firebasestorage.googleapis.com/v0/b/shiny-booking.appspot.com/o/profile%2Fprofile-avatar.png?alt=media&token=b01d698c-4476-4bbf-a809-478d82dc4a5a';
  final _database = FirebaseFirestore.instance.collection('users');
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    if (email.isEmpty) {
      throw Exception('Please enter you E-mail address!!');
    } else if (!EmailValidator.validate(email)) {
      throw Exception('This E-mail address is not valid!');
    } else if (password.isEmpty) {
      throw Exception('Please enter your password!');
    }

    try {
      //  Login
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (error.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception(error.message);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String username, String email, String password, String confirm) async {
    if (username.isEmpty) {
      throw Exception('Your Fullname is requested');
    } else if (email.isEmpty) {
      throw Exception('The E-mail Address is requested!');
    } else if (!EmailValidator.validate(email)) {
      throw Exception('This E-mail address is not valid!');
    } else if(password.length < 6) {
      throw Exception('The min length os password is 6');
    } else if (password != confirm) {
      throw Exception('Your password must match with the confirmation!!');
    }

    try {
      //  Create new user's account
      final user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await user.user!.updatePhotoURL(_profile);
      await user.user!.updateDisplayName(username);

      //  Save user's information in database
      await _database.doc(user.user!.uid).set({
        'username': username,
        'email': email,
        'phone': null,
        'profile': _profile
      });

      //  create user's stripe account
          await UserRepository().createCustomer(username, email);
    } on FirebaseAuthException catch(error) {
      if (error.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (error.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception(error.message);
      }
    } catch(error) {
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    if (kIsWeb) {
      //  Sign in with google on web
    } else {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken
        );

        //  Sign in with credential
        final auth = await _firebaseAuth.signInWithCredential(credential);
        await auth.user!.updatePhotoURL(auth.user!.photoURL ?? _profile);

        //  Check if it's new user and add him in database
        await _database.doc(auth.user!.uid).get().then((doc) async {
          if (!doc.exists) {
            final info = auth.user!;

            await _database.doc(info.uid).set({
              'username': info.displayName,
              'email': info.email!,
              'phone': info.phoneNumber,
              'profile': info.photoURL
            });

            //  create user's stripe customer account
            await UserRepository().createCustomer(info.displayName, info.email);
          }
        });
      } on FirebaseAuthException catch(error) {
        throw Exception(error.message);
      } catch(error) {
        rethrow;
      }
    }
  }
}