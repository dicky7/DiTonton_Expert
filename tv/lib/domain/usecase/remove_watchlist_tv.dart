import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class RemoveWatchListTv{
  final TvRepository repository;

  RemoveWatchListTv(this.repository);
  Future<Either<Failure, String>> execute(TvDetail tvDetail){
    return repository.removeWatchListTv(tvDetail);
  }
}