import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetWatchListTv{
  final TvRepository repository;

  GetWatchListTv(this.repository);
  Future<Either<Failure, List<Tv>>> execute(){
    return repository.getWatchListTv();
  }
}