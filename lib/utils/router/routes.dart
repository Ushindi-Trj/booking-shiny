class RoutesModel {
  final String name;
  final String path;

  const RoutesModel({required this.name, required this.path});
}

class Routes {
  static const RoutesModel onboarding = RoutesModel(name: 'onboarding', path: '/');
  static const RoutesModel signup = RoutesModel(name: 'signup', path: '/signup');
  static const RoutesModel login = RoutesModel(name: 'login', path: '/login');

  //  Home Navigation
  static const RoutesModel discover = RoutesModel(name: 'discover', path: '/');
  static const RoutesModel booking = RoutesModel(name: 'booking', path: '/booking');
  static const RoutesModel favorite = RoutesModel(name: 'favorite', path: '/favorite');
  static const RoutesModel profile = RoutesModel(name: 'profile', path: '/profile');

  //  Profile sub-screens
  static const RoutesModel profileEdit = RoutesModel(name: 'edit', path: '/profile/edit');
  static const RoutesModel paymentMethods = RoutesModel(name: 'payment-methods', path: '/profile/payment-methods');

  //  Discover sub-screens
  static const RoutesModel businessFilter = RoutesModel(name: 'filter/:category', path: 'filter/:category');
  static const RoutesModel popularBusinesses = RoutesModel(name: 'popular', path: '/popular');
  static const RoutesModel history = RoutesModel(name: 'history', path: '/history');

  static const RoutesModel details = RoutesModel(name: 'details', path: '/details');
  static const RoutesModel checkout = RoutesModel(name: 'checkout', path: '/checkout');
  static const RoutesModel promotion = RoutesModel(name: 'promotion', path: '/promotion');
  static const RoutesModel addPaymentMethod = RoutesModel(name: 'add-payment-method', path: '/add-payment-method');
  static const RoutesModel updatePaymentMethod = RoutesModel(name: 'update-payment-method', path: '/update-payment-method');
}