import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/movie/entities/movie.dart';
import 'package:ditonton/domain/movie/usecases/search_movies.dart';
import 'package:ditonton/domain/tv/usecase/search_tv.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_search_notifier_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTv])
void main() {
  late SearchNotifier provider;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTv mockSearchTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchMovies = MockSearchMovies();
    mockSearchTv = MockSearchTv();
    provider =
        SearchNotifier(searchMovies: mockSearchMovies, searchTv: mockSearchTv)
          ..addListener(() {
            listenerCallCount += 1;
          });
  });

  final tQueryMovie = 'spiderman';
  final tQueryTv = 'spiderman';

  group('search movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchMovies.execute(tQueryMovie)).thenAnswer((_) async => Right(testMovieList));
      // act
      provider.fetchMovieSearch(tQueryMovie);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully', () async {
      // arrange
      when(mockSearchMovies.execute(tQueryMovie)).thenAnswer((_) async => Right(testMovieList));
      // act
      await provider.fetchMovieSearch(tQueryMovie);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.movieSearchResult, testMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchMovies.execute(tQueryMovie))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchMovieSearch(tQueryMovie);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('search tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTv.execute(tQueryTv)).thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchTvSearch(tQueryTv);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully', () async {
      // arrange
      when(mockSearchTv.execute(tQueryTv)).thenAnswer((_) async => Right(testTvList));
      // act
      await provider.fetchTvSearch(tQueryTv);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.tvSearchResult, testTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTv.execute(tQueryTv))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSearch(tQueryTv);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
