import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FcmHelper {
  FcmHelper._();

  static final FcmHelper fcmHelper = FcmHelper._();

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> fetchFCMToken() async {
    String? token = await firebaseMessaging.getToken();

    log('----------');
    log('$token');
    log('----------');
    return token;
  }

  Future<void> requestFCMNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');
  }

  Future<String> getAccessToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      await rootBundle.loadString(
          'assets/chat-app-fbminer-firebase-adminsdk-q3yaf-cd9a5f942c.json'),
    );
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final authClient =
        await clientViaServiceAccount(accountCredentials, scopes);
    return authClient.credentials.accessToken.data;
  }

  Future<void> sendFCM(
      {required String title,
      required String body,
      required String token}) async {
    final String accessToken = await getAccessToken();
    const String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/chat-app-fbminer/messages:send';
    final Map<String, dynamic> myBody = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'age': '22',
          'school': 'PQR',
        }
      },
    };
    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(myBody),
    );
    if (response.statusCode == 200) {
      log('-------------------');
      log('Notification sent  successfully ');
      log('-------------------');
    } else {
      log('-------------------');
      log('Failed to send notification:${response.body}');
      log('-------------------');
    }
  }
}
