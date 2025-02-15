import 'package:flutter/material.dart';
import 'package:booking_shiny/utils/utils.dart';

class ConfirmDismissDialog extends StatelessWidget {
  const ConfirmDismissDialog({super.key, required this.subtitle, required this.title});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Primary.darkGreen1, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              Row(children: [
                Expanded(
                  child: SizedBox.fromSize(
                    size: const Size.fromHeight(56),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Support.red2),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 56,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                Expanded(
                  child: SizedBox.fromSize(
                    size: const Size.fromHeight(56),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        'Remove',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Primary.darkGreen1),
                      ),
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}