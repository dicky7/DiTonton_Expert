import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movie/now_playing_movie_state.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movie_bloc_test.mocks.dart';


@GenerateMocks([GetNowPlayingMovies])
void main(){
  late NowPlayingMovieBloc nowPlayingMovieBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp((){
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMovieBloc = NowPlayingMovieBloc(mockGetNowPlayingMovies);
  });

  test('initial state should be empty', () {
    expect(nowPlayingMovieBloc.state, NowPlayingMovieEmpty());
  });

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(testMovieList));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(FetchNewPlayingMovie()),
    expect: () => [
      NowPlayingMovieLoading(),
      NowPlayingMovieHasData(testMovieList)
    ],
    verify: (bloc) => verify(mockGetNowPlayingMovies.execute()),
  );

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingMovieBloc;
    },
    act: (bloc) => bloc.add(FetchNewPlayingMovie()),
    expect: () => [
      NowPlayingMovieLoading(),
      NowPlayingMovieError("Server Failure")
    ],
    verify: (bloc) => verify(mockGetNowPlayingMovies.execute()),
  );

}