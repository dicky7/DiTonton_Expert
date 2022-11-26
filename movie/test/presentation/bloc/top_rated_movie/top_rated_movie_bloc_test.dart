import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_movie_bloc_test.mocks.dart';


@GenerateMocks([GetTopRatedMovies])
void main(){
  late TopRatedMovieBloc topRatedMovieBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp((){
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMovieBloc = TopRatedMovieBloc(mockGetTopRatedMovies);
  });

  test('initial state should be empty', () {
    expect(topRatedMovieBloc.state, TopRatedMovieEmpty());
  });

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Right(testMovieList));
      return topRatedMovieBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovie()),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieHasData(testMovieList)
    ],
    verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'Should emit [Loading, Error] when data is gotten unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return topRatedMovieBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovie()),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieError("Server Failure")
    ],
    verify: (bloc) => verify(mockGetTopRatedMovies.execute()),
  );


}