import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:tv/presentation/bloc/watclist_tv/watchlist_tv_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/pages/page_tv_test_helper.dart';

void main() {
  late FakeTvDetailBloc fakeTvDetailBloc;
  late FakeTvRecommendationBloc fakeTvRecommendationBloc;
  late FakeWatchlistTvBloc fakeWatchlistTvBloc;

  setUp(() {
    fakeTvDetailBloc = FakeTvDetailBloc();
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());

    fakeTvRecommendationBloc = FakeTvRecommendationBloc();
    registerFallbackValue(FakeTvRecommendationEvent());
    registerFallbackValue(FakeTvRecommendationState());

    fakeWatchlistTvBloc = FakeWatchlistTvBloc();
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        BlocProvider<TvDetailBloc>(
          create: (context) => fakeTvDetailBloc,
        ),
        BlocProvider<TvRecommendationBloc>(
          create: (context) => fakeTvRecommendationBloc,
        ),
        BlocProvider<WatchlistTvBloc>(
          create: (context) => fakeWatchlistTvBloc,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  final tId = 1;
  testWidgets('Page should display progress bar when state is loading',
      (widgetTester) async {
    when(() => fakeTvDetailBloc.state).thenReturn(TvDetailLoading());
    when(() => fakeTvRecommendationBloc.state)
        .thenReturn(TvRecommendationLoading());
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await widgetTester.pumpWidget(_makeTestableWidget(TvDetailPage(id: tId)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display content detail & widget when state is Has Data',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeTvRecommendationBloc.state)
        .thenReturn(TvRecommendationHasData(testTvList));
    when(() => fakeWatchlistTvBloc.state)
        .thenReturn(WatchlistTvHasData(testTvList));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: tId)));

    expect(find.text("Watchlist"), findsOneWidget);
    expect(find.text("Overview"), findsOneWidget);
    expect(find.byType(ListView), findsNWidgets(2));
    expect(find.byKey(const Key('content_tv_detail')), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state).thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeTvRecommendationBloc.state).thenReturn(TvRecommendationHasData(testTvList));
    when(() => fakeWatchlistTvBloc.state).thenReturn(TvIsAddedToWatchlist(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeTvRecommendationBloc.state)
        .thenReturn(TvRecommendationHasData(testTvList));
    when(() => fakeWatchlistTvBloc.state)
        .thenReturn(TvIsAddedToWatchlist(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('when tv add to watchlist should display snackbar',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state).thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeTvRecommendationBloc.state).thenReturn(TvRecommendationHasData(testTvList));
    when(() => fakeWatchlistTvBloc.state).thenReturn(TvIsAddedToWatchlist(true));
    when(() => fakeWatchlistTvBloc.state).thenReturn(WatchlistTvMessage('Added to Watchlist'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: tId)));
    await tester.pump();
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
}
