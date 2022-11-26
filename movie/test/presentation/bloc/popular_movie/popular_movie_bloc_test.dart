import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_event.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_state.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_movie_bloc_test.mocks.dart';


@GenerateMocks([GetPopularMovies])
void main(){
  late PopularMovieBloc popularMovieBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp((){
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(mockGetPopularMovies);
  });

  test('initial state should be empty', () {
    expect(popularMovieBloc.state, PopularMovieEmpty());
  });

  blocTest<PopularMovieBloc, PopularMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(testMovieList));
      return popularMovieBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovie()),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieHasData(testMovieList)
    ],
    verify: (bloc) => verify(mockGetPopularMovies.execute()),
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'Should emit [Loading, Error] when data is gotten unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return popularMovieBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovie()),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieError("Server Failure")
    ],
    verify: (bloc) => verify(mockGetPopularMovies.execute()),
  );

}