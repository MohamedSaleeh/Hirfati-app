// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FaqModel _$FaqModelFromJson(Map<String, dynamic> json) => _FaqModel(
  id: json['id'] as String,
  question: json['question'] as String,
  answer: json['answer'] as String,
  order: (json['order'] as num?)?.toInt(),
);

Map<String, dynamic> _$FaqModelToJson(_FaqModel instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'answer': instance.answer,
  'order': instance.order,
};
