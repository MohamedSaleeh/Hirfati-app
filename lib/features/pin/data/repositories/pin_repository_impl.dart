import '../../domain/repositories/pin_repository.dart';
import '../datasources/pin_supabase_datasource.dart';

class PinRepositoryImpl implements PinRepository {
  final PinSupabaseDatasource _datasource;

  PinRepositoryImpl(this._datasource);

  @override
  Future<bool> hasPin(String userId) async {
    return await _datasource.hasPin(userId);
  }

  @override
  Future<void> setPin(String userId, String pin) async {
    await _datasource.setPin(userId, pin);
  }

  @override
  Future<bool> verifyPin(String userId, String pin) async {
    return await _datasource.verifyPin(userId, pin);
  }

  @override
  Future<void> changePin(String userId, String oldPin, String newPin) async {
    // التحقق من صحة PIN القديم
    final isValid = await _datasource.verifyPin(userId, oldPin);
    if (!isValid) {
      throw Exception('Invalid current PIN');
    }
    await _datasource.changePin(userId, newPin);
  }

  @override
  Future<void> resetPin(String userId) async {
    await _datasource.resetPin(userId);
  }

  @override
  Future<int> getRemainingAttempts(String userId) async {
    return await _datasource.getRemainingAttempts(userId);
  }

  @override
  Future<void> incrementAttempts(String userId) async {
    await _datasource.incrementAttempts(userId);
  }

  @override
  Future<void> resetAttempts(String userId) async {
    await _datasource.resetAttempts(userId);
  }
}