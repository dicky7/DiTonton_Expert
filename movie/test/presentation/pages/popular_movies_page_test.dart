import 'package:core/presentation/widgets/item_card_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_state.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/pages/page_test_helper.dart';

void main() {
  late FakePopularMovieBloc fakePopularMovieBloc;

  setUpAll(() {
    fakePopularMovieBloc = FakePopularMovieBloc();
    registerFallbackValue(FakePopularMovieEvent());
    registerFallbackValue(FakePopularMovieState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieBloc>(
      create: (_) => fakePopularMovieBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() {
    fakePopularMovieBloc.close();
  });

  testWidgets('page should display circular progress indicator when state is Loading',
      (WidgetTester tester) async {
    when(() => fakePopularMovieBloc.state).thenReturn(PopularMovieLoading());

    final circularProgressIndicatorFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('Page should display listView & itemCard when state is Has Data',
      (WidgetTester tester) async {
    when(() => fakePopularMovieBloc.state).thenReturn(PopularMovieHasData(testMovieList));
    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));


    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsOneWidget);
    expect(find.byKey(const Key('popular_movies_content')), findsOneWidget);
  });

  testWidgets('should display text with message when state is Error',
      (WidgetTester tester) async {
    when(() => fakePopularMovieBloc.state).thenReturn(PopularMovieError("error"));

    final textMessageKeyFinder = find.byKey(const Key('error'));
    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
