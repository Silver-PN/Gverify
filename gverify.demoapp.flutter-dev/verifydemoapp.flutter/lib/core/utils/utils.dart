
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils{

 static Future<void> setStringValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key,value);

  }

 static Future<void> setIntValue(String key, int value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key,value);
  }

 static Future<void> setBooleanValue(String key, bool value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key,value);
  }

 static Future<bool> getBooleanValue(String key) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

 static Future<void> removeKey(String key) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);  // Xóa key và giá trị liên quan

  }

 static Future<void> removeAll()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Xóa toàn bộ dữ liệu trong SharedPreferences

  }

 Future<String> getDeviceId() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String? deviceId = prefs.getString('device_id');
   if(deviceId == null){
     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
     if (Platform.isAndroid) {
       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
       deviceId = androidInfo.id;
     } else if (Platform.isIOS) {
       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
       deviceId = iosInfo.identifierForVendor; // Trả về identifierForVendor
     }
     deviceId ??= randomUuid();
     await prefs.setString('device_id', deviceId);
   }
   return deviceId;
 }

 String randomUuid(){
   Random random = Random();
   const int length = 8;
   const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

   return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
 }

 String generateOtp() {
   var random = Random();
   int otp = 100000 + random.nextInt(900000);
   return otp.toString();
 }
}