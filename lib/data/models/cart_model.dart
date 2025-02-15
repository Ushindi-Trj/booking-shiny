class CartItemModel {
  final String serviceId;
  final String serviceName;
  final String duration;
  final double price;
  String? promotionId; //  Promotion id for selected service

  CartItemModel({
    required this.serviceId,
    required this.serviceName,
    required this.duration,
    required this.price,
    this.promotionId,
  });

  CartItemModel.fromJson(item):
    serviceId = item['service_id'],
    serviceName = item['service_name'],
    promotionId = item['promotion_id'],
    duration = item['duration'].toString(),
    price = double.parse(item['price'].toString())
  ;

  static Map<String, dynamic> toJson({serviceId, serviceName, price, duration, promotionId}) => {
    'service_id': serviceId,
    'service_name': serviceName,
    'duration': duration,
    'price': price,
    'promotion_id': promotionId,
  };
}

class CartModel {
  final String id;
  final String user;
  final String business;
  final List<CartItemModel> items;
  final DateTime created;
  final DateTime updated;

  CartModel({
    required this.id,
    required this.user,
    required this.business,
    required this.items,
    required this.created,
    required this.updated
  });

  factory CartModel.fromJson(doc) {
    final List<CartItemModel> docItems = [];

    for (var item in doc['items']) {
      docItems.add(CartItemModel.fromJson(item));
    }

    return CartModel(
      id: doc.id,
      user: doc['user_id'],
      business: doc['business_id'],
      items: docItems,
      created: DateTime.parse(doc['created']),
      updated: DateTime.parse(doc['updated']),
    );
  }

  static Map<String, dynamic> toJson({user, business, serviceId, serviceName, duration, price, promotionId}) {
    return {
      'user_id': user,
      'business_id': business,
      'items': [
        CartItemModel.toJson(
          serviceId: serviceId,
          serviceName: serviceName,
          duration: duration,
          price: price,
          promotionId: promotionId
        )
      ],
      'created': DateTime.now().toIso8601String(),
      'updated': DateTime.now().toIso8601String()
    };
  }
}