import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../translations.dart';
import '../providers/pin_provider.dart';

class VerifyPinScreen extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;
  final Function(String) onVerified;
  final int maxAttempts;

  const VerifyPinScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onVerified,
    this.maxAttempts = 5,
  });

  @override
  ConsumerState<VerifyPinScreen> createState() => _VerifyPinScreenState();
}

class _VerifyPinScreenState extends ConsumerState<VerifyPinScreen> {
  late FormGroup _form;
  bool _isLoading = false;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'pin': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(4),
          Validators.maxLength(4),
          Validators.pattern(r'^[0-9]{4}$'),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: ReactiveForm(
        formGroup: _form,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.lock, size: 80, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ReactiveTextField(
                formControlName: 'pin',
                decoration: InputDecoration(
                  labelText: 'Enter PIN'.i18n,
                  hintText: '****',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: theme.colorScheme.primary,
                  ),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
              ),
              if (_attempts > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${'Attempts remaining'.i18n}: ${widget.maxAttempts - _attempts}',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyPin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          'Verify'.i18n,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPin() async {
    final theme = Theme.of(context);

    if (_form.invalid) {
      _showError('Please enter a valid 4-digit PIN'.i18n);
      return;
    }

    final pin = _form.control('pin').value as String;

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(pinProvider.notifier);
      final isValid = await notifier.verifyPin(pin);

      if (isValid) {
        widget.onVerified(pin);
        if (mounted) Navigator.pop(context);
      } else {
        setState(() {
          _attempts++;
          _isLoading = false;
        });
        _showError('Invalid PIN. Please try again.'.i18n);

        if (_attempts >= widget.maxAttempts) {
          _showError('Too many attempts. Try again later.'.i18n);
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context);
          });
        }
      }
    } catch (e) {
      _showError('${'Error verifying PIN'.i18n}: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }
}
