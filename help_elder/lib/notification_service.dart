import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class CustomNotification{
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

}

class NotificationService{
  late FlutterLocalNotificationsPlugin localNotificationPlugin;
  late AndroidNotificationDetails _androidNotificationDetails;

  NotificationService(){
    localNotificationPlugin = FlutterLocalNotificationsPlugin();
    _setupNotification();
  }

  _setupNotification() async{
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async{
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _initializeNotifications() async{
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotificationPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),
      onSelectNotification: _onSelectNotification,
    );   
  }
  _onSelectNotification(String? payload) async{
    if(payload != null && payload.isNotEmpty){
      print('Notification payload: $payload');
    }
  }
  ShowNotification(CustomNotification notification){
    _androidNotificationDetails = const AndroidNotificationDetails(
      '1', 
      'teste titulo', 
      channelDescription: 'teste descrição',
    );
    localNotificationPlugin.show(
      notification.id, 
      notification.title, 
      notification.body, 
      NotificationDetails(
        android: _androidNotificationDetails,
      ),
      payload: notification.payload,
    );
  }
  CheckForNotification() async{
    final details = await localNotificationPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp){
      
    }
  }
}
