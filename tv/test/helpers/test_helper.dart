
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TvRemoteDataSource,
  TvLocalDataSource,
  TvRepository,
  TvDatabaseHelper,

], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
