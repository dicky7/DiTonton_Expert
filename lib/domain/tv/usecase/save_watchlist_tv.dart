import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/tv/entities/tv_detail.dart';

import '../../../common/failure.dart';
import '../repositories/tv_repository.dart';

class SaveWatchListTv{
  final TvRepository repository;

  SaveWatchListTv(this.repository);
  Future<Either<Failure, String>> execute(TvDetail tvDetail){
    return repository.saveWatchListTv(tvDetail);
  }
}