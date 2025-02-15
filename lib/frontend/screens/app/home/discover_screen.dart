import 'package:flutter/material.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:booking_shiny/environment.dart';

import 'package:booking_shiny/backend/cubit/cubits.dart';
import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/data/repositories/repositories.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final PanelController _panelController = PanelController();
  late bool isPanelOpened = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Row(children: [
              Expanded(child: SearchButtonLargeWidget()),
              SizedBox(width: 20),
              NotificationBadgeWidget(size: 52)
            ]),
          ),
        ),
      ),
      
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 84,
        boxShadow: null,
        isDraggable: true,
        panelSnapping: true,
        parallaxEnabled: true,
        color: Colors.transparent,
        defaultPanelState: PanelState.OPEN,
        maxHeight: MediaQuery.of(context).size.height * .738,
        header: _PanelHeader(isOpened: isPanelOpened),
        body: const _ScreenBodyMap(),
        panelBuilder: (ScrollController scrollController) {
          return Container(
            margin: const EdgeInsets.only(top: 84),
            padding: const EdgeInsets.only(top: 32),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.only(top: 16),
              children: const [
                ServicesList(),
                PopularBusinesses(),
                VisitedBusinesses()
              ],
            ),
          );
        },
        onPanelOpened: () => setState(() {
          isPanelOpened = true;
        }),
        onPanelClosed: () => setState(() {
          isPanelOpened = false;
        }),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.isOpened});

  final bool isOpened;

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(fontSize: 12, height: 2, fontWeight: FontWeight.w500, color: Palette.white);
    
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 11.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCrossFade(
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeOut,
            duration: const Duration(milliseconds: 200),
            crossFadeState: isOpened ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Swipe down to see map', style: textStyle),
                const SizedBox(height: 4),
                SvgPicture.asset('assets/icons/arrow-down.svg')
              ]
            ),
            secondChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/icons/arrow-up.svg'),
                const SizedBox(height: 4),
                const Text('Swipe up to see services', style: textStyle),
              ]
            ),
          ),
          Container(
            height: 4,
            width: 80,
            margin: const EdgeInsets.only(top: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          )
        ]
      ),
    );
  }
}


class _ScreenBodyMap extends StatelessWidget {
  const _ScreenBodyMap();

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<BusinessRepository>(context);
    const lightUrl = 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=$mapboxToken';
    const darkUrl = 'https://api.mapbox.com/styles/v1/mapbox/dark-v10/tiles/{z}/{x}/{y}?access_token=$mapboxToken';

    return FutureBuilder(
      future: Future.wait([
        repository.getUserPosition(),
        repository.getDiscoverPopularNearbyMap()
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProgressWidget();
        }

        final PositionModel position = snapshot.data![0] as PositionModel;
        final businesses = snapshot.data![1] as List;

        return BlocBuilder<ThemeModeCubit, bool>(
          builder: (context, isDark) => FlutterMap(
            options: MapOptions(
              initialZoom: 12,
              initialCenter: LatLng(position.latitude, position.longitude),
            ),
            children: [
              TileLayer(
                urlTemplate: isDark ? darkUrl : lightUrl,
                additionalOptions: const {
                  'accessToken': mapboxToken,
                  'id': 'mapbox/streets-v11',
                },
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(position.latitude, position.longitude),
                    child: SvgPicture.asset(
                      'assets/icons/location-bold.svg',
                      colorFilter: const ColorFilter.mode(Support.red1, BlendMode.srcIn),
                    )
                  ),
                  
                  ... businesses.map<Marker>((item) {
                    final BusinessModel business = item['business'];
                    final double price = item['price'];

                    return Marker(
                      width: 80,
                      height: 35,
                      point: LatLng(business.location.latitude, business.location.longitude),
                      child: _BusinessMarker(
                        business: business,
                        price: price,
                        isDark: isDark
                      )
                    );
                  })
                ],
              )
            ],
          )
        );
      }
    );
  }
}

class _BusinessMarker extends StatelessWidget {
  const _BusinessMarker({required this.business, required this.price, required this.isDark});

  final BusinessModel business;
  final double price;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //  Show business details
        context.push(Routes.details.path, extra: business);
      },
      child: Material(
        elevation: 6,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(width: 1, color: isDark ? Support.dBlack2 : Primary.darkGreen3.withOpacity(0.4))
        ),
        child: Center(
          child: Text(
            '\$${price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              height: 1.6,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}