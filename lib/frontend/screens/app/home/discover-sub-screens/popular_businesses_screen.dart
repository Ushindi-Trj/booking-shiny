import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/data/repositories/repositories.dart' show BusinessRepository;

class PopularBusinessesScreen extends StatelessWidget {
  const PopularBusinessesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const PopButtonWidget(),
        actions: const [Row(
          children: [
            SearchButtonWidget(),
            Padding(
              padding: EdgeInsets.only(right: 20, left: 16),
              child: NotificationBadgeWidget(),
            ),
          ],
        )]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popular Nearby',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 4),

            FutureBuilder(
              future: RepositoryProvider.of<BusinessRepository>(context).getPopularNearby(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: SizedBox.square(
                        dimension: 26,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                final businesses = snapshot.data!;

                if (businesses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Text(
                            'No services found near you',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                          ),
                        ),
                        Text(
                          'Please make a search or check on map',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${businesses.length}+ Services found near you',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    ListView.separated(
                      itemCount: businesses.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 24, bottom: 14),
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 520),
                          child: BusinessItemWidget(business: businesses.elementAt(index),)
                        );
                      },
                    )
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}