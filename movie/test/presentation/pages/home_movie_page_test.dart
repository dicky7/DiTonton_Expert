import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movie/now_playing_movie_state.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_state.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/pages/page_test_helper.dart';

void main() {
  late FakeNowPlayingMovieBloc fakeNowPlayingMovieBloc;
  late FakeTopRatedMovieBloc fakeTopRatedMovieBloc;
  late FakePopularMovieBloc fakePopularMovieBloc;

  setUp(() {
    fakeNowPlayingMovieBloc = FakeNowPlayingMovieBloc();
    registerFallbackValue(FakeNowPlayingMovieEvent());
    registerFallbackValue(FakeNowPlayingMovieState());

    fakeTopRatedMovieBloc = FakeTopRatedMovieBloc();
    registerFallbackValue(FakeTopRatedMovieEvent());
    registerFallbackValue(FakeTopRatedMovieState());

    fakePopularMovieBloc = FakePopularMovieBloc();
    registerFallbackValue(FakePopularMovieEvent());
    registerFallbackValue(FakePopularMovieState());

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() {
    fakeNowPlayingMovieBloc.close();
    fakeTopRatedMovieBloc.close();
    fakePopularMovieBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMovieBloc>(
          create: (context) => fakeNowPlayingMovieBloc,
        ),
        BlocProvider<TopRatedMovieBloc>(
          create: (context) => fakeTopRatedMovieBloc,
        ),
        BlocProvider<PopularMovieBloc>(
          create: (context) => fakePopularMovieBloc,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('Page should display progress bar when state is loading',
      (widgetTester) async {
    when(() => fakeNowPlayingMovieBloc.state).thenReturn(NowPlayingMovieLoading());
    when(() => fakeTopRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());
    when(() => fakePopularMovieBloc.state).thenReturn(PopularMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('Page should display listView when state is Has Data',
      (widgetTester) async {
    when(() => fakeNowPlayingMovieBloc.state).thenReturn(NowPlayingMovieHasData(testMovieList));
    when(() => fakeTopRatedMovieBloc.state).thenReturn(TopRatedMovieHasData(testMovieList));
    when(() => fakePopularMovieBloc.state).thenReturn(PopularMovieHasData(testMovieList));

    final listViewFinder = find.byType(ListView);

    await widgetTester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(listViewFinder, findsWidgets);
  });


  testWidgets('page should display error with text when state is Error',
      (WidgetTester tester) async {
    when(() => fakeNowPlayingMovieBloc.state).thenReturn(NowPlayingMovieError('error'));
    when(() => fakePopularMovieBloc.state).thenReturn(PopularMovieError('error'));
    when(() => fakeTopRatedMovieBloc.state).thenReturn(TopRatedMovieError('error'));

    final errorKeyFinder = find.byKey(const Key('error'));

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    expect(errorKeyFinder, findsNWidgets(3));
  });

  testWidgets('page should display text when State is Empty',
      (WidgetTester tester) async {
    when(() => fakeNowPlayingMovieBloc.state).thenReturn(NowPlayingMovieEmpty());
    when(() => fakePopularMovieBloc.state).thenReturn(PopularMovieEmpty());
    when(() => fakeTopRatedMovieBloc.state).thenReturn(TopRatedMovieEmpty());

    final emptyKeyFinder = find.byKey(const Key('empty'));

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    expect(emptyKeyFinder, findsWidgets);
  });
}
