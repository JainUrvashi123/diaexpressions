import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/notification_model.dart';

class NotificationService {
  final Dio _dio = DioClient().dio;

  Future<NotificationResponse> getNotifications(String userId) async {
    try {
      final response = await _dio.get(
        '/m_api/notifications',
        data: {'user_id': userId},
      );

      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      if (response.statusCode == 200) {
        if (responseData is Map<String, dynamic>) {
          return NotificationResponse.fromJson(responseData);
        } else {
          throw Exception('Invalid server response format');
        }
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(DioClient.getErrorMessage(e, defaultMessage: 'Failed to fetch notifications'));
    }
  }
}
