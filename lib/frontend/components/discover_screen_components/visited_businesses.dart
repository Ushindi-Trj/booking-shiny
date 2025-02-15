import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_shiny/utils/utils.dart';

import 'package:booking_shiny/data/repositories/repositories.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';

class VisitedBusinesses extends StatelessWidget {
  const VisitedBusinesses({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Visited',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  context.push(Routes.history.path);
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
          const SizedBox(height: 24),
          FutureBuilder(
            future: RepositoryProvider.of<BusinessRepository>(context).getHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ProgressWidget();
              }

              final businesses = snapshot.data!;

              if (businesses.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: Text(
                    'Start visiting',
                    style: TextStyle(fontSize: 16, color: Support.orange2, fontWeight: FontWeight.bold),
                  )),
                );
              }

              return ListView.separated(
                itemCount: businesses.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return BusinessItemWidget(business: businesses.elementAt(index));
                },
              );
            }
          )
        ],
      ),
    );
  }
}