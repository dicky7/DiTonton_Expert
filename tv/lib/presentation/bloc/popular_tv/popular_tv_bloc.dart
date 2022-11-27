import 'dart:async';


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecase/get_popular_tv.dart';

import '../../../domain/entities/tv.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;

  PopularTvBloc(this._getPopularTv) : super(PopularTvEmpty()) {
    on<FetchPopularTv>((event, emit) async{
      emit(PopularTvLoading());
      final result = await _getPopularTv.execute();

      result.fold(
        (failure) => emit(PopularTvError(failure.message)),
         (data) {
          if (data.isEmpty) {
            emit(PopularTvEmpty());
          }else{
            emit(PopularTvHasData(data));
          }
        },
      );
    });
  }
}
