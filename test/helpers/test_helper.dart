import 'package:ditonton/data/movie/datasources/db/database_helper.dart';
import 'package:ditonton/data/movie/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/movie/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/tv/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/tv/datasources/tv_remote_data_source.dart';
import 'package:ditonton/domain/movie/repositories/movie_repository.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/domain/tv/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  NetworkInfo,

  TvRemoteDataSource,
  TvLocalDataSource,
  TvRepository

], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
