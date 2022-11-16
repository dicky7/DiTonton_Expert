import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/tv/entities/tv_detail.dart';
import 'package:ditonton/domain/tv/repositories/tv_repository.dart';

class GetTvDetail{
  final TvRepository repository;
  GetTvDetail(this.repository);


  Future<Either<Failure, TvDetail>> execute(int id){
    return repository.getTvDetail(id);
  }

}