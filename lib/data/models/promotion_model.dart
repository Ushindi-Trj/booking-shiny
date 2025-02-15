class PromotionModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final String name;
  final int percentage;
  final String description;
  final int redemptionLimits; // maximum times of usage
  final List<String> couponCodes; // Promotion code

  final DateTime start;
  final DateTime end;
  final DateTime created;
  final DateTime updated;

  final bool isActive;

  PromotionModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.name,
    required this.description,
    required this.couponCodes,
    required this.percentage,
    required this.redemptionLimits,
    required this.start,
    required this.end,
    required this.created,
    required this.updated,

    this.isActive = false
  });

  factory PromotionModel.fromJson(doc) {
    final DateTime startDate = DateTime.parse(doc['start']);
    final DateTime endDate = DateTime.parse(doc['end']);
    final bool isActive = startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now());

    return PromotionModel(
      id: doc.id,
      serviceId: doc['service_id'],
      serviceName: doc['service_name'],
      name: doc['name'],
      description: doc['description'],
      couponCodes: List<String>.from(doc['coupon_codes']),
      percentage: int.parse(doc['percentage'].toString()),
      redemptionLimits: int.parse(doc['redemption_limit'].toString()),
      start: startDate,
      end: endDate,
      created: DateTime.parse(doc['created']),
      updated: DateTime.parse(doc['updated']),
      isActive: isActive
    );
  }
}