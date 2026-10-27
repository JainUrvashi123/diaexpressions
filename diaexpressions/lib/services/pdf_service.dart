import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../models/pdf_model.dart';

class PdfService {
  final Dio _dio = DioClient().dio;

  Future<List<PdfModel>> getPdfList() async {
    try {
      final response = await _dio.get('/m_api/pdf-list');

      var responseData = response.data;
      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (_) {}
      }

      if (response.statusCode == 200) {
        if (responseData is Map && (responseData['status'] == true || responseData['status'] == 1)) {
          final data = responseData['data'] as List? ?? [];
          return data.map((item) => PdfModel.fromJson(item)).toList();
        } else {
          final msg = responseData is Map ? responseData['message'] : null;
          throw msg ?? 'Failed to fetch PDF list';
        }
      } else {
        throw 'Server error';
      }
    } on DioException catch (e) {
      throw 'Network error: ${DioClient.getErrorMessage(e)}';
    } catch (e) {
      if (e is String) rethrow;
      throw 'An error occurred';
    }
  }
}
