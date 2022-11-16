import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';

import '../repositories/tv_repository.dart';

class GetTvRecommendations{
  final TvRepository repository;

  GetTvRecommendations(this.repository);
  Future<Either<Failure, List<Tv>>> execute(int id){
    return repository.getTvRecommendations(id);
  }
}