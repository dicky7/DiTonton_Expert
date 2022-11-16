import '../repositories/tv_repository.dart';

class GetWatchListStatusTv{
  final TvRepository repository;

  GetWatchListStatusTv(this.repository);
  Future<bool> execute(int id) async{
    return repository.isAddedToWatchList(id);
  }
}