class TwoFactorSecretModel {
  final String qrCodeDataUrl;
  final String manualEntryKey;

  TwoFactorSecretModel({required this.qrCodeDataUrl, required this.manualEntryKey});

  factory TwoFactorSecretModel.fromJson(Map<String, dynamic> json) {
    return TwoFactorSecretModel(
      qrCodeDataUrl: json['qrCodeDataUrl'] ?? '',
      manualEntryKey: json['manualEntryKey'] ?? '',
    );
  }
}