import 'models.dart';

class BusinessModel {
  final String id;
  final String owner;
  final String name;
  final String phone;
  final String email;
  final String? website;
  final String description;
  final List<String> images;
  final List<Categories> category;
  final LocationModel location;
  final RatingModel ratings;
  final List<Genders> genders;
  final List<OpeningHoursModel> openingHours;
  final CancellationPolicy cancellationPolicy;
  final DateTime created;

  BusinessModel({
    required this.id,
    required this.owner,
    required this.name,
    required this.phone,
    required this.email,
    required this.description,
    required this.images,
    required this.category,
    required this.location,
    required this.ratings,
    required this.genders,
    required this.openingHours,
    required this.cancellationPolicy,
    required this.created,
    this.website,
  });

  BusinessModel.fromJson(doc):
    id = doc.id,
    owner = doc['owner'],
    name = doc['name'],
    phone = doc['phone'],
    email = doc['email'],
    website = doc['website'],
    description = doc['description'],
    images = (doc['images'] as List).map((e) => e as String).toList(),
    category = (doc['categories'] as List).map((e) => Categories.values.byName(e)).toList(),
    location = LocationModel.fromJson(doc['location']),
    ratings = RatingModel.fromJson(doc['ratings']),
    genders = (doc['genders'] as List).map((e) => Genders.values.byName(e)).toList(),
    openingHours = (doc['opening_hours'] as List).cast<Map>().map((item) => OpeningHoursModel.fromJson(item)).toList(),
    cancellationPolicy = CancellationPolicy.fromJson(doc['cancellation_policy']),
    created = DateTime.parse(doc['created'])
  ;
}

class RatingModel {
  RatingModel({required this.totalRatings, required this.rating});
  RatingModel.fromJson(rattings):
    rating = rattings['rating'],
    totalRatings = rattings['total_ratings']
  ;

  final double rating; // 3.8 (ratio between 0-5)
  final int totalRatings; // 12k (sum of all collected ratings)
}

class CancellationPolicy {
  CancellationPolicy({required this.description, required this.deadlines});
  CancellationPolicy.fromJson(cp):
    description = cp['description'],
    deadlines = (cp['deadlines'] as List).map((e) => DeadlineModel.fromJson(e)).toList()
  ;

  final String description;
  final List<DeadlineModel> deadlines;
}

class DeadlineModel {
  final int hours;
  final int percentage;

  DeadlineModel({required this.hours, required this.percentage});
  DeadlineModel.fromJson(dl):
    hours = dl['hours'],
    percentage = dl['percentage']
  ;
}