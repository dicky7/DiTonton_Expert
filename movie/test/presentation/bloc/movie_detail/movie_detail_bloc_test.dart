import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';


@GenerateMocks([GetMovieDetail])
void main(){
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  test("Initial State Should be Empty",(){
    expect(movieDetailBloc.state, MovieDetailEmpty());
  });

  final tId = 1;

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Right(testMovieDetail));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailHasData(testMovieDetail)
    ],
    verify: (bloc) => verify(mockGetMovieDetail.execute(tId)),
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Failure] when data is gotten unsuccessfully',
    build: () {
      when(mockGetMovieDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailError("Server Failure")
    ],
    verify: (bloc) => verify(mockGetMovieDetail.execute(tId)),
  );
}