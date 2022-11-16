import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/movie/entities/movie.dart';
import 'package:ditonton/domain/movie/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/tv/usecase/get_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main(){
  late GetWatchListTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchListTv(mockTvRepository);
  });

  test('should get list of tv from the repository', () async {
    // arrange
    when(mockTvRepository.getWatchListTv())
        .thenAnswer((_) async => Right(testTvList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvList));
  });
}

