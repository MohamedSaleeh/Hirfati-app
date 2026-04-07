import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_form_state.freezed.dart';
part 'auth_form_state.g.dart';

enum AuthMode { login, signUp }

enum UserType { client, worker }
@freezed
abstract class AuthFormState with _$AuthFormState {
  const factory AuthFormState({
    @Default(AuthMode.login) AuthMode mode,
    @Default(UserType.client) UserType userType,
    @Default('') String email,
    @Default('') String password,
    @Default('') String fullName,
    @Default('') String phone,
    @Default(true) bool obscurePassword,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AuthFormState;
   factory AuthFormState.fromJson(Map<String, dynamic> json) =>
      _$AuthFormStateFromJson(json);
}