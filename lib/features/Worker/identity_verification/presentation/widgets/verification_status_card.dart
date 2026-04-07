import 'package:flutter/material.dart';
import '../../../../../translations.dart';
import '../../domain/models/verification_request_model.dart';

class VerificationStatusCard extends StatelessWidget {
  final VerificationRequestModel request;

  const VerificationStatusCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String title;
    String message;
    IconData icon;

    switch (request.status) {
      case VerificationStatus.pending:
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        title = 'verification_pending'.i18n;
        message = 'verification_pending_message'.i18n;
        icon = Icons.hourglass_empty;
        break;
      case VerificationStatus.approved:
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        title = 'verification_approved'.i18n;
        message = 'verification_approved_message'.i18n;
        icon = Icons.verified;
        break;
      case VerificationStatus.rejected:
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        title = 'verification_rejected'.i18n;
        message = request.rejectionReason ?? 'verification_rejected_message'.i18n;
        icon = Icons.error_outline;
        break;
    }

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}