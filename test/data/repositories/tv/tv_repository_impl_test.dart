import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/tv/model/tv_model.dart';
import 'package:ditonton/data/tv/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockTvRemoteDataSource;
  late MockTvLocalDataSource mockTvLocalDataSource;

  setUp(() {
    mockTvRemoteDataSource = MockTvRemoteDataSource();
    mockTvLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
        remoteDataSource: mockTvRemoteDataSource,
        localDataSource: mockTvLocalDataSource
    );
  });

  final tTvModel = TvModel(
      backdropPath: "/A7pq4B0uCPCLvk1EPFKQgJZQoVG.jpg",
      firstAirDate: "2022-08-25",
      genreIds:  [
        16,
        35
      ],
      id: 125392,
      name: "Little Demon",
      originalLanguage: "en",
      originalName: "Little Demon",
      overview: "13 years after being impregnated by Satan, a reluctant mother, Laura, and her Antichrist daughter, Chrissy, attempt to live an ordinary life in Delaware, but are constantly thwarted by monstrous forces, including Satan, who yearns for custody of his daughter's soul.",
      popularity: 10.956,
      posterPath: "/2lyFPOe6JScMBiLQuMtf3pPZxAu.jpg",
      voteAverage:  8.7,
      voteCount: 25
  );

  final tTv = Tv(
      backdropPath: "/A7pq4B0uCPCLvk1EPFKQgJZQoVG.jpg",
      firstAirDate: "2022-08-25",
      genreIds:  [
        16,
        35
      ],
      id: 125392,
      name: "Little Demon",
      originalLanguage: "en",
      originalName: "Little Demon",
      overview: "13 years after being impregnated by Satan, a reluctant mother, Laura, and her Antichrist daughter, Chrissy, attempt to live an ordinary life in Delaware, but are constantly thwarted by monstrous forces, including Satan, who yearns for custody of his daughter's soul.",
      popularity: 10.956,
      posterPath: "/2lyFPOe6JScMBiLQuMtf3pPZxAu.jpg",
      voteAverage:  8.7,
      voteCount: 25
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group("Tv On The Air", () {
    test('should return tv list when call to data source is successful', () async{
      //arrange
      when(mockTvRemoteDataSource.getTvOnTheAir()).thenAnswer((_) async => tTvModelList);
      //act
      final result = await repository.getTvOnTheAir();
      //assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return server failure when call to data source is unsuccessful', () async {
      //arrange
      when(mockTvRemoteDataSource.getTvOnTheAir()).thenThrow(ServerException());
      //act
      final result = await repository.getTvOnTheAir();
      //assert
      expect(result, Left(ServerFailure("")));

    });

    test('should return connection failure when device is not connected to the internet', () async {
      //arrange
      when(mockTvRemoteDataSource.getTvOnTheAir()).thenThrow(SocketException('Failed to connect to the network'));
      //act
      final result = await repository.getTvOnTheAir();
      //assert
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group("Tv Popular", () {
    test('should return tv list when call to data source is successful', () async{
      //arrange
      when(mockTvRemoteDataSource.getTvPopular()).thenAnswer((_) async => tTvModelList);
      //act
      final result = await repository.getPopularTv();
      //assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return server failure when call to data source is unsuccessful', () async {
      //arrange
      when(mockTvRemoteDataSource.getTvPopular()).thenThrow(ServerException());
      //act
      final result = await repository.getPopularTv();
      //assert
      expect(result, Left(ServerFailure("")));

    });

    test('should return connection failure when device is not connected to the internet', () async {
      //arrange
      when(mockTvRemoteDataSource.getTvPopular()).thenThrow(SocketException('Failed to connect to the network'));
      //act
      final result = await repository.getPopularTv();
      //assert
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group("Tv Top Rated", () {
    test('should return tv list when call to data source is successful', () async{
      //arrange
      when(mockTvRemoteDataSource.getTopRated()).thenAnswer((_) async => tTvModelList);
      //act
      final result = await repository.getTopRatedTv();
      //assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return server failure when call to data source is unsuccessful', () async {
      //arrange
      when(mockTvRemoteDataSource.getTopRated()).thenThrow(ServerException());
      //act
      final result = await repository.getTopRatedTv();
      //assert
      expect(result, Left(ServerFailure("")));

    });

    test('should return connection failure when device is not connected to the internet', () async {
      //arrange
      when(mockTvRemoteDataSource.getTopRated()).thenThrow(SocketException('Failed to connect to the network'));
      //act
      final result = await repository.getTopRatedTv();
      //assert
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group("Search Tv", () {
    final query = "devil";

    test('should return tv list when call to data source is successful', () async{
      //arrange
      when(mockTvRemoteDataSource.searchTv(query)).thenAnswer((_) async => tTvModelList);
      //act
      final result = await repository.searchTv(query);
      //assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return server failure when call to data source is unsuccessful', () async {
      //arrange
      when(mockTvRemoteDataSource.searchTv(query)).thenThrow(ServerException());
      //act
      final result = await repository.searchTv(query);
      //assert
      expect(result, Left(ServerFailure("")));

    });

    test('should return connection failure when device is not connected to the internet', () async {
      //arrange
      when(mockTvRemoteDataSource.searchTv(query)).thenThrow(SocketException('Failed to connect to the network'));
      //act
      final result = await repository.searchTv(query);
      //assert
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockTvLocalDataSource.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchListTv(testTvDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockTvLocalDataSource.insertWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchListTv(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockTvLocalDataSource.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchListTv(testTvDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockTvLocalDataSource.removeWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchListTv(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockTvLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchList(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockTvLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchListTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}