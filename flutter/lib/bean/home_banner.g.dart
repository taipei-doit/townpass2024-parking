// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeBannerList _$HomeBannerListFromJson(Map<String, dynamic> json) =>
    HomeBannerList(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeBannerItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeBannerListToJson(HomeBannerList instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

HomeBannerItem _$HomeBannerItemFromJson(Map<String, dynamic> json) =>
    HomeBannerItem(
      imageUrl: json['image_url'] as String,
      webUrl: json['web_url'] as String,
    );

Map<String, dynamic> _$HomeBannerItemToJson(HomeBannerItem instance) =>
    <String, dynamic>{
      'image_url': instance.imageUrl,
      'web_url': instance.webUrl,
    };
