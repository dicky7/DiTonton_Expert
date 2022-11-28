import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv_on_air/tv_on_air_bloc.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/pages/page_tv_test_helper.dart';

void main() {
  late FakeTvOnAirBloc fakeTvOnAirBloc;
  late FakeTopRatedTvBloc fakeTopRatedTvBloc;
  late FakePopularTvBloc fakePopularTvBloc;

  setUp(() {
    fakeTvOnAirBloc = FakeTvOnAirBloc();
    registerFallbackValue(FakeTvOnAirEvent());
    registerFallbackValue(FakeTvOnAirState());

    fakeTopRatedTvBloc = FakeTopRatedTvBloc();
    registerFallbackValue(FakeTopRatedTvEvent());
    registerFallbackValue(FakeTopRatedTvState());

    fakePopularTvBloc = FakePopularTvBloc();
    registerFallbackValue(FakePopularTvEvent());
    registerFallbackValue(FakePopularTvState());

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() {
    fakeTvOnAirBloc.close();
    fakeTopRatedTvBloc.close();
    fakePopularTvBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvOnAirBloc>(
          create: (context) => fakeTvOnAirBloc,
        ),
        BlocProvider<TopRatedTvBloc>(
          create: (context) => fakeTopRatedTvBloc,
        ),
        BlocProvider<PopularTvBloc>(
          create: (context) => fakePopularTvBloc,
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
    when(() => fakeTvOnAirBloc.state).thenReturn(TvOnAirLoading());
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('Page should display listView when state is Has Data',
      (widgetTester) async {
    when(() => fakeTvOnAirBloc.state).thenReturn(TvOnAirHasData(testTvList));
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvHasData(testTvList));
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvHasData(testTvList));


    final listViewFinder = find.byType(ListView);
    final coverKeyFinder = find.byKey(Key("tv_cover"));
    final listKeyFinder = find.byKey(Key("list_tv"));

    await widgetTester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(listViewFinder, findsNWidgets(3));
    expect(coverKeyFinder, findsOneWidget);
    expect(listKeyFinder, findsNWidgets(3));
  });

  testWidgets('page should display error with text when state is Error',
      (WidgetTester tester) async {
    when(() => fakeTvOnAirBloc.state).thenReturn(TvOnAirError('error'));
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvError('error'));
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvError('error'));

    final errorKeyFinder = find.byKey(const Key('error'));

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    expect(errorKeyFinder, findsNWidgets(3));
  });

  testWidgets('page should display empty text with text when state is Empty',
      (WidgetTester tester) async {
    when(() => fakeTvOnAirBloc.state).thenReturn(TvOnAirEmpty());
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvEmpty());
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvEmpty());

    final errorKeyFinder = find.byKey(const Key('empty'));

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    expect(errorKeyFinder, findsNWidgets(3));
  });


}
