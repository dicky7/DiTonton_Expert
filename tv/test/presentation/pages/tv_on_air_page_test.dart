import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv/tv_on_air_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_on_air_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'tv/tv_on_air_page_test.mocks.dart';

@GenerateMocks([TvOnAirNotifier])
void main(){
  late MockTvOnAirNotifier mockTvOnAirNotifier;

  setUp((){
    mockTvOnAirNotifier = MockTvOnAirNotifier();
  });

  Widget _makeTestAbleWidget(Widget body){
    return ChangeNotifierProvider<TvOnAirNotifier>.value(
      value: mockTvOnAirNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (widgetTester) async{
    when(mockTvOnAirNotifier.tvOnTheAirState).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester.pumpWidget(_makeTestAbleWidget(TvOnTheAirPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (widgetTester) async{
    when(mockTvOnAirNotifier.tvOnTheAirState).thenReturn(RequestState.Loaded);
    when(mockTvOnAirNotifier.tvOnTheAir).thenReturn(<Tv>[]);

    final listViewFinder = find.byType(ListView);

    await widgetTester.pumpWidget(_makeTestAbleWidget(TvOnTheAirPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (widgetTester) async{
    when(mockTvOnAirNotifier.tvOnTheAirState).thenReturn(RequestState.Error);
    when(mockTvOnAirNotifier.message).thenReturn("Error message");

    final textFinder = find.byKey(Key("error_message"));

    await widgetTester.pumpWidget(_makeTestAbleWidget(TvOnTheAirPage()));
    expect(textFinder, findsOneWidget);
  });
}