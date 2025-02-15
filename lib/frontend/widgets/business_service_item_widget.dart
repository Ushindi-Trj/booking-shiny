import 'package:flutter/material.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booking_shiny/backend/bloc/blocs.dart';
import 'package:booking_shiny/data/repositories/repositories.dart';
import 'package:booking_shiny/data/models/models.dart' show ServiceModel, DurationModel;

class BusinessServiceItemWidget extends StatelessWidget {
  const BusinessServiceItemWidget({super.key, required this.service, required this.businessId});

  final ServiceModel service;
  final String businessId;

  @override
  Widget build(BuildContext context) {
    final double minPrice = service.duration.map<double>((duration) => duration.price).reduce((a, b) => a<b ? a : b);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          //  TODO show service details
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: Theme.of(context).colorScheme.primaryContainer)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.square(
                dimension: 68,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(imageUrl: service.image, fit: BoxFit.cover,),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${minPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 4),
              StreamBuilder<bool>(
                //  Check is the service is in cart
                stream: RepositoryProvider.of<BusinessRepository>(context).checkServiceInCart(
                  business: businessId,
                  service: service.id
                ),
                builder: (context, snapshot) {
                  return _SelectButton(
                    selected: snapshot.data ?? false,
                    onClicked: () {
                      //  Select/Unselect the service
                      if (service.duration.length > 1) {
                        showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          isScrollControlled: true,
                          builder: (context) => _ServiceDurationSelectingModal(
                            businessId: businessId,
                            service: service,
                          )
                        );
                      } else {
                        context.read<BusinessBloc>().add(AddToCartRequested(
                          business: businessId,
                          serviceId: service.id,
                          serviceName: service.name,
                          duration: service.duration.first,
                          promotionId: null
                        ));
                      }
                    },
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceDurationSelectingModal extends StatelessWidget {
  const _ServiceDurationSelectingModal({required this.businessId, required this.service});

  final ServiceModel service;
  final String businessId;

  void _selectService(BuildContext context, DurationModel duration) {
    context.read<BusinessBloc>().add(AddToCartRequested(
      business: businessId,
      serviceId: service.id,
      serviceName: service.name,
      duration: duration,
      promotionId: null
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32))
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                service.name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            ...service.duration.map((duration) {
              return ListTile(
                onTap: () => _selectService(context, duration),
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                title: Text(
                  durationToString(duration.duration),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                subtitle: Text(
                  '\$${duration.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                trailing: StreamBuilder<bool>(
                  //  Check if the service duration is in cart
                  stream: RepositoryProvider.of<BusinessRepository>(context).checkServiceDurationInCart(
                    business: businessId,
                    service: service.id,
                    duration: duration.duration
                  ),
                  builder: (context, snapshot) {
                    return _SelectButton(
                      selected: snapshot.data ?? false,
                      onClicked: () => _selectService(context, duration)
                    );
                  }
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}


class _SelectButton extends StatelessWidget {
  const _SelectButton({required this.onClicked, required this.selected});

  final VoidCallback onClicked;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final text = selected ? 'Selected' : 'Select';
    final iconName = selected ? 'tick.svg' : 'plus.svg';
    final color = selected ? Support.orange2 : Primary.darkGreen1;
    final width = selected ? 82.0 : 72.0;
    final size = selected ? 11.0 : 16.0;

    return SizedBox.fromSize(
      size: Size(width, 24),
      child: MaterialButton(
        onPressed: onClicked,
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(54),
          side: BorderSide(width: 1, color: color)
        ),
        child: Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 12, height: 1.3, fontWeight: FontWeight.w500, color: color),
            ),
            SvgPicture.asset(
              'assets/icons/$iconName',
              width: size, height: size,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            )
          ],
        ),
      ),
    );
  }
}
