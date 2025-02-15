import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/frontend/widgets/widgets.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/data/repositories/repositories.dart' show BusinessRepository;

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favourite',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: const [Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: NotificationBadgeWidget(),
            ),
          ],
        )],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchButtonLargeWidget(bgColor: Colors.transparent,),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 24),
              child: Text(
                'Recently Added',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            FutureBuilder<List<BusinessModel>>(
              future: RepositoryProvider.of<BusinessRepository>(context).getFavoriteBusinesses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProgressWidget();
                }

                final businesses = snapshot.data!;

                if (businesses.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        'Empty',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Support.red2
                        ),
                      ),
                    ),
                  );
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 420),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child
                  ),
                  child: ListView.separated(
                    itemCount: businesses.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 320),
                      child: BusinessItemWidget(business: businesses.elementAt(index),)
                    ),
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}