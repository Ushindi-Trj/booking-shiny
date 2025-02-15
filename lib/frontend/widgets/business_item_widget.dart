import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/data/models/models.dart' show BusinessModel, OpeningHoursModel;

class BusinessItemWidget extends StatelessWidget {
  const BusinessItemWidget({super.key, required this.business});

  final BusinessModel business;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //  Show business detail
        context.push(Routes.details.path, extra: business);
      },
      borderRadius: BorderRadius.circular(12),
      child: SizedBox.fromSize(
        size: const Size(double.infinity, 100),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primaryContainer)
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox.square(
                    dimension: 88,
                    child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: business.images.first),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                
                      if (business.location.address != null) ...[ 
                        const SizedBox(height: 4),
                        Text(
                          business.location.address!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis
                          ),
                        )
                      ],
                
                      const SizedBox(height: 16),
                      FittedBox(
                        child: Wrap(
                          spacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Wrap(
                              spacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/clock-bold.svg',
                                  width: 16, height: 16,
                                  colorFilter: const ColorFilter.mode(Support.orange2, BlendMode.srcIn),
                                ),
                                Text(
                                  OpeningHoursModel.formatedOpeningHour(business.openingHours),
                                  style: Theme.of(context).textTheme.labelSmall,
                                )
                              ],
                            ),
                            Container(
                              width: 4, height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).textTheme.labelSmall!.color!.withOpacity(0.40)
                              ),
                            ),
                            Wrap(
                              spacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/star-bold.svg',
                                  width: 16, height: 16,
                                  colorFilter: const ColorFilter.mode(Support.orange1, BlendMode.srcIn),
                                ),
                                RichText(text: TextSpan(children: [
                                  TextSpan(
                                    text: business.ratings.rating.toString(),
                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                      height: 1.6,
                                      fontSize: 12
                                    )
                                  ),
                                  const WidgetSpan(child: SizedBox(width: 4)),
                                  TextSpan(
                                    text: '(${formatNumber(business.ratings.totalRatings)})',
                                    style: Theme.of(context).textTheme.labelSmall
                                  )
                                ]))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}