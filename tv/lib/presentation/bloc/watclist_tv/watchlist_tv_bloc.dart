import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_detail.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecase/get_watchlist_status_tv.dart';
import '../../../domain/usecase/get_watchlist_tv.dart';
import '../../../domain/usecase/remove_watchlist_tv.dart';
import '../../../domain/usecase/save_watchlist_tv.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchListTv _getWatchlistTv;
  final GetWatchListStatusTv _getWatchListStatusTv;
  final SaveWatchListTv _saveWatchListTv;
  final RemoveWatchListTv _removeWatchListTv;

  WatchlistTvBloc(this._getWatchlistTv, this._getWatchListStatusTv,
      this._saveWatchListTv, this._removeWatchListTv) : super(WatchlistTvEmpty()) {
    on<WatchlistTvList>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await _getWatchlistTv.execute();

      result.fold((failure) => emit(WatchlistTvError(failure.message)), (data) {
        if (data.isEmpty) {
          emit(WatchlistTvEmpty());
        } else {
          emit(WatchlistTvHasData(data));
        }
      });
    });

    on<WatchlistTvAdd>((event, emit) async {
      final tvDetail = event.tvDetail;

      final result = await _saveWatchListTv.execute(tvDetail);
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (success) => emit(WatchlistTvMessage(success)),
      );
    });

    on<WatchlistTvRemove>((event, emit) async {
      final tvDetail = event.tvDetail;

      final result = await _removeWatchListTv.execute(tvDetail);
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (success) => emit(WatchlistTvMessage(success)),
      );
    });

    on<WatchlistTvStatus>((event, emit) async {
      final id = event.id;

      final result = await _getWatchListStatusTv.execute(id);
      emit(TvIsAddedToWatchlist(result));
    });
  }
}
