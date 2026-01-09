import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // White card
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                "Available Balance",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "\$12,450.00",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CardButton(
                    icon: Icons.add,
                    label: "Add Money",
                    onTap: () {},
                  ),
                  _CardButton(
                    icon: Icons.send,
                    label: "Pay",
                    onTap: () {},
                  ),
                  _CardButton(
                    icon: Icons.receipt_long,
                    label: "Statement",
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        // Logo top-right
        Positioned(
          top: 16,
          right: 16,
          child: Image.asset(
            'assets/images/bharatconnect.png', // blue + orange logo
            height: 40,
            width: 40,
          ),
        ),
      ],
    );
  }
}

class _CardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CardButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: Colors.black87,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
