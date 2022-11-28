import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecase/get_tv_recommendations.dart';

import '../../helpers/test_helper.mocks.dart';


void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockTvRepository);
  });

  final id = 1;
  final tTv = <Tv>[];

  test('should get list of tv from the repository', () async {
    // arrange
    when(mockTvRepository.getTvRecommendations(id)).thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute(id);
    // assert
    expect(result, Right(tTv));
  });
}
