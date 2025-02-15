import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking_shiny/data/models/models.dart';

// import 'package:shiny_booking/data/repositories/business_repository.dart';

class BookingRepository {

  //  Get business's cart
  Future<CartModel> getCart(String business) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final request = await FirebaseFirestore.instance.collection('cart')
      .where('user_id', isEqualTo: user)
      .where('business_id', isEqualTo: business)
      .limit(1)
      .get()
    ;
    return CartModel.fromJson(request.docs.first);
  }
  
  //  Get cart from id
  Future<CartModel> getSingleCart(String id) async {
    final request = await FirebaseFirestore.instance.collection('cart').doc(id).get();
    return CartModel.fromJson(request);
  }

  //  Get service's promotions
  Future<List<PromotionModel>> getPromotions(List<String> servicesId) async {
    final List<PromotionModel> promotions = [];

    try {
      for (var serviceId in servicesId) {
        final request = await FirebaseFirestore.instance.collection('promotions')
          .where('service_id', isEqualTo: serviceId)
          .get()
        ;

        for (var response in request.docs) {
          promotions.add(PromotionModel.fromJson(response));
        }
      }
      return promotions;
    } on FirebaseException catch(error) {
      throw Exception(error.message);
    } catch(e) {
      rethrow;
    }
  }

  //  Get single promotion
  Future<PromotionModel?> getPromotion(promotionId) async {
    try {
      final request = await FirebaseFirestore.instance.collection('promotions').doc(promotionId).get();

      if (request.exists) {
        return PromotionModel.fromJson(request);
      }
    } on FirebaseException catch(e) {
      print(e.message);
    } catch(e) {
      print(e);
    }
    return null;
  }

  //  Select a promotion
  Future<void> selectPromotion({cartId, serviceId, promotionId}) async {
    final database = FirebaseFirestore.instance.collection('cart');
    final cart = CartModel.fromJson(await database.doc(cartId).get());
    late List<dynamic> items = [];

    for (var item in cart.items) {
      if (item.serviceId == serviceId) {
        item.promotionId = promotionId;
      }
      items.add(item);
    }

    items = items.map((e) => CartItemModel.toJson(
      serviceId: e.serviceId,
      serviceName: e.serviceName,
      promotionId: e.promotionId,
      duration: e.duration,
      price: e.price
    )).toList();

    await database.doc(cartId).update({
      'items': items,
      'updated': DateTime.now().toIso8601String(),
    });
  }

  //  Check if it's the selected promotion
  Stream<bool> isPromotionSelected({cartId, promotionId}) async* {
    try {
      final request = FirebaseFirestore.instance.collection('cart').doc(cartId).snapshots();
      final items = request.map((event) => CartModel.fromJson(event).items);
      final promotions = items.map((event) => event.map((e) => e.promotionId).toList());

      yield* promotions.map((event) => event.contains(promotionId));
    } catch(e) {
      print(e);
    }
  }

  //  Get total, subtotal and promotion of cart (stream)
  Stream<Map<String, dynamic>> getStreamCartSubtotal(cartId) async* {
    try {
      final request = FirebaseFirestore.instance.collection('cart').doc(cartId).snapshots();
      final response = request.map((event) => event.data()!['items'] as List);

      await for (List<dynamic> result in response) {
        final calculatedTotals = await calculateTotals(result);
        yield* Stream.value(calculatedTotals);
      }
    } on FirebaseException catch(e) {
      print('Error: ${e.message}');
    } catch(e) {
      print('Error: $e');
    }
  }

  //  Calculate the cart subtotal
  Future<Map<String, dynamic>> calculateTotals(List<dynamic> result) async {
    double total = 0.00;
    double discount = 0.00;
    double subTotal = 0.00;
    
    for (var res in result) {
      final item = CartItemModel.fromJson(res);
      total += item.price;

      if (item.promotionId != null) {
        final promotion = await getPromotion(item.promotionId);

        if (promotion != null) {
          discount += (item.price * (promotion.percentage / 100.0));
        }
      }
    }

    subTotal = total - discount;

    return {
      'total': total,
      'discount': discount,
      'subtotal': subTotal
    };
  }

  //  Place booking
  Future<void> placeBooking({cartId, dateTime, paymentCardId}) async {
    try {
      cartId = cartId.toString();
      dateTime = dateTime as DateTime;
      paymentCardId = paymentCardId.toString();

      if (dateTime.isBefore(DateTime.now()) || dateTime.isAtSameMomentAs(DateTime.now())) {
        throw Exception('Date Time Error: Please select a correct booking date and time');
      }

      /* Get cart 
      final user = FirebaseAuth.instance.currentUser!.uid;
      final cart = await getSingleCart(cartId);
      final totals = await calculateTotals(cart.items);
      final business = await BusinessRepository().getBusiness(business: cart.business);
      */

      print(cartId);

    } catch(e) {
      print(e);
    }
  }
}