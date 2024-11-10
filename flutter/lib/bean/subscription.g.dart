// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionList _$SubscriptionListFromJson(Map<String, dynamic> json) =>
    SubscriptionList(
      list: (json[''] as List<dynamic>)
          .map((e) => SubscriptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubscriptionListToJson(SubscriptionList instance) =>
    <String, dynamic>{
      '': instance.list.map((e) => e.toJson()).toList(),
    };

SubscriptionItem _$SubscriptionItemFromJson(Map<String, dynamic> json) =>
    SubscriptionItem(
      title: json['title'] as String,
      content: json['content'] as String,
      webUrl: json['web_url'] as String?,
      datetime:
          const DateTimeConverter().fromJson((json['datetime'] as num).toInt()),
    );

Map<String, dynamic> _$SubscriptionItemToJson(SubscriptionItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'web_url': instance.webUrl,
      'datetime': const DateTimeConverter().toJson(instance.datetime),
    };
