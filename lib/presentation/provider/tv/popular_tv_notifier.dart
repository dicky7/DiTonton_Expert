import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:flutter/cupertino.dart';

import '../../../common/state_enum.dart';
import '../../../domain/tv/usecase/get_popular_tv.dart';

class PopularTvNotifier extends ChangeNotifier{
  final GetPopularTv getPopularTv;

  PopularTvNotifier(this.getPopularTv);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tvShows = [];
  List<Tv> get movies => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTv() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTv.execute();

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