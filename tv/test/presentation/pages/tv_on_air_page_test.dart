
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_on_air/tv_on_air_bloc.dart';
import 'package:tv/presentation/pages/tv_on_air_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/pages/page_tv_test_helper.dart';

void main(){
  late FakeTvOnAirBloc fakeTvOnAirBloc;

  setUp((){
    fakeTvOnAirBloc = FakeTvOnAirBloc();
    registerFallbackValue(FakeTvOnAirEvent());
    registerFallbackValue(FakeTvOnAirState());
  });

  Widget _makeTestAbleWidget(Widget body){
    return BlocProvider<TvOnAirBloc>(
      create: (context) => fakeTvOnAirBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (widgetTester) async{
    when(() => fakeTvOnAirBloc.state).thenReturn(TvOnAirLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester.pumpWidget(_makeTestAbleWidget(TvOnTheAirPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (widgetTester) async{
    when(() => fakeTvOnAirBloc.state).thenReturn(TvOnAirHasData(testTvList));

    final listViewFinder = find.byType(ListView);

    await widgetTester.pumpWidget(_makeTestAbleWidget(TvOnTheAirPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (widgetTester) async{
    when(() => fakeTvOnAirBloc.state).thenReturn(TvOnAirError("error"));

    final textFinder = find.byKey(Key("error"));

    await widgetTester.pumpWidget(_makeTestAbleWidget(TvOnTheAirPage()));
    expect(textFinder, findsOneWidget);
  });
}