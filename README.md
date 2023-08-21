# firebase_messaging_web

This repository contains the web implementation of `firebase_messaging`, a modified version of the official Firebase Messaging plugin for Flutter web applications.

## Introduction

Firebase Cloud Messaging (FCM) is a cloud solution for messages on iOS, Android, and web applications. It provides a reliable and efficient connection between the server and devices that allow server applications to send messages to the client.

This modified web implementation offers enhanced functionality over the official Firebase Messaging plugin for web.

## Advantages of this Implementation:

1. **Support for Background Messages**: This plugin supports `onBackgroundMessages` even when the browser is in background mode, a feature not available in the official plugin.

2. **One-Time Initialization**: With this plugin, you only need to create a `firebase-config.js` file with your Firebase configuration. Example:
    ```javascript
    const firebaseConfig = {
       apiKey: "YOUR_API_KEY",
       authDomain: "YOUR_AUTH_DOMAIN",
       projectId: "YOUR_PROJECT_ID",
       storageBucket: "YOUR_STORAGE_BUCKET",
       messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
       appId: "YOUR_APP_ID",
       measurementId: "YOUR_MEASUREMENT_ID"
    };
    ```
   In contrast, the official plugin requires multiple files like `firebase-messaging-sw.js` with embedded credentials.

3. **Flexible File Location**: The official plugin mandates the `firebase-messaging-sw.js` to reside at the root of the domain. Our implementation removes this constraint.

4. **Future Enhancements**: Plans are underway to add callbacks like `onMessageOpenedApp` and methods like `getInitialMessage`.

## Getting Started

1. **Documentation**: For an introduction to Cloud Messaging Web and its setup, please refer to the [documentation](https://firebase.flutter.dev/docs/messaging/overview) on [https://firebase.flutter.dev](https://firebase.flutter.dev).

2. **Web Installation**: After installing the Cloud Messaging, configuration for web installation is required. Kindly follow the [web installation documentation](https://firebase.flutter.dev/docs/messaging/overview#3-web-only-add-the-sdk).

3. **Learn More**: To dive deeper into Firebase Cloud Messaging, explore the official [Firebase website](https://firebase.google.com/products/cloud-messaging).
