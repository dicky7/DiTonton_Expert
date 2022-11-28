import 'dart:convert';
import 'dart:io';

import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/model/tv_detail_model.dart';
import 'package:tv/data/model/tv_response.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';


void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group("get Tv On The Air", () {
    final tvList =
        TvResponse.fromJson(json.decode(readJson("dummy_data/on_the_air.json"))).tvList;

    test('should return list of TVShow Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson("dummy_data/on_the_air.json"), 200, headers: {
                    HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
                  }));
      // act
      final result = await dataSource.getTvOnTheAir();
      // assert
      expect(result, equals(tvList));
    });

    test('should throw a ServerException when the response code is 404 or other', () {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      //act
      final call = dataSource.getTvOnTheAir();
      //assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tv', () {
    final tvList = TvResponse.fromJson(json.decode(readJson('dummy_data/tv_popular.json'))).tvList;
    test('should return list of tv when response is success (200)', () async {
          // arrange
          when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/popular?$API_KEY")))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200, headers: {
                HttpHeaders.contentTypeHeader:
                'application/json; charset=utf-8',
              }));
          // act
          final result = await dataSource.getTvPopular();
          // assert
          expect(result, tvList);
        });

    test('should throw a ServerException when the response code is 404 or other', () async {
          // arrange
          when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/popular?$API_KEY")))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTvPopular();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Top Rated Tv', () {
    final tvList = TvResponse.fromJson(json.decode(readJson('dummy_data/tv_top_rated.json'))).tvList;

    test('should return list of tv when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_top_rated.json'), 200, headers: {
            HttpHeaders.contentTypeHeader:
            'application/json; charset=utf-8',
          }));
      // act
      final result = await dataSource.getTopRated();
      // assert
      expect(result, tvList);
    });

    test('should throw ServerException when response code is other than 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRated();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });

  });

  group('get tv detail', () {
    final tId = 1;
    final tMovieDetail = TvDetailModel.fromJson(json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_detail.json'), 200, headers: {
            HttpHeaders.contentTypeHeader:
            'application/json; charset=utf-8',
          }));
      // act
      final result = await dataSource.getTvDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test('should throw Server Exception when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tMovieList = TvResponse.fromJson(json.decode(readJson('dummy_data/tv_recommendation.json'))).tvList;
    final tId = 1;

    test('should return list of Movie Model when the response code is 200', () async {
      // arrange
      when(mockHttpClient
          .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
          readJson('dummy_data/tv_recommendation.json'), 200, headers: {
            HttpHeaders.contentTypeHeader:
            'application/json; charset=utf-8',
          }));
      // act
      final result = await dataSource.getTvRecommendations(tId);
      // assert
      expect(result, equals(tMovieList));
    });

    test('should throw Server Exception when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient
          .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv', () {
    final tSearchResult = TvResponse.fromJson(json.decode(readJson('dummy_data/tv_search.json'))).tvList;
    final tQuery = 'demon';

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(mockHttpClient
          .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('dummy_data/tv_search.json'), 200, headers: {
            HttpHeaders.contentTypeHeader:
            'application/json; charset=utf-8',
          }));
      // act
      final result = await dataSource.searchTv(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.searchTv(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });
}
