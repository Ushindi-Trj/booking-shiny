import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:booking_shiny/data/models/models.dart' show OpeningHoursModel;

class TableCalendarDatePicker extends StatefulWidget {
  const TableCalendarDatePicker({
    super.key,
    required this.openingHours,
    required this.onDateSelected,
    required this.selectedDate
  });

  final List<OpeningHoursModel> openingHours;
  final Function(DateTime) onDateSelected;
  final DateTime selectedDate;

  @override
  State<TableCalendarDatePicker> createState() => _TableCalendarDatePickerState();
}

class _TableCalendarDatePickerState extends State<TableCalendarDatePicker> {
  late PageController _pageController;
  late DateTime _selectedDate = widget.selectedDate;
  late DateTime _firstDate;
  late DateTime _lastDate;

  @override
  void initState() {
    _firstDate = _selectedDate;
    _lastDate = DateTime.utc(
      _firstDate.year,
      _firstDate.month + 3,
      DateTime(_firstDate.year, (_firstDate.month+3) + 1, 0).day
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.primaryContainer;
    final TextStyle textStyle = Theme.of(context).textTheme.labelMedium!.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500
    );
    final TextStyle disabledTextStyle = Theme.of(context).textTheme.labelSmall!.copyWith(
      height: 1.3
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: borderColor)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(
                    DateFormat.yMMMM().format(_selectedDate),
                    style: textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox.fromSize(
                  size: const Size(90, 53),
                  child: Row(children: [
                    Expanded(child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeIn
                          );
                        },
                        padding: const EdgeInsets.all(13.5),
                        child: SvgPicture.asset(
                          'assets/icons/arrow-left.svg',
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                        ),
                      ),
                    )),
                    Expanded(child: SizedBox.expand(
                      child: MaterialButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOut
                          );
                        },
                        padding: const EdgeInsets.all(13.5),
                        child: SvgPicture.asset(
                          'assets/icons/arrow-right.svg',
                          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn)
                        ),
                      ),
                    )),
                  ]),
                )
              ],
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: borderColor,
              margin: const EdgeInsets.only(bottom: 16),
            ),
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: _firstDate,
              lastDay: _lastDate,
              rowHeight: 38,
              daysOfWeekHeight: 25,
              headerVisible: false,
              sixWeekMonthsEnforced: true,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onCalendarCreated: (controller) => _pageController = controller,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              enabledDayPredicate: (day) {
                final weekday = DateFormat('EEEE').format(day).toLowerCase();
                final closedDays = widget.openingHours.where((item) => item.open == 'Closed').toList()
                  .map((e) => e.day.name).toList()
                ;
                
                return !closedDays.contains(weekday);
              },
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: textStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold),
                weekendStyle: textStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold)
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                cellMargin: EdgeInsets.zero,
                cellPadding: EdgeInsets.zero,
                tablePadding: EdgeInsets.zero,
                cellAlignment: Alignment.center,
                defaultTextStyle: textStyle,
                weekendTextStyle: textStyle,
                disabledTextStyle: disabledTextStyle,
                outsideTextStyle: disabledTextStyle,
                selectedTextStyle: const TextStyle(fontSize: 16, color: Support.orange2),
                selectedDecoration: const BoxDecoration(color: Primary.darkGreen1, shape: BoxShape.circle),
                todayTextStyle: textStyle,
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Secondary.grey1.withOpacity(0.3))
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                widget.onDateSelected(selectedDay);
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  if (focusedDay.isAfter(_firstDate) || focusedDay.isAtSameMomentAs(_firstDate)) {
                    _selectedDate = DateTime(focusedDay.year, focusedDay.month, _selectedDate.day);
                  } else {
                    _selectedDate = focusedDay;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}