import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

import '../../../domain/usecase/search_tv.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTv _searchTv;

  SearchTvBloc(this._searchTv) : super(SearchTvEmpty()) {
    on<OnQueryTvChanged>((event, emit) async {
      final query = event.query;

      emit(SearchTvLoading());
      final result = await _searchTv.execute(query);

      result.fold(
              (failure) => emit(SearchTvError(failure.message)),
              (data) {
                data.isEmpty
                    ? emit(SearchTvEmpty())
                    : emit(SearchTvHasData(data));

          });
    }, transformer: debounce(Duration(milliseconds: 500)));
  }
}
