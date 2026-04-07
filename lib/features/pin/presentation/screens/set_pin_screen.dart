import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../../../translations.dart';
import '../providers/pin_provider.dart';

class SetPinScreen extends ConsumerStatefulWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onSuccess;

  const SetPinScreen({super.key, this.title, this.subtitle, this.onSuccess});

  @override
  ConsumerState<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends ConsumerState<SetPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final FocusNode _confirmPinFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isChanging = false;
  bool _showError = false;
  String _errorMessage = '';
  String _pin = '';
  String _confirmPin = '';

  late PinTheme defaultPinTheme;
  late PinTheme focusedPinTheme;
  late PinTheme errorPinTheme;

  @override
  void initState() {
    super.initState();
    _checkExistingPin();
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

  Future<void> _checkExistingPin() async {
    final hasPin = await ref.read(hasPinProvider.future);
    if (mounted && hasPin) {
      setState(() => _isChanging = true);
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _pinFocusNode.dispose();
    _confirmPinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ??
              (_isChanging ? 'Change PIN'.i18n : 'Set Sham Cash PIN'.i18n),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              _isChanging ? Icons.lock_reset : Icons.lock,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              widget.subtitle ??
                  (_isChanging
                      ? 'Enter your new 4-digit PIN'.i18n
                      : 'Create a 4-digit PIN for Sham Cash payments'.i18n),
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isChanging ? 'New PIN'.i18n : 'Enter PIN'.i18n,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Pinput(
                  length: 4,
                  controller: _pinController,
                  focusNode: _pinFocusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  errorPinTheme: errorPinTheme,
                  obscureText: true,
                  obscuringCharacter: '●',
                  onCompleted: (pin) {
                    setState(() => _pin = pin);
                    _confirmPinFocusNode.requestFocus();
                  },
                  onChanged: (value) {
                    setState(() => _pin = value);
                    if (_showError) {
                      setState(() => _showError = false);
                    }
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                ),
              ],
            ),
            const SizedBox(height: 24),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isChanging ? 'Confirm New PIN'.i18n : 'Confirm PIN'.i18n,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Pinput(
                  length: 4,
                  controller: _confirmPinController,
                  focusNode: _confirmPinFocusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  errorPinTheme: errorPinTheme,
                  obscureText: true,
                  obscuringCharacter: '●',
                  onCompleted: (pin) {
                    setState(() => _confirmPin = pin);
                  },
                  onChanged: (value) {
                    setState(() => _confirmPin = value);
                    if (_showError) {
                      setState(() => _showError = false);
                    }
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                ),
              ],
            ),

            if (_showError)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _savePin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                        (_isChanging ? 'Change PIN' : 'Save PIN').i18n,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePin() async {
    final theme = Theme.of(context);

    if (_pin.length != 4) {
      _showErrorDialog('PIN must be 4 digits'.i18n);
      return;
    }

    if (_confirmPin.length != 4) {
      _showErrorDialog('Please confirm your PIN'.i18n);
      return;
    }

    if (_pin != _confirmPin) {
      _showErrorDialog('PINs do not match'.i18n);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(pinProvider.notifier);

      if (_isChanging) {
        final oldPin = await _askForOldPin();
        if (oldPin == null) {
          setState(() => _isLoading = false);
          return;
        }

        await notifier.changePin(oldPin, _pin);
      } else {
        await notifier.setPin(_pin);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PIN saved successfully'.i18n),
            backgroundColor: theme.colorScheme.primary,
          ),
        );

        if (widget.onSuccess != null) {
          widget.onSuccess!();
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _showErrorDialog('Error saving PIN: $e'.i18n);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<String?> _askForOldPin() async {
    final completer = Completer<String?>();
    String oldPin = '';
    bool isProcessing = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Verify Current PIN'.i18n),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Please enter your current PIN to continue'.i18n),
                  const SizedBox(height: 16),
                  Pinput(
                    length: 4,
                    onCompleted: (pin) => oldPin = pin,
                    onChanged: (value) {
                      oldPin = value;
                      setDialogState(() {});
                    },
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    errorPinTheme: errorPinTheme,
                    obscureText: true,
                    obscuringCharacter: '●',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    completer.complete(null);
                  },
                  child: Text('Cancel'.i18n),
                ),
                ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          if (oldPin.length != 4) {
                            _showErrorDialog('Please enter a valid PIN');
                            return;
                          }

                          setDialogState(() => isProcessing = true);

                          final notifier = ref.read(pinProvider.notifier);
                          final isValid = await notifier.verifyPin(oldPin);

                          if (isValid) {
                            Navigator.pop(context);
                            completer.complete(oldPin);
                          } else {
                            setDialogState(() => isProcessing = false);
                            _showErrorDialog('Invalid current PIN');
                          }
                        },
                  child: isProcessing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Verify'.i18n),
                ),
              ],
            );
          },
        );
      },
    );

    return completer.future;
  }

  void _showErrorDialog(String message) {
    setState(() {
      _showError = true;
      _errorMessage = message;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showError = false);
      }
    });
  }
}
