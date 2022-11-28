import 'package:core/presentation/widgets/item_card_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/pages/page_test_helper.dart';

void main() {
  late FakeTopRatedMovieBloc fakeTopRatedMovieBloc;

  setUp(() {
    fakeTopRatedMovieBloc = FakeTopRatedMovieBloc();
    registerFallbackValue(FakeTopRatedMovieEvent());
    registerFallbackValue(FakeTopRatedMovieState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMovieBloc>(
      create: (_) => fakeTopRatedMovieBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() {
    fakeTopRatedMovieBloc.close();
  });

  testWidgets('page should display circular progress indicator when state is Loading',
      (WidgetTester tester) async {
    when(() => fakeTopRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());

    final circularProgressIndicatorFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('Page should display listView & itemCard when state is Has Data',
      (WidgetTester tester) async {
    when(() => fakeTopRatedMovieBloc.state).thenReturn(TopRatedMovieHasData(testMovieList));
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsOneWidget);
    expect(find.byKey(const Key('top_rated_content')), findsOneWidget);
  });

  testWidgets('should display text with message when state is Error',
      (WidgetTester tester) async {
    when(() => fakeTopRatedMovieBloc.state).thenReturn(TopRatedMovieError("error"));

    final textMessageKeyFinder = find.byKey(const Key('error'));
    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
