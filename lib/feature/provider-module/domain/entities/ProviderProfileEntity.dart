import 'package:equatable/equatable.dart';

class ProviderProfileEntity extends Equatable {
  final int profileId;
  final String companyName;
  final String taxId;
  final double balance;
  final String planName;
  final int maxClients;
  final int currentClientCount;
  final int activeServiceRequests;

  const ProviderProfileEntity({
    required this.profileId,
    required this.companyName,
    required this.taxId,
    required this.balance,
    required this.planName,
    required this.maxClients,
    required this.currentClientCount,
    required this.activeServiceRequests,
  });

  @override
  List<Object?> get props => [
    profileId,
    companyName,
    taxId,
    balance,
    planName,
    maxClients,
    currentClientCount,
    activeServiceRequests,
  ];
}