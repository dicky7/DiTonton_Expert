import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecase/get_popular_tv.dart';
import 'package:tv/domain/usecase/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecase/get_watchlist_tv.dart';
import 'package:tv/domain/usecase/remove_watchlist_tv.dart';
import 'package:tv/domain/usecase/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watclist_tv/watchlist_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchListStatusTv, GetWatchListTv,RemoveWatchListTv, SaveWatchListTv])
void main(){
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchListTv mockGetWatchListTv;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockRemoveWatchListTv mockRemoveWatchListTv;
  late MockSaveWatchListTv mockSaveWatchListTv;

  setUp(() {
    mockGetWatchListTv = MockGetWatchListTv();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockRemoveWatchListTv = MockRemoveWatchListTv();
    mockSaveWatchListTv = MockSaveWatchListTv();

    watchlistTvBloc = WatchlistTvBloc(
        mockGetWatchListTv, mockGetWatchListStatusTv,
        mockSaveWatchListTv, mockRemoveWatchListTv);
  });

  test("Initial Watchlist Movie should be Empty", () {
    expect(watchlistTvBloc.state, WatchlistTvEmpty());
  });

  group("List Watchlist Tv", () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, ListWatchlist] when data is gotten successful',
      build: () {
        when(mockGetWatchListTv.execute()).thenAnswer((_) async => Right([testWatchlistTv]));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvList()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvHasData([testWatchlistTv])
      ],
      verify: (bloc){
        verify(mockGetWatchListTv.execute());
        return WatchlistTvList().props;
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, Error] when data is gotten unsuccessful',
      build: () {
        when(mockGetWatchListTv.execute()).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvList()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvError("Server Failure")
      ],
      verify: (bloc){
        verify(mockGetWatchListTv.execute());
        return WatchlistTvList().props;
      },
    );
  });

  group("Add Watchlist Tv", () {
    final tAddedMessage = "Added to Watchlist";
    final tAddedMessageFailure = 'can\'t add data to watchlist';

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should send message success when adding movie to watchlist is successfully',
      build: () {
        when(mockSaveWatchListTv.execute(testTvDetail)).thenAnswer((_) async => Right(tAddedMessage));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvAdd(testTvDetail)),
      expect: () => [
        WatchlistTvMessage(tAddedMessage)
      ],
      verify: (bloc){
        verify(mockSaveWatchListTv.execute(testTvDetail));
        return WatchlistTvAdd(testTvDetail).props;
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should send message failure when adding movie to watchlist is unsuccessfully',
      build: () {
        when(mockSaveWatchListTv.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure(tAddedMessageFailure)));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvAdd(testTvDetail)),
      expect: () => [
        WatchlistTvError(tAddedMessageFailure)
      ],
      verify: (bloc){
        verify(mockSaveWatchListTv.execute(testTvDetail));
        return WatchlistTvAdd(testTvDetail).props;
      },
    );
  });

  group("Remove Watchlist Movie", () {
    final tAddedMessage = "Removed from Watchlist";
    final tAddedMessageFailure = 'can\'t remove data from watchlist';

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should send message when remove movie from watchlist is successfully',
      build: () {
        when(mockRemoveWatchListTv.execute(testTvDetail)).thenAnswer((_) async => Right(tAddedMessage));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvRemove(testTvDetail)),
      expect: () => [
        WatchlistTvMessage(tAddedMessage)
      ],
      verify: (bloc){
        verify(mockRemoveWatchListTv.execute(testTvDetail));

      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should send message failure when remove movie from watchlist is unsuccessfully',
      build: () {
        when(mockRemoveWatchListTv.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure(tAddedMessageFailure)));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvRemove(testTvDetail)),
      expect: () => [
        WatchlistTvError(tAddedMessageFailure)
      ],
      verify: (bloc){
        verify(mockRemoveWatchListTv.execute(testTvDetail));
      },
    );
  });

  group("Watchlist Tv Status", () {
    final tId = 1;
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should send return true when movie isAdded to watchlist',
      build: () {
        when(mockGetWatchListStatusTv.execute(tId)).thenAnswer((_) async => true);
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvStatus(tId)),
      expect: () => [
        TvIsAddedToWatchlist(true)
      ],
      verify: (bloc){
        verify(mockGetWatchListStatusTv.execute(tId));
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should send return true when movie not yet Added to watchlist',
      build: () {
        when(mockGetWatchListStatusTv.execute(tId)).thenAnswer((_) async => false);
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvStatus(tId)),
      expect: () => [
        TvIsAddedToWatchlist(false)
      ],
      verify: (bloc){
        verify(mockGetWatchListStatusTv.execute(tId));
      },
    );
  });
}