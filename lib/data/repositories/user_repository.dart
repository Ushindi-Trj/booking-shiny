import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:booking_shiny/environment.dart';
import 'package:booking_shiny/data/models/models.dart';

class UserRepository {
  final _userDb = FirebaseFirestore.instance.collection('users');

  Future<UserModel> getUserInfo(String user) async {
    final request = await _userDb.doc(user).get();
    return UserModel.fromJson(request);
  }

  Future<List<PaymentMethodModel>> fetchCards() async {
    final user = await getUserInfo(FirebaseAuth.instance.currentUser!.uid);
    final List<PaymentMethodModel> cards = [];

    try {
      final request = await http.get(
        Uri.parse('https://api.stripe.com/v1/customers/${user.stripeCustomerId}/sources'),
        headers: {'Authorization': 'Bearer $stripeSecretKey'}
      );
      final response = jsonDecode(request.body);

      if (request.statusCode == 200) {
        for (var data in response['data'] as List) {
          final isDefault = await checkDefaultCard(user.stripeCustomerId, data['id']);

          if (isDefault) {
            cards.insert(0, PaymentMethodModel.fromJson(data, isDefault));
          } else {
            cards.add(PaymentMethodModel.fromJson(data));
          }
        }
      } else {
        throw Exception('${request.reasonPhrase}: ${response['error']['message']}');
      }
    } catch(e) {
      rethrow;
    }
    return cards;
  }

  Future<void> addNewCard({holder, number, year, month, cvv}) async {
    final user = await getUserInfo(FirebaseAuth.instance.currentUser!.uid);
    final customerId = user.stripeCustomerId;
    
    try{
      if (!await checkCardExist(customerId, number, year, month)) {
        //  Create token
        final tokenRequest = await http.post(
          Uri.parse('https://api.stripe.com/v1/tokens'),
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            "card[name]": holder,
            "card[number]": number,
            "card[cvc]": cvv.toString(),
            "card[exp_month]": month.toString(),
            "card[exp_year]": year.toString(),
          }
        );

        if (tokenRequest.statusCode == 200) {
          final tokenResponse = json.decode(tokenRequest.body);

          final request = await http.post(
            Uri.parse('https://api.stripe.com/v1/customers/$customerId/sources'),
            headers: {
              'Authorization': 'Bearer $stripeSecretKey',
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: {'source': tokenResponse['id']},
          );

          if (request.statusCode != 200) {
            final error = jsonDecode(request.body)['error']['message'];
            throw Exception('${request.reasonPhrase}: $error');
          }
        } else {
          final error = jsonDecode(tokenRequest.body)['error']['message'];
          throw Exception('${tokenRequest.reasonPhrase}: $error');
        }
      } else {
        throw Exception('This bank card already exist to your account');
      }
    } catch(err) {
      print(err);
      rethrow;
    }
  }

  Future<void> updatecard({cardId, holder, expYear, expMonth}) async {
    final user = await getUserInfo(FirebaseAuth.instance.currentUser!.uid);

    try {
      final request = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers/${user.stripeCustomerId}/sources/$cardId'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'name': holder,
          'exp_month': expMonth,
          'exp_year': expYear,
        }
      );
      final response = jsonDecode(request.body);

      if (request.statusCode != 200) {
        throw Exception('${request.reasonPhrase}: ${response['error']['message']}');
      }
    } catch(error) {
      rethrow;
    }
  }

  Future<void> deleteCard({cardId}) async {
    final user = await getUserInfo(FirebaseAuth.instance.currentUser!.uid);

    try {
      //  Anyway delete the payment method
      final request = await http.delete(
        Uri.parse('https://api.stripe.com/v1/customers/${user.stripeCustomerId}/sources/$cardId'),
        headers: {'Authorization': 'Bearer $stripeSecretKey',}
      );
      
      if (request.statusCode != 200) {
        final response = jsonDecode(request.body);
        throw Exception('${request.reasonPhrase}: ${response['error']['message']}');
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<PaymentMethodModel?> getDefaultCard() async {
    final user = await getUserInfo(FirebaseAuth.instance.currentUser!.uid);
    try {
      final request = await http.get(
        Uri.parse('https://api.stripe.com/v1/customers/${user.stripeCustomerId}'),
        headers: {'Authorization': 'Bearer $stripeSecretKey'}
      );
      final response = jsonDecode(request.body);

      if (request.statusCode == 200) {
        final defaultCradId = response['default_source'];

        if (defaultCradId != null) {
          final query = await http.get(
            Uri.parse('https://api.stripe.com/v1/customers/${user.stripeCustomerId}/sources/$defaultCradId'),
            headers: {'Authorization': 'Bearer $stripeSecretKey'}
          );
          final result = json.decode(query.body);

          if (query.statusCode == 200) {
            return PaymentMethodModel.fromJson(result, true);
          } else {
            throw Exception('${query.reasonPhrase}: ${result['error']['message']}');
          }
        }
        return null;
      } else {
        throw Exception('${request.reasonPhrase}: ${response['error']['message']}');
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<bool> setDefaultCard(String cardId) async {
    try {
      final user = await getUserInfo(FirebaseAuth.instance.currentUser!.uid);

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers/${user.stripeCustomerId}'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {"default_source": cardId},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final body = json.decode(response.body);
        throw Exception('Error updating default payment method: ${body['error']['message']}');
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<bool> checkDefaultCard(customerId, cardId) async {
    try {
      final request = await http.get(
        Uri.parse('https://api.stripe.com/v1/customers/$customerId'),
        headers: {'Authorization': 'Bearer $stripeSecretKey'}
      );
      final response = jsonDecode(request.body);

      if (request.statusCode == 200) {
        return response["default_source"] == cardId;
      } else {
        throw Exception('${request.reasonPhrase}: ${response['error']['message']}');
      }
    } catch(error) {
      rethrow;
    }
  }

  Future<bool> checkCardExist(customerId, String cardNumber, String year, String month) async {
    try {
      final request = await http.get(
        Uri.parse('https://api.stripe.com/v1/customers/$customerId/sources'),
        headers: {'Authorization': 'Bearer $stripeSecretKey'}
      );
      final response = jsonDecode(request.body)['data'] as List;

      for (var data in response) {
        final card = PaymentMethodModel.fromJson(data);

        return 
          card.expiryMonth == month &&
          card.expiryYear == (int.parse(year) + 2000).toString() &&
          card.last4digits == cardNumber.substring(cardNumber.length, 4)
        ;
      }
      return false;
    } catch(e) {
      rethrow;
    }
  }

  Future<String> createCustomer(name, email) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'name': name, 'email': email},
      );
      final body = json.decode(response.body);

      if (response.statusCode == 200) {
        return body['id'];
      } else {
        throw Exception('Failed to create customer: ${body['error']['message']}');
      }
    } catch(error) {
      rethrow;
    }
  }
}
