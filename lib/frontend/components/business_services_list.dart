import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booking_shiny/data/repositories/repositories.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';

class BusinessServicesList extends StatelessWidget {
  const BusinessServicesList({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 24),
          child: Text(
            'Services',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder(
          future: RepositoryProvider.of<BusinessRepository>(context).getBusinessServices(business: businessId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ProgressWidget();
            }

            final services = snapshot.data!;

            return ListView.separated(
              itemCount: services.length,
              primary: true,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) => BusinessServiceItemWidget(
                service: services.elementAt(index),
                businessId: businessId,
              ),
            );
          })
      ],
    );
  }
}