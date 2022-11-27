
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/pages/page_tv_test_helper.dart';


void main(){
  late FakePopularTvBloc fakePopularTvBloc;

  setUp((){
    fakePopularTvBloc = FakePopularTvBloc();
    registerFallbackValue(FakePopularTvEvent());
    registerFallbackValue(FakePopularTvState());
  });

  Widget _makeTestAbleWidget(Widget body){
    return BlocProvider<PopularTvBloc>(
      create: (context) => fakePopularTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakePopularTvBloc.close();
  });

  testWidgets('Page should display center progress bar when loading', (widgetTester) async{
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester.pumpWidget(_makeTestAbleWidget(PopularTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (widgetTester) async{
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvHasData(testTvList));

    final listViewFinder = find.byType(ListView);
    await widgetTester.pumpWidget(_makeTestAbleWidget(PopularTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (widgetTester) async{
    when(() => fakePopularTvBloc.state).thenReturn(PopularTvError("error"));

    final textFinder = find.byKey(Key("error"));

    await widgetTester.pumpWidget(_makeTestAbleWidget(PopularTvPage()));
    expect(textFinder, findsOneWidget);
  });
}