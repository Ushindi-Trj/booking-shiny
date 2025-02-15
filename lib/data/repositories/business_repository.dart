import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'booking_repository.dart';

class BusinessRepository {  
  //  Get single business
  Future<BusinessModel> getBusiness({business}) async {
    final request = await FirebaseFirestore.instance.collection('business').doc(business).get();
    final result = BusinessModel.fromJson(request);
    return result;
  }

  //  Get the populart nearest business in discover screen
  Future<List<BusinessModel>> getDiscoverPopularNearby() async {
    final database = FirebaseFirestore.instance.collection('business');
    final List<BusinessModel> businesses = [];
    try {
      final PositionModel? userPosition = await getUserPosition();

      await database.orderBy('ratings.rating', descending: true).get().then((result) {
        for (var doc in result.docs) {
          final business = BusinessModel.fromJson(doc);

          //  If user's coordinates are gotten, get only businesses that are in 30km round
          //  Else, all only a popular business
          if (userPosition != null) {
            if (checkDistance(
              lat1: userPosition.latitude,
              lon1: userPosition.longitude,
              lat2: business.location.latitude,
              lon2: business.location.longitude,
              distance: 200
            )) {
              businesses.add(business);
            }
          } else {
            businesses.add(business);
          }
          
          //  If already got 8 businesses, stop foreach
          if (businesses.length >= 8) break;
        }

        //  If nothing is found in round of 30km, add any popular business
        if (businesses.isEmpty) {
          businesses.addAll(
            result.docs.getRange(0, 7).map((item) => BusinessModel.fromJson(item))
          );
        }
      });
    } catch(error) {
      rethrow;
    }
    return businesses;
  }

  //  Get the populart nearest businesses in discover screen map
  Future<List> getDiscoverPopularNearbyMap() async {
    final List datas = [];
    try {
      final businesses = await getDiscoverPopularNearby();    

      for (var business in businesses) {
        final servicees = await getBusinessServices(business: business.id);
        final minPrice = servicees.map<double>((service) {
          return service.duration.map<double>((e) => e.price).reduce((a, b) => a<b ? a : b);
        }).reduce((a, b) => a<b ? a : b);

        datas.add({
          'business': business,
          'price': minPrice
        });
      }  
    } catch(error) {
      rethrow;
    }
    return datas;
  }

  //  Get the populart nearest business in popular screen
  Future<List<BusinessModel>> getPopularNearby() async {
    final database = FirebaseFirestore.instance.collection('business');
    final List<BusinessModel> businesses = [];

    try {
      final PositionModel? coordinates = await getUserPosition();
      final query = await database.orderBy('ratings.rating', descending: true).get();

      for (var doc in query.docs) {
        final business = BusinessModel.fromJson(doc);

        if (coordinates != null) {
          if (checkDistance(
            lat1: coordinates.latitude,
            lon1: coordinates.longitude,
            lat2: business.location.latitude,
            lon2: business.location.longitude,
            distance: 200
          )) {
            businesses.add(business);
          }
        } else {
          businesses.add(business);
        }

        if (businesses.length >= 16) break;
      }

      if (businesses.isEmpty) {
        businesses.addAll(
          query.docs.getRange(0, 16).map((item) => BusinessModel.fromJson(item))
        );
      }
    } catch(error) {
      rethrow;
    }
    return businesses;
  }

  //  Get services for the given business id
  Future<List<ServiceModel>> getBusinessServices({business}) async {
    final List<ServiceModel> services = [];
    try {
      final query = await FirebaseFirestore.instance.collection('services').where('business_id', isEqualTo: business).get();
      for (var result in query.docs) {
        services.add(ServiceModel.fromJson(result));
      }
    } on FirebaseException catch(error) {
      throw Exception(error.message);
    } catch(error) {
      rethrow;
    }
    return services;
  }

  //  Add/Remove service to cart
  Future<void> addServiceToCart({businessId, serviceId, serviceName, duration, price, promotionId}) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final database = FirebaseFirestore.instance.collection('cart');

    try {
      //  First, get user's business cart
      final request = await database.where('user_id', isEqualTo: user).where('business_id', isEqualTo: businessId).get();

      if (request.size > 0) {
        final items = request.docs.first['items'] as List;
        final index = items.indexWhere((item) {
          return 
            item['service_id'] == serviceId && 
            item['service_name'] == serviceName &&
            item['duration'] == duration &&
            item['price'] == price
          ;
        });

        if (index != -1) {
          items.removeAt(index);

          if (items.isEmpty) {
            await database.doc(request.docs.first.id).delete();
          } else {
            await database.doc(request.docs.first.id).update({
              'items': items,
              'updated': DateTime.now().toIso8601String()
            });
          }
        } else {
          items.add(CartItemModel.toJson(
            serviceId: serviceId,
            serviceName: serviceName,
            duration: duration,
            price: price,
            promotionId: promotionId
          ));
          await database.doc(request.docs.first.id).update({
            'items': items,
            'updated': DateTime.now().toIso8601String()
          });
        }
      } else {
        await database.add(CartModel.toJson(
          user: user,
          business: businessId,
          serviceId: serviceId,
          serviceName: serviceName,
          duration: duration,
          price: price,
          promotionId: promotionId,
        ));
      }
    } on FirebaseException catch(error) {
      throw Exception(error.message);
    } catch(error) {
      rethrow;
    }
  }

   //  Remove service from cart
  Future<void> removeServiceFromCart(String businessId, CartItemModel item) async {
    final database =  FirebaseFirestore.instance.collection('cart');
    final CartModel cart = await BookingRepository().getCart(businessId);
    final List<CartItemModel> items = [];

    for (var cartItem in cart.items) {
      if (
        cartItem.serviceId != item.serviceId && 
        cartItem.serviceName != item.serviceName && 
        cartItem.duration != item.duration && 
        cartItem.price != item.price 
      ) {
        items.add(cartItem);
      }
    }

    if (items.isEmpty) {
      await database.doc(cart.id).delete();
    } else {
      await database.doc(cart.id).update({
        'items': items.map((e) => CartItemModel.toJson(
            serviceId: e.serviceId,
            serviceName: e.serviceName,
            price: e.price,
            duration: e.duration,
            promotionId: e.promotionId
          )).toList(),
        'updated': DateTime.now().toIso8601String()
      });
    }
  }

  //  Check if the service is in the cart
  Stream<bool> checkServiceInCart({service, business}) async* {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final request = FirebaseFirestore.instance.collection('cart')
      .where('user_id', isEqualTo: user)
      .where('business_id', isEqualTo: business)
      .limit(1)
      .snapshots()
    ;
    final result = request.map((result) {
      if (result.size > 0) {
        final items = result.docs.first['items'] as List;
        final index = items.indexWhere((item) => item['service_id']==service);

        return index != -1;
      } else {
        return false;
      }
    });

    yield* result;
  }

  //  Check if the service duration is in cart
  Stream<bool> checkServiceDurationInCart({business, service, duration}) async* {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final request = FirebaseFirestore.instance.collection('cart')
      .where('user_id', isEqualTo: user)
      .where('business_id', isEqualTo: business)
      .limit(1)
      .snapshots()
    ;
    final result = request.map<bool>((result) {
      if (result.size > 0) {
        final items = result.docs.first['items'] as List;
        final index = items.indexWhere((item) {
          return item['service_id']==service && item['duration']==duration;
        });

        return index != -1;
      } else {
        return false;
      }
    });

    yield* result;
  }

  //  Get cart items for floating button in details screen
  Stream<Map<String, num>?> getCartTotals({business}) async* {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final request = FirebaseFirestore.instance.collection('cart')
      .where('user_id', isEqualTo: user)
      .where('business_id', isEqualTo: business)
      .limit(1)
      .snapshots()
    ;
    final result = request.map((result) {
      if (result.size > 0) {
        final items = result.docs.first['items'] as List;
        final prices = items.map((e) => e['price'] as double).toList();

        return {
          'totalItems': items.length,
          'totalPrice': prices.reduce((value, element) => value + element)
        };
      }
      return null;
    });

    yield* result;
  }

  //  Get businesses from favorite
  Future<List<BusinessModel>> getFavoriteBusinesses() async {
    final favoriteDb = FirebaseFirestore.instance.collection('favorites');
    final businessDb = FirebaseFirestore.instance.collection('business');
    final user = FirebaseAuth.instance.currentUser!.uid;
    final List<BusinessModel> favorites = [];

    final results = await favoriteDb.where('user', isEqualTo: user).get();

    for (var result in results.docs) {
      final doc = await businessDb.doc(result['business']).get();
      final favorite = BusinessModel.fromJson(doc);
      favorites.add(favorite);
    }
    return favorites;
  }

  //  Add/Remove business to favorite
  Future<void> toggleFavorite(String businessId, bool isFavorite) async {
    try {
      final user = FirebaseAuth.instance.currentUser!.uid;
      final database = FirebaseFirestore.instance.collection('favorites');
      
      if (isFavorite) {
        await database.add({
          'user': user,
          'business': businessId,
          'added': DateTime.now().toIso8601String()
        });
      } else {
        final query = await database.where('user', isEqualTo: user).where('business', isEqualTo: businessId).limit(1).get();
        await database.doc(query.docs.first.id).delete();
      }
    } on FirebaseException catch(error) {
      throw Exception(error.message);
    } catch(error) {
      rethrow;
    }
  }

  //  Check if business is in favorite or not
  Stream<bool> checkFavorite(String businessId) async* {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final query = FirebaseFirestore.instance.collection('favorites')
      .where('user', isEqualTo: user)
      .where('business', isEqualTo: businessId)
      .snapshots()
    ;
    yield* query.map((result) => result.docs.isNotEmpty);
  }

  //  Add business to History (recent visited)
  Future<void> addHistory(String business) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final database = FirebaseFirestore.instance.collection('history');

    try {
      final query = await database
        .where('user', isEqualTo: user)
        .where('business', isEqualTo: business)
        .limit(1)
        .get()
      ;

      if (query.size > 0) {
        await database.doc(query.docs.first.id).update({
          'updated': DateTime.now().toIso8601String()
        });
      } else {
        await database.add({
          'user': user,
          'business': business,
          'added': DateTime.now().toIso8601String(),
          'updated': DateTime.now().toIso8601String(),
        });
      }
    } catch(error) {
      rethrow;
    }
  }

  //  Get user's visited business history
  Future<List<BusinessModel>> getHistory() async {
    final List<BusinessModel> history = [];
    final auth = FirebaseAuth.instance.currentUser!.uid;

    try {
      final request = await FirebaseFirestore.instance.collection('history').where('user', isEqualTo: auth).get();
      for (var result in request.docs) {
        final query = await FirebaseFirestore.instance.collection('business').doc(result['business']).get();
        if (query.exists) {
          final business = BusinessModel.fromJson(query);
          history.add(business);
        }
      }
    } catch(errror) {
      rethrow;
    }
    return history;
  }

  Future<PositionModel?> getUserPosition() async {
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      return null;
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return PositionModel(longitude: position.longitude, latitude: position.latitude);
  }

  bool checkDistance({lat1, lon1, lat2, lon2, distance}) {
    const hearthRadius = 6371e3;
    final phi1 = lat1 * math.pi / 180;
    final phi2 = lat2 * math.pi / 180;
    final deltaPhi = (lat2 - lat1) * math.pi / 180;
    final deltaLambda = (lon2 - lon1) * math.pi / 180;
    final a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
      math.cos(phi1) *
      math.cos(phi2) *
      math.sin(deltaLambda / 2) *
      math.sin(deltaLambda / 2)
    ;
    final distanceInMeters = hearthRadius * (2 * math.atan2(math.sqrt(a), math.sqrt(1 - a)));
    final distanceInKilometers = distanceInMeters/1000;
    return distanceInKilometers <= distance;
  }
}