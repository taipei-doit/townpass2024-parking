// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tp_rich_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TPRichText _$TPRichTextFromJson(Map<String, dynamic> json) => TPRichText(
      text: json['text'] as String?,
      url: json['url'] as String?,
      style: (json['style'] as List<dynamic>?)
          ?.map((e) => $enumDecodeNullable(_$TPRichTextStyleEnumMap, e,
              unknownValue: JsonKey.nullForUndefinedEnumValue))
          .toList(),
    );

Map<String, dynamic> _$TPRichTextToJson(TPRichText instance) =>
    <String, dynamic>{
      'text': instance.text,
      'url': instance.url,
      'style': instance.style?.map((e) => _$TPRichTextStyleEnumMap[e]).toList(),
    };

const _$TPRichTextStyleEnumMap = {
  TPRichTextStyle.italic: 'ITALIC',
  TPRichTextStyle.bold: 'BOLD',
  TPRichTextStyle.underline: 'UNDERLINE',
};
