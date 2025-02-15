import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/data/repositories/repositories.dart';
import 'package:booking_shiny/backend/cubit/cubits.dart' show ThemeModeCubit;

import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class BusinessDetailScreen extends StatefulWidget {
  const BusinessDetailScreen({super.key, required this.business});

  final BusinessModel business;

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  final DraggableScrollableController _scrollableController = DraggableScrollableController();
  late bool isMaxSized = false;

  //  Format the ratings total inorder to get (k, M, etc... 1k, 1M)
  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number/1000).toStringAsFixed(1)}k';
    } else if (number >= 1000000) {
      return '${(number/1000000).toStringAsFixed(1)}M';
    } else {
      return number.toString();
    }
  }

  @override
  void initState() {
    //  Check if the draggable model is dragged to the top
    _scrollableController.addListener(() {
      setState(() {
        if(_scrollableController.size >= .867) {
          isMaxSized = true;
        } else {
          isMaxSized = false;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draggableBorderRadius = isMaxSized ? BorderRadius.zero : const BorderRadius.vertical(top: Radius.circular(32));
    final Color appBarColor = isMaxSized ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent;

    //  Add business to history
    RepositoryProvider.of<BusinessRepository>(context).addHistory(widget.business.id);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: AnimatedContainer(
          color: appBarColor,
          curve: Curves.easeIn,
          height: double.infinity,
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PopButton(isMaxSized: isMaxSized),
              FavoriteButtonDetailWidget(
                isMaxSized: isMaxSized,
                businessId: widget.business.id
              )
            ],
          ),
        ),
      ),
      body: Stack(children: [
        FlutterCarousel.builder(
          itemCount: widget.business.images.length,
          options: FlutterCarouselOptions(
            pageSnapping: true,
            viewportFraction: 1.0,
            pauseAutoPlayOnManualNavigate: true,
            aspectRatio: MediaQuery.of(context).size.width/320,
            showIndicator: true,
            floatingIndicator: true,
            slideIndicator: CircularStaticIndicator(
              slideIndicatorOptions: SlideIndicatorOptions(
                itemSpacing: 18,
                indicatorRadius: 4.5,
                currentIndicatorColor: Support.orange1,
                indicatorBackgroundColor: Secondary.grey1.withValues(alpha: .36),
                padding: const EdgeInsets.only(bottom: 40),
              ),
            )
          ),
          itemBuilder: (context, itemIndex, pageViewIndex) {
            final image = widget.business.images.elementAt(itemIndex);
            return Stack(
              children: [
                SizedBox.fromSize(
                  size: const Size(double.infinity, 320.0),
                  child: CachedNetworkImage(imageUrl: image, fit: BoxFit.cover)
                ),
                Container(decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(0.5, 0.4),
                    end: FractionalOffset(0.5, 1.0),
                    colors: [Colors.transparent, Support.dBlack2]
                  )
                ))
              ],
            );
          },
        ),

        DraggableScrollableSheet(
          controller: _scrollableController,
          minChildSize: .618,
          maxChildSize: .870,
          initialChildSize: .618,
          builder: (context, scrollController) {
            return AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 260),
              decoration: BoxDecoration(
                borderRadius: draggableBorderRadius,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: ClipRRect(
                borderRadius: draggableBorderRadius,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 21),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: !isMaxSized,
                              child: Center(
                                child: Container(
                                  width: 80,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Theme.of(context).colorScheme.secondaryContainer
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 8),
                              child: Text(
                                widget.business.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              widget.business.location.address!,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 32),
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
                                        colorFilter: const ColorFilter.mode(Support.green1, BlendMode.srcIn),
                                      ),
                                      Text(
                                        OpeningHoursModel.formatedOpeningHour(widget.business.openingHours),
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
                                          text: widget.business.ratings.rating.toString(),
                                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                            height: 1.6,
                                            fontSize: 12
                                          )
                                        ),
                                        const WidgetSpan(child: SizedBox(width: 4)),
                                        TextSpan(
                                          text: '(${_formatNumber(widget.business.ratings.totalRatings)})',
                                          style: Theme.of(context).textTheme.labelSmall
                                        )
                                      ]))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              margin: const EdgeInsets.only(bottom: 12),
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            SizedBox.fromSize(
                              size: const Size.fromHeight(62),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _ActionButton(
                                    label: 'Website',
                                    iconName: 'global-light.svg',
                                    onClicked: () {},
                                  ),
                                  _ActionButton(
                                    label: 'Call',
                                    iconName: 'phone.svg',
                                    onClicked: () {},
                                  ),
                                  _ActionButton(
                                    label: 'Direction',
                                    iconName: 'map.svg',
                                    onClicked: () {},
                                  ),
                                  _ActionButton(
                                    label: 'Share',
                                    iconName: 'export-light.svg',
                                    onClicked: () {},
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        height: 8,
                        width: double.infinity,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ListTileWidget(
                              title: 'About Us',
                              subtitle: 'Our services description',
                              leading: 'users.svg',
                              trailing: 'arrow-right.svg'
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FractionallySizedBox(
                                widthFactor: 0.84,
                                child: Container(
                                  height: 1.3,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                )
                              ),
                            ),
                            const ListTileWidget(
                              title: 'Cancellation Policy',
                              subtitle: 'Show the services cancellation policy',
                              leading: 'danger.svg',
                              trailing: 'arrow-right.svg'
                            ),                            
                            //  Show Services
                            BusinessServicesList(businessId: widget.business.id)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        )
      ]),

      // show the cart floating button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CartButton(business: widget.business,),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.iconName, required this.onClicked});

  final String label;
  final String iconName;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClicked,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/$iconName',
              colorFilter: const ColorFilter.mode(Primary.darkGreen1, BlendMode.srcIn),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                height: 1.3,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Primary.darkGreen1,
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class _PopButton extends StatelessWidget {
  const _PopButton({required this.isMaxSized});

  final bool isMaxSized;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, bool>(
      builder: (context, isDark) {
        var borderColor = Colors.transparent;
        var iconColor = Palette.white;

        if (isDark && isMaxSized) {
          borderColor = Support.dBlack2;
        } else if (!isDark && isMaxSized) {
          borderColor = Secondary.lightGrey1;
          iconColor = Primary.black1;
        }

        return SizedBox.square(
          dimension: 44,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Material(
              color: isMaxSized ? Colors.transparent : Primary.black1.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(width: 1.5, color: borderColor)
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset(
                  'assets/icons/pop.svg',
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
