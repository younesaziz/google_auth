import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google/main.dart';

class FirebaseApi {
  // Create an instance of firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  // function to initialize notifications
  Future<void> initNotifications() async {
    // request premission from user (will prompt user)
    await _firebaseMessaging.requestPermission();
    // fetch the FCM token for this device
    final FcmToken = await _firebaseMessaging.getToken();
    // print the token (normaly this would send it to server)
    print('token : $FcmToken');

    // initialize further settings for push notification
    initNotifications();
  }

  // function to handle received messages
  void handelMessage(RemoteMessage? message) {
    // if the message is null , do nothing
    if (message == null) return;
    // navigate to new screen when message is recieve and user taps notification
    navigatorKey.currentState
        ?.pushNamed('/notification_screen', arguments: message);
  }

  // function to initialize foreground and background settings
  Future initPushNotifications() async {
    // handle Notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handelMessage);

    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handelMessage);
  }
}
