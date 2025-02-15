import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:booking_shiny/data/models/models.dart' show Categories;

class ServicesList extends StatelessWidget {
  const ServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Categories> categories = Categories.values;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 24),
          child: Text(
            'Beauty Services',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18),
          ),
        ),
        Ink(
          height: 80,
          child: ListView.separated(
            itemCount: categories.length,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final String label = categories.elementAt(index).name;

              return Padding(
                padding: EdgeInsets.only(
                  left: index==categories.first.index ? 20 : 0,
                  right: index==categories.last.index ? 20 : 0
                ),
                child: GestureDetector(
                  onTap: () {
                    //  Show the category's businesses
                    context.push('/filter/$label');
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/$label.png'),
                      const SizedBox(height: 5),
                      Text(
                        toBeginningOfSentenceCase(label)!,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          height: 1.6,
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ]
                  )
                ),
              );
            },
          ),
        )
      ],
    );
  }
}



