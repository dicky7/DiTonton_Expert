import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/tv/entities/tv_detail.dart';
import 'package:ditonton/domain/tv/usecase/get_tv_detail.dart';
import 'package:ditonton/domain/tv/usecase/get_tv_recommendations.dart';
import 'package:ditonton/domain/tv/usecase/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/tv/usecase/remove_watchlist_tv.dart';
import 'package:ditonton/domain/tv/usecase/save_watchlist_tv.dart';
import 'package:flutter/cupertino.dart';

import '../../../domain/tv/entities/tv.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const tvWatchlistAddSuccessMessage = 'Added to Watchlist';
  static const tvWatchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatusTv;
  final SaveWatchListTv saveWatchListTv;
  final RemoveWatchListTv removeWatchListTv;

  TvDetailNotifier(
      {required this.getTvDetail,
      required this.getTvRecommendations,
      required this.getWatchListStatusTv,
      required this.saveWatchListTv,
      required this.removeWatchListTv});

  late TvDetail _tvDetail;
  TvDetail get tvDetail => _tvDetail;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<Tv> _tvRecommendations = [];
  List<Tv> get tvRecommendations => _tvRecommendations;

  RequestState _tvRecommendationState = RequestState.Empty;
  RequestState get tvRecommendationState => _tvRecommendationState;

  String _message = "";
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTvDetail(int id) async{
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvDetail) {
        _tvRecommendationState = RequestState.Loading;
        _tvDetail = tvDetail;
        notifyListeners();
        recommendationResult.fold(
          (failute) {
            _tvRecommendationState = RequestState.Error;
            _message = failute.message;
          },
          (tvRecommendations) {
            _tvRecommendationState = RequestState.Loaded;
            _tvRecommendations = tvRecommendations;
          },
        );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchListTv(TvDetail tvDetail) async{
    final result = await saveWatchListTv.execute(tvDetail);
    await result.fold(
      (failure) async{
        _watchlistMessage = failure.message;
      },
      (successMessage) {
        _watchlistMessage = successMessage;
      },
    );
    await tvLoadedWatchListStatus(tvDetail.id);
  }

  Future<void> removeFromWatchlistTv(TvDetail tvDetail) async {
    final result = await removeWatchListTv.execute(tvDetail);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await tvLoadedWatchListStatus(tvDetail.id);
  }

  Future<void> tvLoadedWatchListStatus(int id) async{
    final result = await getWatchListStatusTv.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
