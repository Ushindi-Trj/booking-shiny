import 'dart:math' as math;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/backend/bloc/blocs.dart';
import 'package:booking_shiny/backend/cubit/cubits.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Align _devider() => Align(
    alignment: Alignment.centerRight,
    child: FractionallySizedBox(
      widthFactor: 0.84,
      child: Container(
        height: 1.3,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12)
        ),
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProfileListTile(),
            const _ManageBusiness(),
            
            //  Manage your payment mwthods
            ListTileWidget(
              onClicked: () {
                context.push(Routes.paymentMethods.path);
              },
              title: 'Payment Methods',
              subtitle: 'Methods using for your transaction',
              leading: 'payment.svg',
              trailing: 'arrow-right.svg',
            ),
            _devider(),
            //  Transaction history
            ListTileWidget(
              onClicked: () {},
              title: 'Transaction History',
              subtitle: 'All your transactions will appear here',
              leading: 'transaction.svg',
              trailing: 'arrow-right.svg',
            ),
            _devider(),
            //  Theme mode switcher
            BlocBuilder<ThemeModeCubit, bool>(
              buildWhen: (prev, state) => prev != state,
              builder: (context, themeIsDark) {
                return ListTileWidget(
                  onClicked: () {
                    BlocProvider.of<ThemeModeCubit>(context).changeThemeModeRequested(!themeIsDark);
                  },
                  title: themeIsDark ? 'Dark Mode' : 'Light Mode',
                  leading: '${themeIsDark ? 'moon' : 'sun'}.svg',
                );
              }
            ),

            //  Logout Button
            ListTile(
              onTap: () {
                context.read<AuthBloc>().add(SignoutRequested());
                context.go('/');
              },
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.logout, color: Support.red1,),
              title: const Text('Logout',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Support.red1),
              ),
            )
          ]
        ),
      ),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  const _ProfileListTile();

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!;

    return ListTile(
      onTap: () {
        context.go(Routes.profileEdit.path);
      },
      contentPadding: EdgeInsets.zero,
      leading: Wrap(children: [
        SizedBox(
          width: 58, height: 58,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: NetworkImage(auth.photoURL!),
          ),
        )
      ]),
      title: Text(
        toBeginningOfSentenceCase(auth.displayName!)!,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      subtitle: Text(
        auth.email!,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Edit',
            style: TextStyle(fontSize: 14, color: Primary.darkGreen1, fontWeight: FontWeight.w500),
          ),
          SvgPicture.asset(
            width: 12, height: 12,
            'assets/icons/arrow-right.svg',
            colorFilter: const ColorFilter.mode(Primary.darkGreen1, BlendMode.srcIn),
          )
        ],
      ),
    );
  }
}


class _ManageBusiness extends StatelessWidget {
  const _ManageBusiness();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Primary.darkGreen1,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateZ(math.pi)
                      ..translate(0.0, -10.0, 0.0),
                    child: Image.asset('assets/images/leaf.png', height: 70)
                  ),
                  Image.asset('assets/images/leaf.png', height: 70),
                ],
              ),
              ListTile(
                onTap: () {
                  //  TODO show the user's business part
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
                leading: SizedBox.fromSize(
                  size: const Size(52, 52),
                  child: CircleAvatar(
                    backgroundColor: Primary.black3,
                    child: SvgPicture.asset('assets/icons/business-bulk.svg'),
                  ),
                ),
                title: const Text(
                  'Business',
                  style: TextStyle(fontSize: 15, color: Palette.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Go to manage the offered services',
                  style: TextStyle(fontSize: 12, height: 1.8, color: Palette.white.withOpacity(0.6)),
                ),
                trailing: SvgPicture.asset(
                  width: 12, height: 12,
                  'assets/icons/arrow-right.svg',
                  colorFilter: const ColorFilter.mode(Support.orange2, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}