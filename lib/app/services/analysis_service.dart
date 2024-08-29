import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AnalysisService extends GetxService {
  final Dio _dio = Dio();
  final String _baseUrl =
      'https://kelolain-knn-model-production.up.railway.app/predict';

  Future<Map<String, dynamic>> getAnalysis(Map<String, dynamic> data) async {
    try {
      print(data);
      final response = await _dio.post(
        _baseUrl,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error response: ${response.data}');
        throw Exception(
            'Failed to get analysis. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAnalysis: $e');
      throw Exception('Failed to get analysis: $e');
    }
  }
}
