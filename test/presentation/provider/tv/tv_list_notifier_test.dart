import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/tv/usecase/get_popular_tv.dart';
import 'package:ditonton/domain/tv/usecase/get_top_rated_tv.dart';
import 'package:ditonton/domain/tv/usecase/get_tv_on_the_air.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetTvOnTheAir, GetPopularTv, GetTopRatedTv])
void main() {
  late TvListNotifier provider;
  late MockGetTvOnTheAir mockGetTvOnTheAir;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvOnTheAir = MockGetTvOnTheAir();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    provider = TvListNotifier(
      getTvOnTheAir: mockGetTvOnTheAir,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('tv on the air', () {
    test('initialState should be Empty', () {
      expect(provider.tvOnTheAirState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetTvOnTheAir.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchTvOnTheAir();
      // assert
      verify(mockGetTvOnTheAir.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetTvOnTheAir.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchTvOnTheAir();
      // assert
      expect(provider.tvOnTheAirState, RequestState.Loading);
    });

    test('should change tv when data is gotten successfully', () async {
      // arrange
      when(mockGetTvOnTheAir.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      await provider.fetchTvOnTheAir();
      // assert
      expect(provider.tvOnTheAirState, RequestState.Loaded);
      expect(provider.tvOnTheAir, testTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvOnTheAir.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvOnTheAir();
      // assert
      expect(provider.tvOnTheAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchTvPopular();
      // assert
      expect(provider.popularTvState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change tv data when data is gotten successfully', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      await provider.fetchTvPopular();
      // assert
      expect(provider.popularTvState, RequestState.Loaded);
      expect(provider.popularTv, testTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvPopular();
      // assert
      expect(provider.popularTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedTvState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      await provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedTvState, RequestState.Loaded);
      expect(provider.topRatedTv, testTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
