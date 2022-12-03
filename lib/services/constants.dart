import 'package:intl/intl.dart';

class PriceConverter {
  static convert(price) {
    return '₹ ${double.parse('$price').toStringAsFixed(2)}';
  }

  static convertRound(price) {
    return '₹ ${double.parse('$price').toInt()}';
  }

  static convertToNumberFormat(num price) {
    final format = NumberFormat("#,##,##,##0.00", "en_IN");
    return '₹ ${format.format(price)}';
  }
}

String getStringFromList(List<dynamic>? data) {
  String str = data.toString();
  return data.toString().substring(1, str.length - 1);
}

class AppConstants {
  get getBaseUrl => baseUrl;
  set setBaseUrl(String url) => baseUrl = url;

  //TODO: Change Base Url
  static String baseUrl = 'https://www.base-url.in/';
  // static String baseUrl = 'http://192.168.1.5:9000/'; ///USE FOR LOCAL

  static const String agoraAppId = 'c87b710048c049f59570bd1895b7e561';

  static const String loginUri = 'api/v1/user/login';
  static const String profileUri = 'api/v1/user/profile';
  static const String extras = 'api/v1/extra';
  static const String notification = 'api/v1/user/notifications';
  static const String updateProfileUri = 'api/v1/user/update';
  static const String getLeadsUri = 'api/v1/user/leads';
  static const String getAppointmentsByLeadsUri = 'api/v1/user/leads/';
  static const String createLeadsUri = 'api/v1/user/create-lead';
  static const String addAppointmentUri = 'api/v1/user/schedule-appointment';
  static const String deleteAppointmentUri = 'api/v1/user/delete-lead';
  static const String sendMessage = 'api/v1/user/send-message'; //message, receiver
  static const String getMessages = 'api/v1/user/messages';
  static const String upcomingAppointmentUri = 'api/v1/user/upcoming-appointments';

  static const String getAllUsersUri = 'api/v1/admin/users';
  static const String blockUserUri = 'api/v1/admin/block-user';
  static const String unblockUserUri = 'api/v1/admin/unblock-user';
  static const String sendNotificationUri = 'api/v1/admin/send-notification';
  static const String updateExtraUri = 'api/v1/admin/update-extra';
  static const String updateUserAdminUri = 'api/v1/admin/update-user';

  // Shared Key
  static const String token = 'user_app_token';
  static const String userId = 'user_app_id';
  static const String razorpayKey = 'razorpay_key';
  static const String recentOrders = 'recent_orders';
  static const String isUser = 'is_user';
}
