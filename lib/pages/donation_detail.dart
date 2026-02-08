import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay/pay.dart';
import 'package:final_project_flutter/l10n/app_localizations.dart';

class DonationDetailPage extends StatefulWidget {
  final QueryDocumentSnapshot donationData;

  const DonationDetailPage({super.key, required this.donationData});

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  int? selectedAmount;
  PaymentConfiguration? _googlePayConfig;

  @override
  void initState() {
    super.initState();
    _loadGooglePayConfig();
  }

  Future<void> _loadGooglePayConfig() async {
    final config =
        await PaymentConfiguration.fromAsset('google_pay.json');
    setState(() {
      _googlePayConfig = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List amounts = widget.donationData['amounts'];

    return Scaffold(
      appBar: AppBar(title: Text(widget.donationData['title'], style: Theme.of(context).textTheme.titleMedium,)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.donationData['image'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.donationData['image'],
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 16),

          Text(
            widget.donationData['title'],
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 12),

          Text(
            widget.donationData['description'],
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 24),

          Text(
            AppLocalizations.of(context)!.donationSelectAmount,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 10,
            children: amounts.map<Widget>((amt) {
              final isSelected = selectedAmount == amt;
              return ChoiceChip(
                label: Text('\$$amt'),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                selected: isSelected,
                onSelected: (_) {
                  setState(() => selectedAmount = amt);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          // ⬇️ GOOGLE PAY BUTTON
          if (_googlePayConfig != null && selectedAmount != null)
            GooglePayButton(
              paymentConfiguration: _googlePayConfig!,
              paymentItems: [
                PaymentItem(
                  label: widget.donationData['title'],
                  amount: selectedAmount.toString(),
                  status: PaymentItemStatus.final_price,
                ),
              ],
              type: GooglePayButtonType.donate,
              margin: const EdgeInsets.only(top: 15),
              onPaymentResult: (result) {
                debugPrint('Payment success: $result');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.donationSuccessMessage),
                  ),
                );
              },
              onError: (error) {
                debugPrint('Payment error: $error');
              },
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (selectedAmount == null)
            ElevatedButton(
              onPressed: null,
              child: Text(AppLocalizations.of(context)!.donationSelectAmount, style: Theme.of(context).textTheme.bodyMedium,),
            )
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
