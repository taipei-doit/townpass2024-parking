import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:town_pass/util/tp_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:town_pass/service/device_service.dart';
import 'package:town_pass/service/account_service.dart';
import 'package:town_pass/service/geo_locator_service.dart';
import 'package:town_pass/service/notification_service.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:town_pass/util/web_message_handler/tp_web_message_reply.dart';

abstract class TPWebMessageHandler {
  String get name;

  Future<void> handle({
    required String? message,
    required WebUri? sourceOrigin,
    required bool isMainFrame,
    required Function(WebMessage replyWebMessage)? onReply,
  });

  WebMessage replyWebMessage({required Object? data}) {
    return TPWebStringMessageReply(
      name: name,
      data: data,
    ).message;
  }
}

class UserinfoWebMessageHandler extends TPWebMessageHandler {
  @override
  String get name => 'userinfo';

  @override
  Future<void> handle({
    required String? message,
    required WebUri? sourceOrigin,
    required bool isMainFrame,
    required onReply,
  }) async {
    onReply?.call(replyWebMessage(
      data: Get.find<AccountService>().account ?? [],
    ));
  }
}

class LaunchMapWebMessageHandler extends TPWebMessageHandler {
  @override
  String get name => 'launch_map';

  @override
  handle({
    required String? message,
    required WebUri? sourceOrigin,
    required bool isMainFrame,
    required Function(WebMessage reply)? onReply,
  }) async {
    if (message == null) {
      onReply?.call(
        replyWebMessage(data: false),
      );
    }
    final Uri uri = Uri.parse(message!);
    final bool canLaunch = await canLaunchUrl(uri);

    onReply?.call(
      replyWebMessage(data: canLaunch),
    );

    if (canLaunch) {
      await launchUrl(uri);
    }
  }
}

class PhoneCallMessageHandler extends TPWebMessageHandler {
  @override
  String get name => 'phone_call';

  @override
  handle({
    required String? message,
    required WebUri? sourceOrigin,
    required bool isMainFrame,
    required Function(WebMessage reply)? onReply,
  }) async {
    if (message == null) {
      onReply?.call(
        replyWebMessage(data: false),
      );
    }
    final Uri uri = Uri.parse('tel://${message!}');
    final bool canLaunch = await canLaunchUrl(uri);

    onReply?.call(
      replyWebMessage(data: canLaunch),
    );

    if (canLaunch) {
      await launchUrl(uri);
    }
  }
}

class LocationMessageHandler extends TPWebMessageHandler {
  @override
  String get name => 'location';

  @override
  handle({
    required String? message,
    required WebUri? sourceOrigin,
    required bool isMainFrame,
    required Function(WebMessage reply)? onReply,
  }) async {
    Position? position;

    // might have permission issue
    try {
      position = await Get.find<GeoLocatorService>().position();
    } catch (error) {
      printError(info: error.toString());
    }

    onReply?.call(replyWebMessage(
      data: position?.toJson() ?? [],
    ));
  }
}

class DeviceInfoMessageHandler extends TPWebMessageHandler {
  @override
  String get name => 'deviceinfo';

  @override
  handle({
    required String? message,
    required WebUri? sourceOrigin,
    required bool isMainFrame,
    required Function(WebMessage reply)? onReply,
  }) async {
    onReply?.call(replyWebMessage(
      data: Get.find<DeviceService>().baseDeviceInfo?.data ?? [],
    ));
  }
}

class OpenLinkMessageHandler extends TPWebMessageHandler {
  @override
  String get name => 'open_link';

  @override
  handle({
    required String? message,
    required WebUri? sourceOrigin,
    required bool isMainFrame,
    required Function(WebMessage reply)? onReply,
  }) async {
    if (message == null) {
      onReply?.call(replyWebMessage(data: false));
      return;
    }
    await Get.toNamed(
      TPRoute.webView,
      arguments: message,
    );
  }
}

class TestMessageHandler extends TPWebMessageHandler {
  @override
  String get name => 'test';

  @override
  handle({
    required String? message,
    required WebUri? sourceOrigin,
    required bool isMainFrame,
    required Function(WebMessage reply)? onReply,
  }) async {
    log('TestMessageHandler');
    log(onReply == null ? 'null' : 'not null');
    onReply?.call(replyWebMessage(data: 123));
  }
}

class TimerSetHandler extends TPWebMessageHandler {
  final notificationService = Get.find<NotificationService>();

  @override
  String get name => 'timer_set';

  @override
  handle({
    required String? message,
    required WebUri? sourceOrigin,
    required bool isMainFrame,
    required Function(WebMessage reply)? onReply,
  }) async {
    if (message != null) {
      log('I received: $message');
      // try {
      final Map<String, dynamic> jsonData = json.decode(message);
      final String type = jsonData['type'] ?? 'undefined';
      final int duration = jsonData['duration'];
      int? remainTime = jsonData['remainTime'] as int?;
      final int remainMin = remainTime != null ? remainTime ~/ 60 : 0;
      final int remainSec = remainTime != null ? remainTime % 60 : 0;
      final String? place = jsonData['place'] as String?;

// '{"status":"no_time","type":"yellowLine","place":"no_data", "duration":"10"}'
      await notificationService.showScheduledNotification(
        title: "台北通微服務「ParkFlow找車位」提醒您：",
        body: type == 'yellowLine'
            ? "${remainTime != 1800 ? "您的愛車即將在一分鐘達規定臨停時間" : "您的愛車即將在30分鐘後禁止停車"}，請您盡快移車，以免被開單檢舉謝謝您！"
            : "提醒您${place?.isNotEmpty == true ? '停在「$place」的' : ''}愛車即將在${remainMin}分${remainSec}秒後達到您所預估的離開時間，抓緊時間以免被加收費用！",
        duration: duration,
      );

      // onReply?.call(replyWebMessage(data: '傳輸成功'));
    }
  }
}
