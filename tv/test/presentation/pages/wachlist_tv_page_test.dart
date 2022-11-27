import 'package:core/presentation/widgets/item_card_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/watclist_tv/watchlist_tv_bloc.dart';
import 'package:tv/presentation/pages/wachlist_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/pages/page_tv_test_helper.dart';


void main() {
  late FakeWatchlistTvBloc fakeWatchlistTvBloc;

  setUp(() {
    fakeWatchlistTvBloc = FakeWatchlistTvBloc();
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvBloc>(
      create: (_) => fakeWatchlistTvBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  tearDown(() {
    fakeWatchlistTvBloc.close();
  });

  testWidgets('page should display circular progress indicator when state is Loading',
      (WidgetTester tester) async {
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());
    final circularProgressIndicatorFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('Page should display listView & itemCard when state is Has Data',
      (WidgetTester tester) async {
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvHasData(testTvList));
    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ItemCard), findsOneWidget);
    expect(find.byKey(const Key("watchlist_tv_content")), findsOneWidget);
  });

  testWidgets('should display text with message when state is Error',
      (WidgetTester tester) async {
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvError("error"));

    final textMessageKeyFinder = find.byKey(const Key('error'));
    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });

  testWidgets('should display text with message when state is Empty',
      (WidgetTester tester) async {
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvEmpty());

    final textMessageKeyFinder = find.byKey(const Key("empty"));
    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
