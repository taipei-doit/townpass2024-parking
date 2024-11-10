import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:town_pass/util/web_message_handler/tp_web_message_handler.dart';

abstract class TPWebMessageListener {
  static List<TPWebMessageHandler> get messageHandler => [
        UserinfoWebMessageHandler(),
        LaunchMapWebMessageHandler(),
        PhoneCallMessageHandler(),
        LocationMessageHandler(),
        DeviceInfoMessageHandler(),
        OpenLinkMessageHandler(),
        TestMessageHandler(),
        TimerSetHandler(),
      ];

  static WebMessageListener webMessageListener() {
    return WebMessageListener(
      jsObjectName: 'flutterObject',
      onPostMessage: (webMessage, sourceOrigin, isMainFrame, replyProxy) async {
        if (webMessage == null) {
          return;
        }

        final Map dataMap = jsonDecode(webMessage.data);
        for (TPWebMessageHandler handler in messageHandler) {
          if (handler.name == dataMap['name']) {
            await handler.handle(
              message: dataMap['data'],
              sourceOrigin: sourceOrigin,
              isMainFrame: isMainFrame,
              onReply: (reply) => replyProxy.postMessage(reply),
            );
          }
        }
      },
    );
  }
}
