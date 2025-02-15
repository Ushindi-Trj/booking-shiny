import 'location_model.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final String profile;
  final LocationModel? address;
  final String stripeCustomerId;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    required this.profile,
    this.address,
    required this.stripeCustomerId
  });

  factory UserModel.fromJson(doc) {
    final LocationModel? addr = doc['address'] == null ? null : LocationModel.fromJson(
      doc['address']
    );

    return UserModel(
      id: doc.id,
      username: doc['username'],
      email: doc['email'],
      phone: doc['phone'],
      profile: doc['profile'],
      address: addr,
      stripeCustomerId: doc['stripe_customer_id']
    );
  }
}