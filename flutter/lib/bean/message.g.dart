// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageList _$MessageListFromJson(Map<String, dynamic> json) => MessageList(
      data: (json['data'] as List<dynamic>)
          .map((e) => MessageItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageListToJson(MessageList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

MessageItem _$MessageItemFromJson(Map<String, dynamic> json) => MessageItem(
      title: json['title'] as String,
      datetime:
          const DateTimeConverter().fromJson((json['datetime'] as num).toInt()),
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      hasRead: json['has_read'] as bool,
      imageUrl: json['image_url'] as String?,
      richText: (json['rich_text'] as List<dynamic>?)
          ?.map((e) => TPRichText.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageItemToJson(MessageItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'datetime': const DateTimeConverter().toJson(instance.datetime),
      'type': _$MessageTypeEnumMap[instance.type]!,
      'has_read': instance.hasRead,
      'image_url': instance.imageUrl,
      'rich_text': instance.richText?.map((e) => e.toJson()).toList(),
    };

const _$MessageTypeEnumMap = {
  MessageType.personal: 'PERSONAL',
  MessageType.tcg: 'TCG',
  MessageType.system: 'SYSTEM',
};
