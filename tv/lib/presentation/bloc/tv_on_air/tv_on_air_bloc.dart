import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecase/get_tv_on_the_air.dart';

part 'tv_on_air_event.dart';
part 'tv_on_air_state.dart';

class TvOnAirBloc extends Bloc<TvOnAirEvent, TvOnAirState> {
  final GetTvOnTheAir _getTvOnAir;

  TvOnAirBloc(this._getTvOnAir) : super(TvOnAirEmpty()) {
    on<FetchTvOnAir>((event, emit) async {
      emit(TvOnAirLoading());
      final result = await _getTvOnAir.execute();

      result.fold(
        (failure) => emit(TvOnAirError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(TvOnAirLoading());
          }else{
            emit(TvOnAirHasData(data));
          }
        },
      );
    });
  }
}
