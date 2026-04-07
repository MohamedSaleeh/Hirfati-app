import '../models/pin_model.dart';

abstract class PinRepository {
  Future<bool> hasPin(String userId);
  Future<void> setPin(String userId, String pin);
  Future<bool> verifyPin(String userId, String pin);
  Future<void> changePin(String userId, String oldPin, String newPin);
  Future<void> resetPin(String userId);
  Future<int> getRemainingAttempts(String userId);
  Future<void> incrementAttempts(String userId);
  Future<void> resetAttempts(String userId);
}