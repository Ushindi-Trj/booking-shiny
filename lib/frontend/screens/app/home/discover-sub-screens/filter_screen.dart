import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booking_shiny/backend/cubit/cubits.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key, required this.category});

  final String category;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final DraggableScrollableController _scrollableController = DraggableScrollableController();
  late bool isMaxSized = false;

  @override
  void initState() {
    _scrollableController.addListener(() {
      setState(() {
        if (_scrollableController.size >= .867) {
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: AnimatedContainer(
          color: isMaxSized ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
          curve: Curves.easeIn,
          height: double.infinity,
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PopButton(isMaxSized: isMaxSized)
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          Stack(
            children: [
              SizedBox.fromSize(
                size: const Size(double.infinity, 260),
                child: Image.asset('assets/images/${widget.category}-category.jpg', fit: BoxFit.cover,),
              ),
              Container(
                height: 260,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(0.5, 0.4),
                    end: FractionalOffset(0.5, 1.0),
                    colors: [Colors.transparent, Support.dBlack2])
                )
              )
            ],
          ),

          DraggableScrollableSheet(
            controller: _scrollableController,
            snap: true,
            minChildSize: .695,
            maxChildSize: .870,
            initialChildSize: .695,
            builder: (context, scrollController) => AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              decoration: BoxDecoration(
                borderRadius: draggableBorderRadius,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: ClipRRect(
                borderRadius: draggableBorderRadius,
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: !isMaxSized,
                        child: Center(child: Container(
                          height: 4,
                          width: 80,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Theme.of(context).colorScheme.secondaryContainer
                          ),
                        ))
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          ReCase(widget.category).titleCase,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        child: Text(
                          'More Than 100+ hairCut & Salon near by you',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          spacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: _SelectorDropdown(
                                width: 100,
                                items: const ['gender', 'male', 'female', 'unisex', 'kids'],
                                onChanged: (value) {
                                  print('Selected: $value');
                                }
                              ),
                            ),
                            _SelectorDropdown(
                              width: 125,
                              items: const ['Price', '\$ 10 - 20', '\$ 20 - 50', '\$ 50 - 100', '\$ 100 - Over'],
                              onChanged: (value) {
                                print('Selected: $value');
                              }
                            ),
                            _SelectorDropdown(
                              width: 160,
                              items: const ['Location', 'Current Location', 'Nearby', 'Withing 10km', 'City'],
                              onChanged: (value) {
                                print('Selected: $value');
                              }
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: _SelectorDropdown(
                                width: 140,
                                items: const ['Special Offers', '10% Off', '30% Off', '50% Off', '75% Off'],
                                onChanged: (value) {
                                  print('Selected: $value');
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Container(
                        height: 8,
                        margin: const EdgeInsets.only(top: 24, bottom: 32),
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Nearest Barbershop',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                        ),
                      ),
                      ListView.builder(
                        itemCount: 12,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Text('Item: $index');
                        }
                      )
                    ],
                  ),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}

class _SelectorDropdown extends StatelessWidget {
  const _SelectorDropdown({required this.width, required this.items, required this.onChanged});

  final double width;
  final List<String> items;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(width, 34),
      child: DropdownButtonFormField(
        onChanged: onChanged,
        value: items.first,
        elevation: 2,
        decoration: InputDecoration(
          border: _borderStyle(context),
          enabledBorder: _borderStyle(context),
          focusedBorder: _borderStyle(context),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6)
        ),
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
          height: 1.6,
          fontWeight: FontWeight.w500
        ),
        icon: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: SvgPicture.asset(
            'assets/icons/arrow-down.svg',
            width: 14, height: 14,
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
          ),
        ),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(toBeginningOfSentenceCase(item)!)
        )).toList(),
      ),
    );
  }

  OutlineInputBorder _borderStyle(context) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: BorderSide(
      width: 1,
      color: Theme.of(context).colorScheme.primaryContainer
    )
  );
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

        return SizedBox.fromSize(
          size: const Size(44, 44),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Material(
              color: isMaxSized ? Colors.transparent : Palette.white.withOpacity(.20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(width: 1.5, color: borderColor)
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: SvgPicture.asset(
                  'assets/icons/pop.svg',
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                )
              ),
            ),
          ),
        );
      }
    );
  }
}