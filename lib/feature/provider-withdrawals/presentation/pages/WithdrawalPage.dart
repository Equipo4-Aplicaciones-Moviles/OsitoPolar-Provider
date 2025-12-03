import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:osito_polar_app/core/theme/app_colors.dart';
// Asegúrate de que este import apunte a donde guardaste tu WithdrawalProvider
import 'package:osito_polar_app/feature/provider-withdrawals/presentation/providers/WithdrawalProviders.dart';

class ProviderWithdrawalPage extends StatefulWidget {
  const ProviderWithdrawalPage({super.key});

  @override
  State<ProviderWithdrawalPage> createState() => _ProviderWithdrawalPageState();
}

class _ProviderWithdrawalPageState extends State<ProviderWithdrawalPage> {
  final _amountController = TextEditingController();
  String _selectedMethod = "Transferencia BCP";

  @override
  void initState() {
    super.initState();
    // Cargar balance real al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WithdrawalProvider>().loadBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WithdrawalProvider>();
    final isLoading = provider.isLoading;
    final balance = provider.currentBalance;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text("Retirar Fondos", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. TARJETA DE BALANCE ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryButton, Color(0xFF0277BD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppColors.primaryButton.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  const Text("Saldo Disponible", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  isLoading && balance == 0
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "S/ ${balance.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text("Verificado", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 2. FORMULARIO DE RETIRO ---
            const Text("Solicitar Retiro", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Monto a retirar", style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      prefixText: "S/ ",
                      hintText: "0.00",
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Destino", style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMethod,
                        isExpanded: true,
                        items: ["Transferencia BCP", "Interbank", "Yape", "Plin"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => _selectedMethod = val!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _processWithdrawal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Confirmar Retiro", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. HISTORIAL (Visual) ---
            const Text("Historial Reciente", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildHistoryItem("28 Nov", "Transferencia BCP", "- S/ 500.00", Colors.red),
            _buildHistoryItem("15 Nov", "Pago de Servicio #402", "+ S/ 150.00", Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String date, String title, String amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: Icon(
                amount.startsWith('+') ? Icons.arrow_downward : Icons.arrow_upward,
                color: amount.startsWith('+') ? Colors.green : Colors.red,
                size: 20
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Future<void> _processWithdrawal() async {
    final provider = context.read<WithdrawalProvider>();
    final amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Monto inválido"), backgroundColor: Colors.red));
      return;
    }
    if (amount > provider.currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saldo insuficiente"), backgroundColor: Colors.orange));
      return;
    }

    final success = await provider.requestWithdrawal(amount, _selectedMethod);

    if (mounted) {
      if (success) {
        _amountController.clear();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 10),
                Text("¡Solicitud Exitosa!", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text("Tu dinero estará en tu cuenta en las próximas 24 horas.", textAlign: TextAlign.center),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Entendido"))],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.errorMessage), backgroundColor: Colors.red));
      }
    }
  }
}