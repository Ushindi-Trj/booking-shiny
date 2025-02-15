import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booking_shiny/data/repositories/repositories.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/frontend/widgets/widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const PopButtonWidget(),
        actions: [Row(
          children: [
            InkWell(
              onTap: () {
                //  TODO Clear history
              },
              borderRadius: BorderRadius.circular(100),
              child: Ink(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1.5, color: Theme.of(context).colorScheme.primaryContainer)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/icons/bin.svg',
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
            const Padding(
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
              'Recent Visited',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
            ),
            FutureBuilder(
              future: RepositoryProvider.of<BusinessRepository>(context).getHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: SizedBox.square(
                      dimension: 26,
                      child: CircularProgressIndicator(strokeWidth: 1.5,)
                    )),
                  );
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

                return ListView.builder(
                  itemCount: businesses.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 24),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey<int>(index),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        //  TODO delete business from history
                      },
                      background: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: SvgPicture.asset(
                              'assets/icons/bin.svg',
                              width: 26, height: 26,
                              colorFilter: const ColorFilter.mode(Support.red1, BlendMode.srcIn),
                            ),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: BusinessItemWidget(business: businesses.elementAt(index)),
                      )
                    );
                  },
                );
              }
            )
          ],
        ),
      ),
    );
  }
}