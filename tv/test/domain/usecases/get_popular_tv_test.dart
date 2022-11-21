import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecase/get_popular_tv.dart';

import '../../helpers/test_helper.mocks.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late GetPopularTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetPopularTv(mockTvRepository);
  });

  final tTv = <Tv>[];

  group('GetPopularTv Tests', () {
    group('execute', () {
      test('should get list of Tv from the repository when execute function is called', () async {
        // arrange
        when(mockTvRepository.getPopularTv()).thenAnswer((_) async => Right(tTv));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tTv));
      });
    });
  });
}
