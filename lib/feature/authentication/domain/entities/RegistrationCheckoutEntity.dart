import 'package:equatable/equatable.dart';

class RegistrationCheckoutEntity extends Equatable {
  final String checkoutUrl;
  final String sessionId;

  const RegistrationCheckoutEntity({
    required this.checkoutUrl,
    required this.sessionId,
  });

  @override
  List<Object> get props => [checkoutUrl, sessionId];
}