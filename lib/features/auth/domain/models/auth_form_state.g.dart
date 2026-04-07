// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_form_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthFormState _$AuthFormStateFromJson(
  Map<String, dynamic> json,
) => _AuthFormState(
  mode: $enumDecodeNullable(_$AuthModeEnumMap, json['mode']) ?? AuthMode.login,
  userType:
      $enumDecodeNullable(_$UserTypeEnumMap, json['userType']) ??
      UserType.client,
  email: json['email'] as String? ?? '',
  password: json['password'] as String? ?? '',
  fullName: json['fullName'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  obscurePassword: json['obscurePassword'] as bool? ?? true,
  isLoading: json['isLoading'] as bool? ?? false,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$AuthFormStateToJson(_AuthFormState instance) =>
    <String, dynamic>{
      'mode': _$AuthModeEnumMap[instance.mode]!,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'email': instance.email,
      'password': instance.password,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'obscurePassword': instance.obscurePassword,
      'isLoading': instance.isLoading,
      'errorMessage': instance.errorMessage,
    };

const _$AuthModeEnumMap = {AuthMode.login: 'login', AuthMode.signUp: 'signUp'};

const _$UserTypeEnumMap = {
  UserType.client: 'client',
  UserType.worker: 'worker',
};
