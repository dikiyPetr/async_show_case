import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'near_earth_object_model.freezed.dart';
part 'near_earth_object_model.g.dart';

@freezed
class NearEarthObjectModel with _$NearEarthObjectModel{

  factory NearEarthObjectModel({required String id, required String name})=_FeedNetworkModel;

  factory NearEarthObjectModel.fromJson(Map<String, dynamic> json) => _$NearEarthObjectModelFromJson(json);
}
