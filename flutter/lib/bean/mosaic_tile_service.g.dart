// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mosaic_tile_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MosaicTileService _$MosaicTileServiceFromJson(Map<String, dynamic> json) =>
    MosaicTileService(
      contentList: (json['data'] as List<dynamic>)
          .map((e) => MosaicTileServiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MosaicTileServiceToJson(MosaicTileService instance) =>
    <String, dynamic>{
      'data': instance.contentList.map((e) => e.toJson()).toList(),
    };

MosaicTileServiceItem _$MosaicTileServiceItemFromJson(
        Map<String, dynamic> json) =>
    MosaicTileServiceItem(
      mainText: json['main_text'] as String,
      subText: json['sub_text'] as String?,
      icon: json['icon'] as String,
      url: json['destination_url'] as String,
    );

Map<String, dynamic> _$MosaicTileServiceItemToJson(
        MosaicTileServiceItem instance) =>
    <String, dynamic>{
      'main_text': instance.mainText,
      'sub_text': instance.subText,
      'icon': instance.icon,
      'destination_url': instance.url,
    };
