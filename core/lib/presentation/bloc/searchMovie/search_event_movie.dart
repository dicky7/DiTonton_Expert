import 'package:equatable/equatable.dart';

abstract class SearchEventMovie extends Equatable{
  const SearchEventMovie();

  @override
  List<Object?> get props => [];
}

class OnQueryChanged extends SearchEventMovie{
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object?> get props => [query];

}