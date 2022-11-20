import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class SearchTv{
  final TvRepository repository;
  SearchTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute(String query){
    return repository.searchTv(query);
  }
}