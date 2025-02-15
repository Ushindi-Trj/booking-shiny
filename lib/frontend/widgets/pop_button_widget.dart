import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class PopButtonWidget extends StatelessWidget {
  const PopButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        SizedBox.fromSize(
          size: const Size(44, 44),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Material(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primaryContainer)
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(IconlyLight.arrowLeft, color: Theme.of(context).colorScheme.surface)
              ),
            ),
          ),
        )
      ],
    );
  }
}