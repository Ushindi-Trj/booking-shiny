class LocationModel {
  final String? address;
  final double longitude;
  final double latitude;

  LocationModel({
    required this.address,
    required this.longitude,
    required this.latitude
  });

  LocationModel.fromJson(location):
    longitude = location['longitude'],
    latitude = location['latitude'],
    address = location['address']
  ;
}

class PositionModel {
  final double longitude;
  final double latitude;

  PositionModel({required this.longitude, required this.latitude});

  PositionModel.fromJson(position):
    longitude = position['longitude'],
    latitude = position['latitude']
  ;
}