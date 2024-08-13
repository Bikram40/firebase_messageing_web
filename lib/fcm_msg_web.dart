// ignore_for_file: require_trailing_commas
// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';
import 'dart:js_util';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:firebase_core_web/firebase_core_web_interop.dart'
    as core_interop;
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'firebase_msg_js_helper.dart' as js;

import 'import_js/import_js_library.dart';
import 'src/internals.dart';
import 'src/interop/messaging.dart' as messaging_interop;
import 'src/utils.dart' as utils;

/// Web implementation for [FirebaseMessagingPlatform]
/// delegates calls to messaging web plugin.
class FcmMsgWeb extends FirebaseMessagingPlatform {
  String? vapidKey;

  /// Called by PluginRegistry to register this plugin for Flutter Web
  static Future<void> registerWith(Registrar registrar) async {
    await importJsLibrary(
      url: "firebase-config.js",
    );
    await importJsLibrary(
        url: "./assets/firebase_msg.js",
        flutterPluginName: "firebase_messaging_web");
  }

  Future<void> initFBMsg({required FirebaseOptions config}) async {
    await promiseToFuture(js.initFBMsg(jsify(config.asMap)));
  }

  void onMessage({Function(RemoteMessage)? onMessage}) {
    window.navigator.serviceWorker?.addEventListener('message', (event) {
      if (event is MessageEvent) {
        Map data = jsonDecode(context['JSON']
            .callMethod('stringify', [JsObject.jsify(event.data)['data']]));
        RemoteMessage remoteMessage = RemoteMessage(
          notification: RemoteNotification(
            title: JsObject.jsify(event.data)['notification']['title'],
            body: JsObject.jsify(event.data)['notification']['body'],
          ),
          data: Map<String, dynamic>.from(data),
        );
        if (onMessage != null) {
          onMessage.call(remoteMessage);
        }
        FirebaseMessagingPlatform.onMessage.add(remoteMessage);
      }
    });
  }

  Stream<String>? _noopOnTokenRefreshStream;

  @override
  FirebaseMessagingPlatform setInitialValues({bool? isAutoInitEnabled}) {
    // Not required on web, but prevents UnimplementedError being thrown.
    return this;
  }

  @override
  bool get isAutoInitEnabled {
    // Not supported on web, since it automatically initializes when imported
    // via the script. So return `true`.
    return true;
  }

  @override
  Future<RemoteMessage?> getInitialMessage() async {
    return null;
  }

  @override
  Future<void> deleteToken() async {
    await promiseToFuture(js.deleteToken());

    // return convertWebExceptions(_delegate.deleteToken);
  }

  @override
  Future<String?> getAPNSToken() async {
    return null;
  }

  @override
  Future<String?> getToken({String? vapidKey}) async {
    this.vapidKey = vapidKey;
    // String t =  await promiseToFuture(js.getToken(vapidKey));
    // return t;
    return convertWebExceptions(
      () => promiseToFuture(js.getToken(vapidKey)),
    );
  }

  @override
  Stream<String> get onTokenRefresh {
    // onTokenRefresh is deprecated on web, however since this is a non-critical
    // api we just return a noop stream to keep functionality the same across
    // platforms.
    return _noopOnTokenRefreshStream ??=
        StreamController<String>.broadcast().stream;
  }

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    return utils.getNotificationSettings(Notification.permission);
  }

  @override
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
  }) {
    return convertWebExceptions(() async {
      String status = await Notification.requestPermission();
      return utils.getNotificationSettings(status);
    });
  }

  @override
  Future<void> setAutoInitEnabled(bool enabled) async {
    // Noop out on web - not supported but no need to crash
    return;
  }

  @override
  Future<void> setForegroundNotificationPresentationOptions({
    required bool alert,
    required bool badge,
    required bool sound,
  }) async {
    // TODO(rrousselGit) dead code? Should this throw an UnimplementedError?
    return;
  }

  @override
  Future<void> subscribeToTopic(String topic) {
    throw UnimplementedError('''
      subscribeToTopic() is not supported on the web clients.

      To learn how to manage subscriptions for web users, visit the
      official Firebase documentation:

      https://firebase.google.com/docs/cloud-messaging/js/topic-messaging
    ''');
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) {
    throw UnimplementedError('''
      unsubscribeFromTopic() is not supported on the web clients.

      To learn how to manage subscriptions for web users, visit the
      official Firebase documentation:

      https://firebase.google.com/docs/cloud-messaging/js/topic-messaging
    ''');
  }
}
