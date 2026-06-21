import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../../../translations.dart';
import '../../providers/earnings_provider.dart';
import '../widgets/withdraw_balance_card.dart';
import '../widgets/withdraw_quick_amounts.dart';
import '../widgets/withdraw_form_field.dart';
import '../widgets/withdraw_bank_dropdown.dart';
import '../widgets/withdraw_notice.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  final double availableBalance;

  const WithdrawScreen({super.key, required this.availableBalance});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  late FormGroup _form;
  bool _isSubmitting = false;
  String _selectedBank = '';
  double _withdrawAmount = 0;

  final List<Map<String, dynamic>> _banks = [
    {
      'name': 'Bank of America',
      'icon': Icons.account_balance,
      'color': 0xFF1E3A8A,
    },
    {'name': 'Chase Bank', 'icon': Icons.account_balance, 'color': 0xFF0B5E2E},
    {'name': 'Wells Fargo', 'icon': Icons.account_balance, 'color': 0xFFB22234},
    {'name': 'Citibank', 'icon': Icons.account_balance, 'color': 0xFF003B6F},
    {'name': 'PayPal', 'icon': Icons.payment, 'color': 0xFF0070BA},
    {'name': 'Other Bank', 'icon': Icons.other_houses, 'color': 0xFF6B7280},
  ];

  final List<double> _quickAmounts = [50, 100, 200, 500, 1000];

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'amount': FormControl<double>(
        validators: [
          Validators.required,
          Validators.min(10),
          Validators.max(widget.availableBalance),
        ],
      ),
      'bankName': FormControl<String>(validators: [Validators.required]),
      'accountNumber': FormControl<String>(validators: [Validators.required]),
      'accountHolder': FormControl<String>(validators: [Validators.required]),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }

    final amount = _form.control('amount').value as double;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirm withdrawal'.i18n),
        content: Text(
          'withdraw confirmation'.i18n.replaceAll(
            '{amount}',
            '\$${amount.toStringAsFixed(0)}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.i18n),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            child: Text('confirm'.i18n),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(earningsProvider.notifier);
      await notifier.requestWithdrawal(
        amount: amount,
        bankName: _form.control('bankName').value as String,
        accountNumber: _form.control('accountNumber').value as String,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Withdrawal request submitted successfully'.i18n),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'.i18n),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
          'request_withdrawal'.i18n,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Balance Card
            WithdrawBalanceCard(availableBalance: widget.availableBalance),

            // Quick Amount Buttons
            WithdrawQuickAmounts(
              amounts: _quickAmounts,
              selectedAmount: _withdrawAmount,
              onAmountSelected: (amount) {
                setState(() {
                  _withdrawAmount = amount;
                  _form.control('amount').value = amount;
                });
              },
            ),

            const SizedBox(height: 24),

            // Form
            ReactiveForm(
              formGroup: _form,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount Field
                    WithdrawFormField(
                      icon: Icons.attach_money,
                      title: 'amount'.i18n,
                      child: ReactiveTextField<double>(
                        formControlName: 'amount',
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixText: '\$ ',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        valueAccessor: _DoubleValueAccessor(),
                        onChanged: (controler) {
                          setState(() {
                            _withdrawAmount = controler.value ?? 0;
                          });
                        },
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'amount_required'.i18n,
                          ValidationMessage.min: (_) => 'amount_min'.i18n,
                          ValidationMessage.max: (_) => 'amount_max'.i18n,
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bank Selection
                    WithdrawFormField(
                      icon: Icons.account_balance,
                      title: 'select_bank'.i18n,
                      child: WithdrawBankDropdown(
                        banks: _banks,
                        selectedBank: _selectedBank,
                        onBankSelected: (bank) {
                          setState(() {
                            _selectedBank = bank;
                            _form.control('bankName').value = bank;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Account Number
                    WithdrawFormField(
                      icon: Icons.numbers,
                      title: 'account_number'.i18n,
                      child: ReactiveTextField<String>(
                        formControlName: 'accountNumber',
                        decoration: InputDecoration(
                          hintText: '1234 5678 9012 3456',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'account_number_required'.i18n,
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Account Holder Name
                    WithdrawFormField(
                      icon: Icons.person,
                      title: 'account_holder'.i18n,
                      child: ReactiveTextField<String>(
                        formControlName: 'accountHolder',
                        decoration: InputDecoration(
                          hintText: 'John Doe',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'account_holder_required'.i18n,
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Notice
            const WithdrawNotice(),

            const SizedBox(height: 24),

            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSecondary,
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'confirm withdrawal'.i18n,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DoubleValueAccessor extends ControlValueAccessor<double, String> {
  @override
  String modelToViewValue(double? modelValue) => modelValue?.toString() ?? '';

  @override
  double? viewToModelValue(String? viewValue) {
    if (viewValue == null || viewValue.isEmpty) return null;
    return double.tryParse(viewValue);
  }
}
