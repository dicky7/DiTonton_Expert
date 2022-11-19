import 'package:ditonton/domain/tv/usecase/get_tv_on_the_air.dart';
import 'package:flutter/cupertino.dart';

import '../../../common/state_enum.dart';
import '../../../domain/tv/entities/tv.dart';

class TvOnAirNotifier extends ChangeNotifier{
  final GetTvOnTheAir getTvOnTheAir;

  TvOnAirNotifier({required this.getTvOnTheAir});

  var _tvOnTheAir = <Tv>[];
  List<Tv> get tvOnTheAir => _tvOnTheAir;

  RequestState _tvOnTheAirState = RequestState.Empty;
  RequestState get tvOnTheAirState => _tvOnTheAirState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvOnTheAir() async{
    _tvOnTheAirState = RequestState.Loading;
    notifyListeners();
    final result = await getTvOnTheAir.execute();
    result.fold(
          (failure) {
        _tvOnTheAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvData) {
        _tvOnTheAirState = RequestState.Loaded;
        _tvOnTheAir = tvData;
        notifyListeners();
      },
    );
  }
}