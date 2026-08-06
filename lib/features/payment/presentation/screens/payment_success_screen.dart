import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/services.dart';
import '../../../../translations.dart';
import '../../../../core/utils/date_utils.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String transactionId;
  final double amount;
  final String referenceNumber;
  final String orderId;
  final String workerName;
  final String serviceTitle;
  final DateTime paidAt;

  const PaymentSuccessScreen({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.referenceNumber,
    required this.orderId,
    required this.workerName,
    required this.serviceTitle,
    required this.paidAt,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Payment Successful!'.i18n,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Your payment has been processed successfully'.i18n,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.receipt,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Payment Receipt'.i18n,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.qr_code,
                                label: 'Transaction ID'.i18n,
                                value: widget.transactionId,
                                isCopyable: true,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Icons.receipt,
                                label: 'Reference Number'.i18n,
                                value: widget.referenceNumber,
                                isCopyable: true,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Icons.attach_money,
                                label: 'Amount'.i18n,
                                value: '${widget.amount} SYP',
                                isHighlighted: true,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Icons.person,
                                label: 'Worker'.i18n,
                                value: widget.workerName,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Icons.build,
                                label: 'Service'.i18n,
                                value: widget.serviceTitle,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Icons.calendar_today,
                                label: 'Payment Date'.i18n,
                                value: DateUtils.formatDateTime(widget.paidAt),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          child: Banner(
                            message: 'Soon '.i18n,
                            location: BannerLocation.topEnd,
                            color: theme.colorScheme.secondary,
                            child: OutlinedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.download),
                              label: Text('Download PDF'.i18n),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          child: Banner(
                            message: 'Soon '.i18n,
                            location: BannerLocation.topEnd,
                            color: theme.colorScheme.secondary,
                            child: OutlinedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.share),
                              label: Text('Share'.i18n),
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                                foregroundColor:
                                    theme.colorScheme.onSurfaceVariant,
                                enableFeedback: false,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Done'.i18n,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isCopyable = false,
    bool isHighlighted = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: isHighlighted ? 20 : 14,
                  fontWeight: isHighlighted
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isHighlighted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (isCopyable)
          IconButton(
            onPressed: () => _copyToClipboard(value),
            icon: Icon(Icons.copy, size: 18, color: theme.colorScheme.outline),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  Future<void> _copyToClipboard(String text) async {
    final theme = Theme.of(context);
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied to clipboard'.i18n),
          duration: const Duration(seconds: 2),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
    }
  }
}
