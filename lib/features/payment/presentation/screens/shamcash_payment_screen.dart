import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../translations.dart';
import '../../data/services/shamcash_service.dart';

class ShamCashPaymentScreen extends ConsumerStatefulWidget {
  final String orderId;
  final double amount;
  final VoidCallback onSuccess;
  final String workerName;
  final String serviceTitle;

  const ShamCashPaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
    required this.onSuccess,
    required this.workerName,
    required this.serviceTitle,
  });

  @override
  ConsumerState<ShamCashPaymentScreen> createState() =>
      _ShamCashPaymentScreenState();
}

class _ShamCashPaymentScreenState extends ConsumerState<ShamCashPaymentScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  bool _isLoading = false;
  String? _referenceNumber;
  String? _error;
  double? _shamCashBalance;
  String _enteredPin = '';

  late PinTheme defaultPinTheme;
  late PinTheme focusedPinTheme;
  late PinTheme errorPinTheme;

  @override
  void initState() {
    super.initState();
    _loadBalanceAndCreateSession();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    
    defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    focusedPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    errorPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.red,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadBalanceAndCreateSession() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = ShamCashService(Supabase.instance.client);

      final balance = await service.getShamCashBalance();
      _shamCashBalance = balance;

      if (balance < widget.amount) {
        setState(() {
          _isLoading = false;
          _error =
              'Insufficient Sham Cash balance. Your balance is $balance \$, but you need ${widget.amount} \$.'
                  .i18n;
        });

        if (mounted) _showInsufficientBalanceDialog();
        return;
      }

      final session = await service.createSession(
        orderId: widget.orderId,
        amount: widget.amount,
      );

      setState(() {
        _referenceNumber = session.referenceNumber;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showInsufficientBalanceDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Insufficient Balance'.i18n),
        content: Text(
          'Your Sham Cash balance is $_shamCashBalance \$, but you need ${widget.amount} \$.'
              .i18n,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('OK'.i18n),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmPayment() async {
    if (_enteredPin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 4-digit PIN'.i18n)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = ShamCashService(Supabase.instance.client);

      final result = await service.confirmPayment(
        orderId: widget.orderId,
        pin: _enteredPin,
        idempotencyKey: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      if (!result.success) {
        setState(() {
          _error = result.error ?? 'Payment failed'.i18n;
          _isLoading = false;
        });
        return;
      }

      final data = result.data!;
      final transactionId = data['transaction_id'] ?? '';
      final referenceNumber =
          data['reference_number'] ?? _referenceNumber ?? '';
      final paidAt = DateTime.tryParse(data['paid_at'] ?? '') ?? DateTime.now();

      if (!mounted) return;

      context.pushReplacement(
        '/payment-success',
        extra: {
          'transactionId': transactionId,
          'amount': widget.amount,
          'referenceNumber': referenceNumber,
          'orderId': widget.orderId,
          'workerName': widget.workerName,
          'serviceTitle': widget.serviceTitle,
          'paidAt': paidAt,
        },
      );

      widget.onSuccess();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Sham Cash Payment'.i18n),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAmountCard(),
            const SizedBox(height: 24),
            if (_isLoading)
              Center(
                child: Lottie.asset(
                  'assets/animations/loading_animation.json',
                  width: 150,
                  height: 150,
                  repeat: true,
                ),
              )
            else if (_error != null)
              _buildErrorWidget()
            else
              _buildPinForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Amount to Pay'.i18n,
            style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.amount} \$',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          if (_shamCashBalance != null) ...[
            const SizedBox(height: 8),
            Text(
              '${'Your Sham Cash balance:'.i18n} $_shamCashBalance \$',
              style: TextStyle(
                fontSize: 12,
                color: _shamCashBalance! >= widget.amount
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '${'Reference:'.i18n} ${_referenceNumber ?? '...'}',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildPinForm() {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          'Enter your Sham Cash PIN'.i18n,
          style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Pinput(
          length: 4,
          controller: _pinController,
          focusNode: _pinFocusNode,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          errorPinTheme: errorPinTheme,
          obscureText: true,
          obscuringCharacter: '●',
          onCompleted: (pin) => setState(() => _enteredPin = pin),
          onChanged: (value) => setState(() => _enteredPin = value),
          showCursor: true,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _enteredPin.length == 4 ? _confirmPayment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              disabledBackgroundColor: theme.colorScheme.onSurfaceVariant,
            ),
            child: Text('Pay Now'.i18n, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _error!,
            style: TextStyle(color: theme.colorScheme.onErrorContainer),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _loadBalanceAndCreateSession,
          child: Text('Try Again'.i18n),
        ),
      ],
    );
  }
}