import 'package:core/presentation/widgets/item_card_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/pages/page_test_helper.dart';

void main() {
  late FakeWatchlistMovieBloc fakeWatchlistMovieBloc;

  setUp(() {
    fakeWatchlistMovieBloc = FakeWatchlistMovieBloc();
    registerFallbackValue(FakeWatchlistMovieEvent());
    registerFallbackValue(FakeWatchlistMovieState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>(
      create: (_) => fakeWatchlistMovieBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() {
    fakeWatchlistMovieBloc.close();
  });

  testWidgets('page should display circular progress indicator when state is Loading',
      (WidgetTester tester) async {
    when(() => fakeWatchlistMovieBloc.state).thenReturn(WatchlistMovieLoading());
    final circularProgressIndicatorFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('Page should display listView & itemCard when state is Has Data',
      (WidgetTester tester) async {
    when(() => fakeWatchlistMovieBloc.state).thenReturn(WatchlistMovieHasData(testMovieList));
    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsOneWidget);
    expect(find.byKey(const Key("watchlist_movie_content")), findsOneWidget);
  });

  testWidgets('should display text with message when state is Error',
      (WidgetTester tester) async {
    when(() => fakeWatchlistMovieBloc.state).thenReturn(WatchlistMovieError("error"));

    final textMessageKeyFinder = find.byKey(const Key('error'));
    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });

  testWidgets('should display text with message when state is Empty',
      (WidgetTester tester) async {
    when(() => fakeWatchlistMovieBloc.state).thenReturn(WatchlistMovieEmpty());

    final textMessageKeyFinder = find.byKey(const Key("movie_watchlist_empty"));
    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
