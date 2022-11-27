import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecase/get_popular_tv.dart';
import 'package:tv/domain/usecase/get_tv_on_the_air.dart';
import 'package:tv/presentation/bloc/tv_on_air/tv_on_air_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_on_air_bloc_test.mocks.dart';

@GenerateMocks([GetTvOnTheAir])
void main(){
  late TvOnAirBloc tvOnAirBloc;
  late MockGetTvOnTheAir mockGetTvOnTheAir;

  setUp((){
    mockGetTvOnTheAir = MockGetTvOnTheAir();
    tvOnAirBloc = TvOnAirBloc(mockGetTvOnTheAir);
  });

  test('initial state should be empty', () {
    expect(tvOnAirBloc.state, TvOnAirEmpty());
  });

  blocTest<TvOnAirBloc, TvOnAirState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvOnTheAir.execute()).thenAnswer((_) async => Right(testTvList));
      return tvOnAirBloc;
    },
    act: (bloc) => bloc.add(FetchTvOnAir()),
    expect: () => [
      TvOnAirLoading(),
      TvOnAirHasData(testTvList)
    ],
    verify: (bloc) => verify(mockGetTvOnTheAir.execute()),
  );

  blocTest<TvOnAirBloc, TvOnAirState>(
    'Should emit [Loading, Error] when data is gotten unsuccessful',
    build: () {
      when(mockGetTvOnTheAir.execute()).thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return tvOnAirBloc;
    },
    act: (bloc) => bloc.add(FetchTvOnAir()),
    expect: () => [
      TvOnAirLoading(),
      TvOnAirError("Server Failure")
    ],
    verify: (bloc) => verify(mockGetTvOnTheAir.execute()),
  );
}
