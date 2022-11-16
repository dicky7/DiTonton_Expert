import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:ditonton/domain/tv/repositories/tv_repository.dart';

import '../../../common/failure.dart';

class GetTvOnTheAir{
  final TvRepository repository;

  GetTvOnTheAir(this.repository);

  Future<Either<Failure, List<Tv>>> execute(){
    return repository.getTvOnTheAir();
  }
}