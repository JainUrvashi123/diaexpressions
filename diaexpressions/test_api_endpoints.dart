import 'package:dio/dio.dart';
import 'lib/core/network/dio_client.dart';

void main() async {
  await DioClient.initCookies();
  final dio = DioClient().dio;

  Future<void> testPost(String path, Map<String, dynamic> data) async {
    try {
      final res = await dio.post(
        path,
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      print("SUCCESS POST $path with $data: ${res.statusCode} -> ${res.data}");
    } on DioException catch (e) {
      print("FAIL POST $path with $data: ${e.response?.statusCode} -> ${e.response?.data}");
    } catch (e) {
      print("ERROR POST $path: $e");
    }
  }

  // Probe POST /m_api/notifications with different parameters
  await testPost('/m_api/notifications', {'user_id': '34', 'notification_id': '1'});
  await testPost('/m_api/notifications', {'user_id': '34', 'notification_id': '1', 'is_read': '1'});
  await testPost('/m_api/notifications', {'user_id': '34', 'notification_id': '1', 'action': 'read'});
  await testPost('/m_api/notifications', {'user_id': '34', 'notification_id': '1', 'status': 'read'});
  await testPost('/m_api/notifications', {'user_id': '34', 'id': '1'});
}
