import 'package:dio/dio.dart';

import '../model/near_earth_object_model.dart';

class Api {
  final Dio _dio;

  Api(this._dio);

  Future<List<NearEarthObjectModel>> getNearEarthObject({
    void Function(int count, int total)? progressCallback,
  }) async {
    final response = await _dio.get(
      'neo/rest/v1/feed',
      onReceiveProgress: progressCallback,
    );
    final json = response.data;
    final nearEarthObjects = json['near_earth_objects'] as Map;
    return nearEarthObjects.values
        .expand((element) => element)
        .map((element) => NearEarthObjectModel.fromJson(element))
        .toList();
  }
}
