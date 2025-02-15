import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:booking_shiny/data/models/models.dart' show OpeningHoursModel;

import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class SelectDateTimeModal extends StatefulWidget {
  const SelectDateTimeModal({
    super.key,
    required this.openingHours,
    required this.onSelected,
    required this.selectedDateTime
  });

  final List<OpeningHoursModel> openingHours;
  final Function(DateTime) onSelected;
  final DateTime selectedDateTime;

  @override
  State<SelectDateTimeModal> createState() => _SelectDateTimeModalState();
}

class _SelectDateTimeModalState extends State<SelectDateTimeModal> {
  late DateTime _selectedDateTime = widget.selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32))
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  )
                ),
              ),
              Text(
                'Select Date & Time',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 32),
                child: TableCalendarDatePicker(
                  openingHours: widget.openingHours,
                  selectedDate: _selectedDateTime,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        _selectedDateTime.hour,
                        _selectedDateTime.minute,
                        _selectedDateTime.second
                      );
                      widget.onSelected(_selectedDateTime);
                    });
                  },
                ),
              ),
              Text(
                'Time for the appointment',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 32),
                child: OutlinedButton(
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: _selectedDateTime.hour,
                        minute: _selectedDateTime.minute
                      ),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(data: ThemeData.dark(), child: child!,);
                      }
                    );

                    if (selectedTime != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          _selectedDateTime.year,
                          _selectedDateTime.month,
                          _selectedDateTime.day,
                          selectedTime.hour,
                          selectedTime.minute,
                          _selectedDateTime.second
                        );
                        widget.onSelected(_selectedDateTime);
                      });
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(width: 1, color: Theme.of(context).colorScheme.primaryContainer)
                    )
                  ),
                  child: Text(
                    DateFormat('hh:mm a').format(_selectedDateTime),
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ),
              ),
              ElevatedButtonWidget(
                text: 'Confirm',
                onClicked: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
