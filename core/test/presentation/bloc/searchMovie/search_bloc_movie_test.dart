import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecase/search_movies.dart';
import 'package:core/presentation/bloc/searchMovie/search_bloc_movie.dart';
import 'package:core/presentation/bloc/searchMovie/search_event_movie.dart';
import 'package:core/presentation/bloc/searchMovie/search_state_movie.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_bloc_movie_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late SearchBlocMovie searchBloc;
  late MockSearchMovies mockSearchMovies;
  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchBloc = SearchBlocMovie(mockSearchMovies);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchMovieEmpty());
  });

  final tQuery = 'spiderman';
  blocTest<SearchBlocMovie, SearchStateMovie>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(testMovieList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: Duration(milliseconds: 500),
    expect: () => [SearchMovieLoading(), SearchMovieHasData(testMovieList)],
    verify: (bloc) => verify(mockSearchMovies.execute(tQuery)),
  );

  blocTest<SearchBlocMovie, SearchStateMovie>(
   'Should emit [Loading, Error] when get search is unsuccessful',
   build: () {
     when(mockSearchMovies.execute(tQuery)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
     return searchBloc;

   },
   act:(bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: Duration(milliseconds: 500),
   expect: () => [
     SearchMovieLoading(),
     SearchMovieError('Server Failure'),
   ],
   verify: (bloc) {
     verify(mockSearchMovies.execute(tQuery));
   },
  );


}
