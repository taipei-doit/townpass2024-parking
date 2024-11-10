// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityList _$ActivityListFromJson(Map<String, dynamic> json) => ActivityList(
      data: (json['data'] as List<dynamic>)
          .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivityListToJson(ActivityList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

ActivityItem _$ActivityItemFromJson(Map<String, dynamic> json) => ActivityItem(
      webUrl: json['web_url'] as String?,
      startDateTime: const DateTimeConverter()
          .fromJson((json['start_datetime'] as num).toInt()),
      endDateTime: _$JsonConverterFromJson<int, DateTime>(
          json['end_datetime'], const DateTimeConverter().fromJson),
      content: json['content'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String,
    );

Map<String, dynamic> _$ActivityItemToJson(ActivityItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'image_url': instance.imageUrl,
      'web_url': instance.webUrl,
      'start_datetime':
          const DateTimeConverter().toJson(instance.startDateTime),
      'end_datetime': _$JsonConverterToJson<int, DateTime>(
          instance.endDateTime, const DateTimeConverter().toJson),
      'content': instance.content,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
