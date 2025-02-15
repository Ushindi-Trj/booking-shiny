import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/frontend/widgets/widgets.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leadingWidth: 64,
        centerTitle: true,
        leading: const PopButtonWidget(),
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  //  Change profile picture
                },
                child: SizedBox.fromSize(
                  size: const Size(88, 88),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    backgroundImage: NetworkImage(auth.photoURL!),
                  ),
                ),
              ),
              const SizedBox(height: 32),
      
              Form(
                child: Column(children: [
                  InputTextWidget(
                    label: 'Full-name',
                    placeholder: auth.displayName!,
                    prefixIcon: 'user.svg',
                    textInputAction: TextInputAction.done,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: InputTextWidget(
                      label: 'E-mail Address',
                      placeholder: auth.email!,
                      prefixIcon: 'message.svg',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  InputTextWidget(
                    label: 'Phone Number',
                    placeholder: auth.phoneNumber ?? 'Enter your phone number',
                    prefixIcon: 'phone.svg',
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 35),
                  ListTile(
                    onTap: () {
                      //  Show password edit form screen
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [SvgPicture.asset(
                        'assets/icons/password.svg',
                        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                      )],
                    ),
                    title: Text(
                      'Change Password',
                      style: Theme.of(context).textTheme.labelMedium
                    ),
                    trailing: SvgPicture.asset(
                      width: 18, height: 18,
                      'assets/icons/arrow-right.svg',
                      colorFilter: const ColorFilter.mode(Secondary.grey1, BlendMode.srcIn),
                    ),
                  )
                ],)
              )
            ],
          ),
        ),
      ),
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButtonWidget(
          onClicked: () {},
          text: 'Save Changes',
        ),
      ),
    );
  }
}