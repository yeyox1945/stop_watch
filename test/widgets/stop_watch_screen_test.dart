import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stop_watch/main.dart';
import 'package:stop_watch/presentation/widgets/laps_list_view.dart';

void main() {
  late Widget wut;
  const playPauseKey = Key('Play/Pause btn');
  const lapStopKey = Key('Lap/Stop btn');

  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MainApp());
  }

  setUp(() {
    wut = createWidgetUnderTest();
  });

  testWidgets('Tracked time text is displayed correctly', (widgetTester) async {
    await widgetTester.pumpWidget(wut);

    expect(find.byType(Text), findsOneWidget);
    expect(find.text('00:00.00'), findsOneWidget);
  });

  testWidgets('Play button is displayed correctly', (widgetTester) async {
    await widgetTester.pumpWidget(wut);

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Stopwatch screen is displaying and working correctly',
      (widgetTester) async {
    final playPauseButton = find.byKey(playPauseKey);
    final lapStopButton = find.byKey(lapStopKey);

    await widgetTester.pumpWidget(wut);
    await widgetTester.tap(playPauseButton);
    await widgetTester.pump();

    expect(find.byType(FloatingActionButton), findsExactly(2));
    expect(find.byKey(lapStopKey), findsOneWidget);
    expect(find.text('00:00.00'), findsNothing);

    await widgetTester.tap(lapStopButton);
    await widgetTester.pump();

    expect(find.byType(LapsListView), findsOneWidget);
    expect(find.byType(LapItem), findsOneWidget);

    await widgetTester.tap(playPauseButton);
    await widgetTester.tap(lapStopButton);
    await widgetTester.pump();

    expect(find.byType(LapsListView), findsNothing);
    expect(find.text('00:00.00'), findsAny);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
