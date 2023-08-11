@JS()
library firebase_msg.js;

import 'package:js/js.dart';

@JS()
external dynamic initFBMsg(dynamic data);

@JS()
external dynamic deleteToken();

@JS()
external dynamic getToken(dynamic vapidKey);
