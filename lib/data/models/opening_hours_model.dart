import 'package:recase/recase.dart';
import 'package:intl/intl.dart';
import 'enums.dart' show WeekDays;

class OpeningHoursModel {
  final WeekDays day;
  final String open;
  final String close;

  OpeningHoursModel({
    required this.day,
    required this.open,
    required this.close
  });

  OpeningHoursModel.fromJson(oh):
    day = WeekDays.values.byName(oh['day']),
    open = oh['open'],
    close = oh['close']
  ;

  static String _formatTime(String time) {
    DateTime parsedTime = DateFormat('hh:mm a').parse(time);
    String formattedTime = DateFormat('h a').format(parsedTime);

    return ReCase(formattedTime).titleCase.split(' ').join();
  }

  static String formatedOpeningHour(List<OpeningHoursModel> openings) {
    final today = WeekDays.values.byName(DateFormat('EEEE').format(DateTime.now()).toLowerCase());
    final openingHour = openings.firstWhere((item) => item.day==today);
    String formated = '';

    if (openingHour.open == 'Closed') {
      int next = 1;

      while(true) {
        final nextDay = WeekDays.values.byName(DateFormat('EEEE').format(
          DateTime.now().add(Duration(days: next))
        ).toLowerCase());
        final nextOpeningHour = openings.firstWhere((item) => item.day==nextDay);

        if (nextOpeningHour.open != "Closed") {
          final day = ReCase(nextOpeningHour.day.name.substring(0, 3)).titleCase;
          formated = 'Closed ($day ${_formatTime(nextOpeningHour.open)} - ${_formatTime(nextOpeningHour.close)})';
          break;
        } else if (next >= 8) {
          formated = "Closed";
          break;
        } else {
          next++;
        }
      }
    } else {
      formated = '${_formatTime(openingHour.open)} - ${_formatTime(openingHour.close)}';
    }
    return formated;
  }
}