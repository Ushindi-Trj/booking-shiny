class PaymentMethodModel {
  final String id;
  final String holderName;
  final String last4digits;
  final String cardBrand;
  final String expiryYear;
  final String expiryMonth;
  final String fundingType;

  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.holderName,
    required this.expiryYear,
    required this.expiryMonth,
    required this.fundingType,
    required this.last4digits,
    required this.cardBrand,
    this.isDefault = false
  });

  factory PaymentMethodModel.fromJson([data, isDefault = false]) {
    return PaymentMethodModel(
      id: data['id'],
      holderName: data['name'],
      last4digits: data['last4'],
      cardBrand: data['brand'].toString().toLowerCase(),
      expiryYear: data['exp_year'].toString().substring(2),
      expiryMonth: data['exp_month'].toString().padLeft(2, '0'),
      fundingType: data['funding'],
      isDefault: isDefault
    );
  }
}