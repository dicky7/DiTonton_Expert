
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
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
  MockSpec<IOClient>(as: #MockHttpClient)
])
void main() {}
