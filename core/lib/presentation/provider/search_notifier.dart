
import 'package:flutter/foundation.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:tv/domain/entities/tv.dart';

import '../../domain/usecase/search_movies.dart';
import '../../domain/usecase/search_tv.dart';
import '../../utils/state_enum.dart';

class SearchNotifier extends ChangeNotifier {
  final SearchMovies searchMovies;
  final SearchTv searchTv;

  SearchNotifier({required this.searchMovies, required this.searchTv});

  List<Movie> _movieSearchResult = [];
  List<Movie> get movieSearchResult => _movieSearchResult;

  List<Tv> _tvSearchResult = [];
  List<Tv> get tvSearchResult => _tvSearchResult;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  void resetData() {
    _state = RequestState.Empty;
    _movieSearchResult = [];
    _tvSearchResult = [];
    notifyListeners();
  }

  Future<void> fetchMovieSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchMovies.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _movieSearchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTv.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _tvSearchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
