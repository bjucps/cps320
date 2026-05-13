import 'package:arts_and_culture/api/api_service.dart';

class Pamphlet {
  final String title;
  final String subtitle;
  final String institution;
  final String division;
  final String director;
  final String location;
  final String date;
  final List<Map<String, dynamic>> programContent;
  final String contributors;
  final String donorTitle;
  final String donorText;
  final String donorLink;
  final String upcomingEvents;
  final String missionStatement;

  Pamphlet({
    required this.title,
    required this.subtitle,
    required this.institution,
    required this.division,
    required this.director,
    required this.location,
    required this.date,
    required this.programContent,
    required this.contributors,
    required this.donorTitle,
    required this.donorText,
    required this.donorLink,
    required this.upcomingEvents,
    required this.missionStatement,
  });

  factory Pamphlet.fromJson(Map<String, dynamic> json) {
    return Pamphlet(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      institution: json['institution'] ?? '',
      division: json['division'] ?? '',
      director: json['director'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      programContent: (json['program_content'] is List)
          ? List<Map<String, dynamic>>.from(json['program_content'])
          : [],
      contributors: json['contributors'] ?? '',
      donorTitle: json['donor_title'] ?? '',
      donorText: json['donor_text'] ?? '',
      donorLink: json['donor_link'] ?? '',
      upcomingEvents: json['upcoming_events'] ?? '',
      missionStatement: json['mission_statement'] ?? '',
    );
  }
}

Future<Pamphlet> getPamphlet(int pamphletId) async {
  final apiService = ApiService();
  final rawPamphlet = await apiService.getPamphlet(pamphletId);

  return Pamphlet.fromJson(rawPamphlet as Map<String, dynamic>);
}
