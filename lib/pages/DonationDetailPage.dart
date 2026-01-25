import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';

class DonationDetailPage extends StatefulWidget {
  final String cause;
  final Color color;

  const DonationDetailPage({
    super.key,
    required this.cause,
    required this.color,
  });

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  int selectedAmount = 20;

  final List<int> amounts = [5, 10, 20, 50, 100];

  final List<PaymentItem> paymentItems = [];

  @override
  Widget build(BuildContext context) {
    paymentItems.clear();
    paymentItems.add(
      PaymentItem(
        label: "Donation",
        amount: selectedAmount.toString(),
        status: PaymentItemStatus.final_price,
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cause,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your donation helps make a real impact.",
              style: GoogleFonts.poppins(color: Colors.black54),
            ),
            const SizedBox(height: 30),

            /// Amount selector
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: amounts.map((amount) {
                final isSelected = amount == selectedAmount;
                return GestureDetector(
                  onTap: () => setState(() => selectedAmount = amount),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? widget.color
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "\$$amount",
                      style: GoogleFonts.poppins(
                        color: Colors.yellow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            /// Google Pay Button
            GooglePayButton(
              paymentConfigurationAsset: 'gpay.json',
              paymentItems: paymentItems,
              type: GooglePayButtonType.donate,
              width: double.infinity,
              height: 56,
              onPaymentResult: (result) {
                debugPrint(result.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Donation Successful ❤️")),
                );
              },
              loadingIndicator: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
