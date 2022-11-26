import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/presentation/bloc/movie_detail/recommendation/movie_recommendation_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'movie_recommendation_bloc_test.mocks.dart';


@GenerateMocks([GetMovieRecommendations])
void main(){
  late MovieRecommendationBloc movieRecommendationBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp((){
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationBloc = MovieRecommendationBloc(mockGetMovieRecommendations);
  });

  test("Initial State Should be Empty", (){
    expect(movieRecommendationBloc.state, MovieRecommendationEmpty());
  });

  final tId = 1;
  blocTest<MovieRecommendationBloc, MovieRecommendationState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Right(testMovieList));
      return movieRecommendationBloc;
    },
    act: (bloc) => bloc.add(FetchMovieRecommendation(tId)),
    expect: () => [
      MovieRecommendationLoading(),
      MovieRecommendationHasData(testMovieList)
    ],
    verify: (bloc) => verify(mockGetMovieRecommendations.execute(tId)),
  );

  blocTest<MovieRecommendationBloc, MovieRecommendationState>(
    'Should emit [Loading, Failure] when data is gotten unsuccessfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return movieRecommendationBloc;
    },
    act: (bloc) => bloc.add(FetchMovieRecommendation(tId)),
    expect: () => [
      MovieRecommendationLoading(),
      MovieRecommendationError("Server Failure")
    ],
    verify: (bloc) => verify(mockGetMovieRecommendations.execute(tId)),

  );
}