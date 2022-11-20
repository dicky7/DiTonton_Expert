import 'package:ditonton/data/tv/model/tv_model.dart';
import 'package:equatable/equatable.dart';

class TvResponse extends Equatable{
  TvResponse({required this.tvList});

  final List<TvModel> tvList;

  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
    tvList: List<TvModel>.from((json["results"] as List)
        .map((e) => TvModel.fromJson(e))
        .where((element) => element.posterPath != null))
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(tvList.map((x) => x.toJson())),
  };

  @override
  // TODO: implement props
  List<Object?> get props => [tvList];
}