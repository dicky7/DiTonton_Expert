import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:ditonton/domain/tv/usecase/get_watchlist_tv.dart';
import 'package:flutter/cupertino.dart';

import '../../../common/state_enum.dart';

class WatchlistTvNotifier extends ChangeNotifier{
  final GetWatchListTv getWatchListTv;
  WatchlistTvNotifier(this.getWatchListTv);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  var _watchlistTv = <Tv>[];
  List<Tv> get watchlistTv => _watchlistTv;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlistTv() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getWatchListTv.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _state = RequestState.Loaded;
        _watchlistTv = tvData;
        notifyListeners();
      },
    );
  }
}