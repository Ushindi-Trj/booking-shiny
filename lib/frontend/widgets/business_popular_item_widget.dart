import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:booking_shiny/data/models/models.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';

class BusinessPopularItemWidget extends StatelessWidget {
  const BusinessPopularItemWidget({super.key, required this.business});

  final BusinessModel business;

  @override
  Widget build(BuildContext context) {
    final String formatedOpeningHour = OpeningHoursModel.formatedOpeningHour(
      business.openingHours
    );

    return AnimatedOpacity(
      opacity: 1.0,
      curve: Curves.bounceInOut,
      duration: const Duration(milliseconds: 230),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SizedBox.fromSize(
              size: const Size(292, double.infinity),
              child: CachedNetworkImage(imageUrl: business.images.first, fit: BoxFit.cover)
            ),
            SizedBox.fromSize(
              size: const Size(292, double.infinity),
              child: Material(
                color: Primary.black1.withOpacity(0.19),
                child: InkWell(
                  onTap: () {
                    //  show detail screen
                    context.push(Routes.details.path, extra: business);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SizedBox.fromSize(
                            size: const Size(36, 36),
                            child: CircleAvatar(
                              backgroundColor: Palette.white,
                              child: FavoriteButtonWidget(
                                businessId: business.id,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Ink(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                business.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                business.location.address!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 13),
                              ),
                              const SizedBox(height: 8),
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
                                          formatedOpeningHour,
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
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
