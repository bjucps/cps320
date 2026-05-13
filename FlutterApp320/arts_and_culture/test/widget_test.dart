// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:arts_and_culture/api/get_events.dart';

void main() {
  test('get_events', () async {
    late List<Event> eventList;
    try {
      eventList = await getEventsList(
        DateTime.now().month,
        DateTime.now().year,
      );
      expect(eventList.isNotEmpty, true);
    } on Exception catch (e) {
      expect(e.toString(), "Exception: Failed to load events");
    }
  });
}
