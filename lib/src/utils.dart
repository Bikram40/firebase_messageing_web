// ignore_for_file: require_trailing_commas
// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';

import 'interop/messaging.dart';

/// Converts an [String] into it's [AuthorizationStatus] representation.
///
/// See https://developer.mozilla.org/en-US/docs/Web/API/Notification/requestPermission
/// for more information.
AuthorizationStatus convertToAuthorizationStatus(String? status) {
  switch (status) {
    case 'granted':
      return AuthorizationStatus.authorized;
    case 'denied':
      return AuthorizationStatus.denied;
    case 'default':
      return AuthorizationStatus.notDetermined;
    default:
      return AuthorizationStatus.notDetermined;
  }
}

/// Returns a [NotificationSettings] instance for all Web platforms devices.
NotificationSettings getNotificationSettings(String? status) {
  return NotificationSettings(
    authorizationStatus: convertToAuthorizationStatus(status),
    alert: AppleNotificationSetting.notSupported,
    announcement: AppleNotificationSetting.notSupported,
    badge: AppleNotificationSetting.notSupported,
    carPlay: AppleNotificationSetting.notSupported,
    lockScreen: AppleNotificationSetting.notSupported,
    notificationCenter: AppleNotificationSetting.notSupported,
    showPreviews: AppleShowPreviewSetting.notSupported,
    sound: AppleNotificationSetting.notSupported,
    timeSensitive: AppleNotificationSetting.notSupported,
    criticalAlert: AppleNotificationSetting.notSupported,
  );
}


