import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';

import '../../../common/failure.dart';
import '../repositories/tv_repository.dart';

class SearchTv{
  final TvRepository repository;

  SearchTv(this.repository);
  Future<Either<Failure, List<Tv>>> execute(String query){
    return repository.searchTv(query);
  }
}