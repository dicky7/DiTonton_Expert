
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:tv/presentation/provider/popular_tv_notifier.dart';

import 'popular_tv_page_test.mocks.dart';



@GenerateMocks([PopularTvNotifier])
void main(){
  late MockPopularTvNotifier mockPopularTvNotifier;

  setUp((){
    mockPopularTvNotifier = MockPopularTvNotifier();
  });

  Widget _makeTestAbleWidget(Widget body){
    return ChangeNotifierProvider<PopularTvNotifier>.value(
      value: mockPopularTvNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (widgetTester) async{
    when(mockPopularTvNotifier.state).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester.pumpWidget(_makeTestAbleWidget(PopularTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (widgetTester) async{
    when(mockPopularTvNotifier.state).thenReturn(RequestState.Loaded);
    when(mockPopularTvNotifier.tvShow).thenReturn(<Tv>[]);

    final listViewFinder = find.byType(ListView);

    await widgetTester.pumpWidget(_makeTestAbleWidget(PopularTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (widgetTester) async{
    when(mockPopularTvNotifier.state).thenReturn(RequestState.Error);
    when(mockPopularTvNotifier.message).thenReturn("Error message");

    final textFinder = find.byKey(Key("error_message"));

    await widgetTester.pumpWidget(_makeTestAbleWidget(PopularTvPage()));
    expect(textFinder, findsOneWidget);
  });
}