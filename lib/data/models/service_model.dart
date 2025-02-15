class DurationModel {
  DurationModel({required this.duration, required this.price});
  
  final String duration;
  final double price;

  DurationModel.fromJson(doc):
    duration = doc['duration'],
    price = double.parse(doc['price'].toString())
  ;
}

class ServiceModel {
  final String id;
  final String businessId;
  final String name;
  final String description;
  final String image;
  final List<DurationModel> duration;
  final DateTime created;
  final DateTime updated;

  ServiceModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.image,
    required this.duration,
    required this.created,
    required this.updated,
  });

  ServiceModel.fromJson(doc):
    id = doc.id,
    businessId = doc['business_id'],
    name = doc['name'],
    description = doc['description'],
    image = doc['image'],
    duration = (doc['duration'] as List).map((e) => DurationModel.fromJson(e)).toList(),
    created = DateTime.parse(doc['created']),
    updated = DateTime.parse(doc['updated'])
  ;
}