import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  static const Color _primary = Color(0xFF0033A0);
  static const Color _secondary = Color(0xFF1E5EFF);
  static const Color _lightBlue = Color(0xFF4B7BEC);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        /// ✅ Premium Gradient Background
        gradient: const LinearGradient(
          colors: [_primary, _secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        /// Soft Glow Shadow
        boxShadow: [
          BoxShadow(
            color: _secondary.withOpacity(0.35),
            blurRadius: 25,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// Decorative Light Circle (premium feel)
          // Positioned(
          //   top: -40,
          //   right: -40,
          //   child: Container(
          //     height: 140,
          //     width: 140,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.white.withOpacity(0.08),
          //     ),
          //   ),
          // ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Top Row
              Row(
                children: [
                  const Text(
                    "Available Balance",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),

                  /// Small Verified Badge
             
                ],
              ),

              const SizedBox(height: 18),

              /// 🔹 Balance Amount
              const Text(
                "₹12,450.00",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Updated just now",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 24),

              /// Soft Divider
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.15),
              ),

              const SizedBox(height: 18),

              /// 🔹 Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _CardButton(
                    icon: Icons.add_rounded,
                    label: "Add",
                  ),
                  _CardButton(
                    icon: Icons.send_rounded,
                    label: "Pay",
                  ),
                  _CardButton(
                    icon: Icons.receipt_long_rounded,
                    label: "Statement",
                  ),
                ],
              ),
            ],
          ),

          /// 🔹 Logo (top right)
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: 0.95,
              child: Image.asset(
                'assets/images/bharatconnect.png',
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CardButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}