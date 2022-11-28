

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/pages/top_rated_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/pages/page_tv_test_helper.dart';

void main() {
  late FakeTopRatedTvBloc fakeTopRatedTvBloc;

  setUp(() {
    fakeTopRatedTvBloc = FakeTopRatedTvBloc();
    registerFallbackValue(FakeTopRatedTvEvent());
    registerFallbackValue(FakeTopRatedTvState());
  });

  Widget _makeTestAbleWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>(
      create:(context) => fakeTopRatedTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (widgetTester) async {
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester.pumpWidget(_makeTestAbleWidget(TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });


  testWidgets('Page should display ListView when data is loaded', (widgetTester) async{
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvHasData(testTvList));

    final listViewFinder = find.byType(ListView);

    await widgetTester.pumpWidget(_makeTestAbleWidget(TopRatedTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (widgetTester) async{
    when(() => fakeTopRatedTvBloc.state).thenReturn(TopRatedTvError("error"));

    final textFinder = find.byKey(Key("error"));
    await widgetTester.pumpWidget(_makeTestAbleWidget(TopRatedTvPage()));
    expect(textFinder, findsOneWidget);
  });
}