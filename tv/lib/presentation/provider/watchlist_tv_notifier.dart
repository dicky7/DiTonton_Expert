import 'package:core/utils/state_enum.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecase/get_watchlist_tv.dart';

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