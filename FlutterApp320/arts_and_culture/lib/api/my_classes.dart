import 'package:arts_and_culture/api/api_service.dart';

class ClassEventStatus {
  final String eventId;
  final String eventName;
  final String eventDate;
  final String? eventTime;
  final String eventLocation;
  final bool attended;
  final bool required;

  const ClassEventStatus({
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    this.eventTime,
    required this.eventLocation,
    required this.attended,
    required this.required,
  });

  factory ClassEventStatus.fromJson(Map<String, dynamic> json) {
    return ClassEventStatus(
      eventId: json['event_id'] as String? ?? '',
      eventName: json['event_name'] as String? ?? '',
      eventDate: json['event_date'] as String? ?? '',
      eventTime: json['event_time'] as String?,
      eventLocation: json['event_location'] as String? ?? '',
      attended: json['attended'] as bool? ?? false,
      required: json['required'] as bool? ?? true,
    );
  }
}

class StudentClass {
  final int id;
  final String title;

  final String section;
  final String semester;
  final bool isArchived;

  final String schoolYear;
  final String teacher;

  final bool hasRequired;
  final int reqAttended;
  final int reqTarget;
  final bool reqMet;

  final bool hasMinimum;
  final int minRequiredEvents;
  final int extraCount;
  final int extraTarget;
  final bool extraMet;

  final bool overallMet;

  final List<ClassEventStatus> events;

  const StudentClass({
    required this.id,
    required this.title,
    required this.section,
    required this.semester,
    required this.isArchived,
    required this.schoolYear,
    required this.teacher,
    required this.hasRequired,
    required this.reqAttended,
    required this.reqTarget,
    required this.reqMet,
    required this.hasMinimum,
    required this.minRequiredEvents,
    required this.extraCount,
    required this.extraTarget,
    required this.extraMet,
    required this.overallMet,
    required this.events,
  });

  factory StudentClass.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['events'] as List<dynamic>? ?? [];
    return StudentClass(
      id: json['id'] as int?    ?? 0,
      title: json['title'] as String? ?? '',
      section: json['section'] as String? ?? '',
      semester: json['semester'] as String? ?? 'Fall',
      isArchived: json['is_archived'] as bool? ?? false,
      schoolYear: json['school_year'] as String? ?? '',
      teacher: json['teacher'] as String? ?? '',
      hasRequired: json['has_required'] as bool? ?? false,
      reqAttended: json['req_attended'] as int?  ?? 0,
      reqTarget: json['req_target'] as int?  ?? 0,
      reqMet: json['req_met'] as bool? ?? true,
      hasMinimum: json['has_minimum'] as bool? ?? false,
      minRequiredEvents: json['min_required_events']  as int?  ?? 0,
      extraCount: json['extra_count'] as int?  ?? 0,
      extraTarget: json['extra_target'] as int?  ?? 0,
      extraMet: json['extra_met'] as bool? ?? true,
      overallMet: json['overall_met'] as bool? ?? true,
      events: eventsJson
          .map((e) => ClassEventStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  int get reqRemaining  => reqMet ? 0 : (reqTarget - reqAttended).clamp(0, reqTarget);
  int get extraRemaining => extraMet ? 0 : (extraTarget - extraCount).clamp(0, extraTarget);
}

Future<List<StudentClass>> getMyClasses() async {
  final raw = await ApiService().getMyClasses();
  return raw
      .map((e) => StudentClass.fromJson(e as Map<String, dynamic>))
      .toList();
}
