
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:tv/data/datasources/db/tv_database_helper.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

@GenerateMocks([
  TvRemoteDataSource,
  TvLocalDataSource,
  TvRepository,
  TvDatabaseHelper,

], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
