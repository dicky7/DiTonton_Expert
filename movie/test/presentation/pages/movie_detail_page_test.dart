import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/recommendation/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/pages/page_test_helper.dart';

void main() {
  late FakeMovieDetailBloc fakeMovieDetailBloc;
  late FakeMovieRecommendationBloc fakeMovieRecommendationBloc;
  late FakeWatchlistMovieBloc fakeWatchlistMovieBloc;

  setUp(() {
    fakeMovieDetailBloc = FakeMovieDetailBloc();
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());

    fakeMovieRecommendationBloc = FakeMovieRecommendationBloc();
    registerFallbackValue(FakeMovieRecommendationEvent());
    registerFallbackValue(FakeMovieRecommendationState());

    fakeWatchlistMovieBloc = FakeWatchlistMovieBloc();
    registerFallbackValue(FakeWatchlistMovieEvent());
    registerFallbackValue(FakeWatchlistMovieState());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (context) => fakeMovieDetailBloc,
        ),
        BlocProvider<MovieRecommendationBloc>(
          create: (context) => fakeMovieRecommendationBloc,
        ),
        BlocProvider<WatchlistMovieBloc>(
          create: (context) => fakeWatchlistMovieBloc,
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
    when(() => fakeMovieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(() => fakeMovieRecommendationBloc.state).thenReturn(MovieRecommendationLoading());
    when(() => fakeWatchlistMovieBloc.state).thenReturn(WatchlistMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester
        .pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Page should display content detail & widget when state is Has Data',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state).thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => fakeMovieRecommendationBloc.state).thenReturn(MovieRecommendationHasData(testMovieList));
    when(() => fakeWatchlistMovieBloc.state).thenReturn(WatchlistMovieHasData(testMovieList));
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

    expect(find.text("Watchlist"), findsOneWidget);
    expect(find.text("Overview"), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byKey(const Key('content_movie_detail')), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state).thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => fakeMovieRecommendationBloc.state).thenReturn(MovieRecommendationHasData(testMovieList));
    when(() => fakeWatchlistMovieBloc.state).thenReturn(MovieIsAddedToWatchlist(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state).thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => fakeMovieRecommendationBloc.state).thenReturn(MovieRecommendationHasData(testMovieList));
    when(() => fakeWatchlistMovieBloc.state).thenReturn(MovieIsAddedToWatchlist(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
}
