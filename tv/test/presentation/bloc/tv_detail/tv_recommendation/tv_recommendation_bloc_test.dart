import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecase/get_popular_tv.dart';
import 'package:tv/domain/usecase/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_recommendation/tv_recommendation_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetTvRecommendations])
void main(){
  late TvRecommendationBloc tvRecommendationBloc;
  late MockGetTvRecommendations mockGetTvRecommendations;

  setUp((){
    mockGetTvRecommendations = MockGetTvRecommendations();
    tvRecommendationBloc = TvRecommendationBloc(mockGetTvRecommendations);
  });

  test('initial state should be empty', () {
    expect(tvRecommendationBloc.state, TvRecommendationEmpty());
  });

  final tId = 1;
  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvRecommendations.execute(tId)).thenAnswer((_) async => Right(testTvList));
      return tvRecommendationBloc;
    },
    act: (bloc) => bloc.add(FetchTvRecommendation(tId)),
    expect: () => [
      TvRecommendationLoading(),
      TvRecommendationHasData(testTvList)
    ],
    verify: (bloc) => verify(mockGetTvRecommendations.execute(tId)),
  );

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'Should emit [Loading, Error] when data is gotten unsuccessful',
    build: () {
      when(mockGetTvRecommendations.execute(tId)).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return tvRecommendationBloc;
    },
    act: (bloc) => bloc.add(FetchTvRecommendation(tId)),
    expect: () => [
      TvRecommendationLoading(),
      TvRecommendationError("Server Failure")
    ],
    verify: (bloc) => verify(mockGetTvRecommendations.execute(tId)),
  );
}
