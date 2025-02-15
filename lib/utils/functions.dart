//  format minutes to hours
String durationToString(String duration) {
  final format = Duration(minutes: int.parse(duration.split(' ').first));
  final hours = format.inHours;
  final minutes = (format.inMinutes % 60);

  if (format.inHours > 0) {
    if (minutes > 0) {
      return '${hours}h $minutes minutes';
    }
    return '$hours hour${hours>1 ? 's' : ''}';
  }
  return '$minutes minutes';
}

//  Form mat numbers to show 1k, 1M, 1.3k etc...
String formatNumber(int number) {
  if (number >= 1000) {
    return '${(number/1000).toStringAsFixed(1)}k';
  } else if (number >= 1000000) {
    return '${(number/1000000).toStringAsFixed(1)}M';
  } else {
    return number.toString();
  }
}