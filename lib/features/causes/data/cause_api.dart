import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../model/cause.dart';

class CauseApi {
  const CauseApi(this._dio);

  final Dio _dio;

  Future<List<Cause>> fetchCauses({int limit = 12}) async {
    try {
      final response = await _dio.get<List<dynamic>>('/posts');
      final data = response.data ?? const [];
      return data
          .cast<Map<String, dynamic>>()
          .take(limit)
          .map(Cause.fromJson)
          .toList(growable: false);
    } on DioException catch (error) {
      throw ApiException.from(error);
    } on TypeError {
      throw const ApiException('Received an unexpected response.');
    }
  }
}
