import 'package:arts_and_culture/api/api_service.dart';
import 'package:intl/intl.dart';

class Event {
  final String eventId;
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final List<int> eventPamphlets;
  final bool muRequired;
  final bool useUploadedPamphlet;
  final int? uploadedPamphlet;
  final DateTime? updatedAt;
  bool isRecentlyUpdated;

  Event({
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.eventPamphlets,
    required this.muRequired,
    required this.useUploadedPamphlet,
    this.uploadedPamphlet,
    this.updatedAt,
    this.isRecentlyUpdated = false,
  });

  DateTime get date {
    final dt = DateTime.parse(eventDate);
    return DateTime(dt.year, dt.month, dt.day); // normalize to midnight
  }

  DateTime get dateTime {
    final datePart = DateTime.parse(eventDate);

    try {
      final timePart = DateFormat("HH:mm:ss").parse(eventTime);

      return DateTime(
        datePart.year,
        datePart.month,
        datePart.day,
        timePart.hour,
        timePart.minute,
        timePart.second,
      );
    } catch (_) {
      // fallback: date only if time is invalid
      return DateTime(datePart.year, datePart.month, datePart.day);
    }
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'] ?? "",
      eventName: json['event_name'] ?? "",
      eventDate: json['event_date'] ?? "",
      eventTime: json['event_time'] ?? "",
      eventLocation: json['event_location'] ?? "",
      eventPamphlets: (json['pamphlets'] is List)
          ? (json['pamphlets'] as List).whereType<int>().toList()
          : [],
      muRequired: json['mu_required'] ?? false,
      useUploadedPamphlet: json['use_uploaded_pamphlet'] ?? false,
      uploadedPamphlet:
          (json['use_uploaded_pamphlet'] ?? false) &&
              json['uploaded_pamphlet'] is int
          ? json['uploaded_pamphlet']
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
      isRecentlyUpdated: json['is_recently_updated'] ?? false,
    );
  }

  Map<String, dynamic> get toJson => {
    'event_id': eventId,
    'event_name': eventName,
    'event_date': eventDate,
    'event_time': eventTime,
    'event_location': eventLocation,
    'event_pamphlets': eventPamphlets,
    'mu_required': muRequired,
    'use_uploaded_pamphlet': useUploadedPamphlet,
    'uploaded_pamphlet': uploadedPamphlet,
    'updated_at': updatedAt?.toIso8601String(),
    'is_recently_updated': isRecentlyUpdated,
  };
}

Future<List<Event>> getEventsList(int? month, int? year) async {
  final apiService = ApiService();
  final rawEvents = await apiService.getEvents(month, year);

  final events = rawEvents
      .map((e) => Event.fromJson(e as Map<String, dynamic>))
      .toList();

  events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  return events;
}

Future<Event> getEventDetails(String eventId) async {
  final apiService = ApiService();
  final rawEvent = await apiService.getEvent(eventId);

  return Event.fromJson(rawEvent as Map<String, dynamic>);
}