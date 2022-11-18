
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'top_rated_tv_page_dart.mocks.dart';

@GenerateMocks([TopRatedTvNotifier])
void main() {
  late MockTopRatedTvNotifier mockTopRatedTvNotifier;

  setUp(() {
    mockTopRatedTvNotifier = MockTopRatedTvNotifier();
  });

  Widget _makeTestAbleWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTvNotifier>.value(
      value: mockTopRatedTvNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (widgetTester) async {
    when(mockTopRatedTvNotifier.state).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester.pumpWidget(_makeTestAbleWidget(TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });


  testWidgets('Page should display ListView when data is loaded', (widgetTester) async{
    when(mockTopRatedTvNotifier.state).thenReturn(RequestState.Loaded);
    when(mockTopRatedTvNotifier.tvShow).thenReturn(<Tv>[]);

    final listViewFinder = find.byType(ListView);

    await widgetTester.pumpWidget(_makeTestAbleWidget(TopRatedTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (widgetTester) async{
    when(mockTopRatedTvNotifier.state).thenReturn(RequestState.Error);
    when(mockTopRatedTvNotifier.message).thenReturn("Error message");

    final textFinder = find.byKey(Key("error_message"));

    await widgetTester.pumpWidget(_makeTestAbleWidget(TopRatedTvPage()));
    expect(textFinder, findsOneWidget);
  });
}