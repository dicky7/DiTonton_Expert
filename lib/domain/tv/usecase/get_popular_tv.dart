import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:ditonton/domain/tv/repositories/tv_repository.dart';

class GetPopularTv{
  final TvRepository repository;

  GetPopularTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute(){
    return repository.getPopularTv();
  }
}