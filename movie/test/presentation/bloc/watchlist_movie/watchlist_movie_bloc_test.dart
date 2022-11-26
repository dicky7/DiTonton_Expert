import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks(
    [GetWatchListStatus, GetWatchlistMovies, RemoveWatchlist, SaveWatchlist])
void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockSaveWatchlist mockSaveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockSaveWatchlist = MockSaveWatchlist();

    watchlistMovieBloc = WatchlistMovieBloc(
        mockGetWatchlistMovies, mockGetWatchListStatus,
        mockRemoveWatchlist, mockSaveWatchlist);
  });

  test("Initial Watchlist Movie should be Empty", () {
    expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
  });

  group("List Watchlist Movie", () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, ListWatchlist] when data is gotten successful',
      build: () {
        when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Right([testWatchlistMovie]));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieList()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieHasData([testWatchlistMovie])
      ],
      verify: (bloc){
        verify(mockGetWatchlistMovies.execute());
        return WatchlistMovieList().props;
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, Error] when data is gotten unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieList()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieError("Server Failure")
      ],
      verify: (bloc){
        verify(mockGetWatchlistMovies.execute());
        return WatchlistMovieList().props;
      },
    );
  });

  group("Add Watchlist Movie", () {
    final tAddedMessage = "Added to Watchlist";
    final tAddedMessageFailure = 'can\'t add data to watchlist';

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should send message success when adding movie to watchlist is successfully',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right(tAddedMessage));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieAdd(testMovieDetail)),
      expect: () => [
        WatchlistMovieMessage(tAddedMessage)
      ],
      verify: (bloc){
        verify(mockSaveWatchlist.execute(testMovieDetail));
        return WatchlistMovieAdd(testMovieDetail).props;
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should send message failure when adding movie to watchlist is unsuccessfully',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure(tAddedMessageFailure)));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieAdd(testMovieDetail)),
      expect: () => [
        WatchlistMovieError(tAddedMessageFailure)
      ],
      verify: (bloc){
        verify(mockSaveWatchlist.execute(testMovieDetail));
        return WatchlistMovieAdd(testMovieDetail).props;
      },
    );
  });

  group("Remove Watchlist Movie", () {
    final tAddedMessage = "Removed from Watchlist";
    final tAddedMessageFailure = 'can\'t remove data from watchlist';

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should send message when remove movie from watchlist is successfully',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Right(tAddedMessage));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieRemove(testMovieDetail)),
      expect: () => [
        WatchlistMovieMessage(tAddedMessage)
      ],
      verify: (bloc){
        verify(mockRemoveWatchlist.execute(testMovieDetail));

      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should send message failure when remove movie from watchlist is unsuccessfully',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure(tAddedMessageFailure)));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieRemove(testMovieDetail)),
      expect: () => [
        WatchlistMovieError(tAddedMessageFailure)
      ],
      verify: (bloc){
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );
  });

  group("Watchlist Movie Status", () {
    final tId = 1;
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should send return true when movie isAdded to watchlist',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieStatus(tId)),
      expect: () => [
        MovieIsAddedToWatchlist(true)
      ],
      verify: (bloc){
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should send return true when movie not yet Added to watchlist',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieStatus(tId)),
      expect: () => [
        MovieIsAddedToWatchlist(false)
      ],
      verify: (bloc){
        verify(mockGetWatchListStatus.execute(tId));
      },
    );
  });
}