import 'dart:convert';

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/tv/model/tv_model.dart';
import 'package:ditonton/data/tv/model/tv_response.dart';
import '../model/tv_detail_model.dart';
import 'package:http/http.dart' as http;

abstract class TvRemoteDataSource{
  Future<List<TvModel>> getTvOnTheAir();
  Future<List<TvModel>> getTvPopular();
  Future<List<TvModel>> getTopRated();
  Future<TvDetailModel> getTvDetail(int id);
  Future<List<TvModel>> getTvRecommendations(int id);
  Future<List<TvModel>> searchTv(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource{
  final http.Client client;
  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvModel>> getTvOnTheAir() async{
    final response = await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }

  @override
  Future<TvDetailModel> getTvDetail(int id) async{
    final response = await client.get(Uri.parse("$BASE_URL/tv/$id?$API_KEY"));
    if (response.statusCode == 200) {
      return TvDetailModel.fromJson(json.decode(response.body));
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id) async{
    final response = await client.get(Uri.parse("$BASE_URL/tv/$id/recommendations?$API_KEY"));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvPopular() async{
    final response = await client.get(Uri.parse("$BASE_URL/tv/popular?$API_KEY"));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRated() async{
    final response = await client.get(Uri.parse("$BASE_URL/tv/top_rated?$API_KEY"));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }


  @override
  Future<List<TvModel>> searchTv(String query) async{
    final response = await client.get(Uri.parse("$BASE_URL/search/tv?$API_KEY&query=$query"));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    }else{
      throw ServerException();
    }
  }

}