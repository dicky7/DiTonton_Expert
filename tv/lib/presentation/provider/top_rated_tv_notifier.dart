import 'package:core/utils/state_enum.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecase/get_popular_tv.dart';
import '../../domain/usecase/get_top_rated_tv.dart';

class TopRatedTvNotifier extends ChangeNotifier{
  final GetTopRatedTv getTopRatedTv;
  TopRatedTvNotifier(this.getTopRatedTv);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tvShows = [];
  List<Tv> get tvShow => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTv() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _state = RequestState.Loaded;
        _tvShows = tvData;
        notifyListeners();
      },
    );
  }
}