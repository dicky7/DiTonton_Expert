import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/tv/entities/tv_detail.dart';

import '../repositories/tv_repository.dart';

class RemoveWatchListTv{
  final TvRepository repository;

  RemoveWatchListTv(this.repository);
  Future<Either<Failure, String>> execute(TvDetail tvDetail){
    return repository.removeWatchListTv(tvDetail);
  }
}