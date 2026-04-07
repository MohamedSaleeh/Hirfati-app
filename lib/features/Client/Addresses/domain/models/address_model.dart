import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

enum AddressType { home, office, other }

@freezed
abstract class AddressModel with _$AddressModel {
  const factory AddressModel({
    String? id, 
    required String label,
    @JsonKey(name: 'type') required AddressType addressType,
    @JsonKey(name: 'full_address') required String fullAddress,
    String? street,
    String? city,
    String? latitude,
    String? longitude,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'user_id') String? userId,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}