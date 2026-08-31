import 'package:flutter/material.dart';

// "No products yet" / "No orders yet" போன்ற empty screens-ஐ அழகா காட்ட
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 60, color: Colors.green.shade300),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}