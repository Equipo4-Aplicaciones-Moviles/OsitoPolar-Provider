import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:osito_polar_app/core/error/Exceptions.dart';
import '../../domain/entities/WithdrawalBalanceEntity.dart';

// --- MODELO ---
class WithdrawalBalanceModel extends WithdrawalBalanceEntity {
  const WithdrawalBalanceModel({required super.availableBalance, required super.currency});

  factory WithdrawalBalanceModel.fromJson(String str) =>
      WithdrawalBalanceModel.fromMap(json.decode(str));

  factory WithdrawalBalanceModel.fromMap(Map<String, dynamic> json) {
    return WithdrawalBalanceModel(
      availableBalance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'PEN', // Valor por defecto si no viene
    );
  }
}

// --- DATASOURCE ---
abstract class WithdrawalRemoteDataSource {
  Future<WithdrawalBalanceModel> getProviderBalance();
  Future<void> requestWithdrawal({required double amount, required String paymentMethod});
}

class WithdrawalRemoteDataSourceImpl implements WithdrawalRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;
  final String baseUrl;

  WithdrawalRemoteDataSourceImpl({required this.client, required this.prefs})
      : baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';

  @override
  Future<WithdrawalBalanceModel> getProviderBalance() async {
    final token = prefs.getString('auth_token');
    if (token == null) throw ServerException(message: 'Token no encontrado');

    final url = Uri.parse('$baseUrl/api/v1/provider-withdrawals/balance');

    try {
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return WithdrawalBalanceModel.fromJson(response.body);
      } else {
        throw ServerException(message: 'Error al obtener balance: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> requestWithdrawal({required double amount, required String paymentMethod}) async {
    final token = prefs.getString('auth_token');
    if (token == null) throw ServerException(message: 'Token no encontrado');

    final url = Uri.parse('$baseUrl/api/v1/provider-withdrawals/request');

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "amount": amount,
          "paymentMethod": paymentMethod
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        String msg = 'Error ${response.statusCode}';
        try {
          final body = jsonDecode(response.body);
          if (body['message'] != null) msg = body['message'];
        } catch (_) {}
        throw ServerException(message: msg);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}