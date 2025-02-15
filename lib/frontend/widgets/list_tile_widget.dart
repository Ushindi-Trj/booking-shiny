import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onClicked
  });

  final String title;
  final String? subtitle;
  final String? leading;
  final String? trailing;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onClicked,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium
      ),
      subtitle: subtitle==null ? null : Text(
        subtitle!,
        style: Theme.of(context).textTheme.labelSmall
      ),
      leading: leading==null ? null : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SvgPicture.asset(
          'assets/icons/$leading',
          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
        )],
      ),
      trailing: trailing==null ? null : SvgPicture.asset(
        width: 18, height: 18,
        'assets/icons/$trailing',
        colorFilter: const ColorFilter.mode(Secondary.grey1, BlendMode.srcIn),
      ),
    );
  }
}