import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_shiny/utils/utils.dart';

import 'package:booking_shiny/data/repositories/repositories.dart' show BusinessRepository;

import 'package:booking_shiny/frontend/widgets/widgets.dart';

class PopularBusinesses extends StatelessWidget {
  const PopularBusinesses({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 31, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Near You',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    context.push(Routes.popularBusinesses.path);
                  },
                  style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text(
                    'See All',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          FutureBuilder(
            future: RepositoryProvider.of<BusinessRepository>(context).getDiscoverPopularNearby(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ProgressWidget();
              }

              final businesses = snapshot.data!;

              return SizedBox.fromSize(
                size: const Size.fromHeight(196),
                child: ListView.separated(
                  itemCount: businesses.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final business = businesses.elementAt(index);

                    return Padding(
                      padding: EdgeInsets.only(
                        left: business==businesses.first ? 20 : 0,
                        right: business==businesses.last ? 20 : 0
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 320),
                        child: BusinessPopularItemWidget(
                          key: ValueKey<int>(index),
                          business: business
                        ),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: child
                        ),
                      ),
                    );
                  }
                ),
              );
            }
          )
        ],
      ),
    );
  }
}


