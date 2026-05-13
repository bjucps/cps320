import 'dart:convert';
import 'package:arts_and_culture/auth/auth_service.dart';
import 'package:arts_and_culture/auth/guest_auth_service.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:arts_and_culture/api/announcement.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final AuthService _authService = AuthService();
  final GuestAuthService _guestService = GuestAuthService();

  Future<Map<String, String>> _headers() async {
    final token = await _authService.getAccessToken();
    if (token != null) {
      return {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    }

    final guestKey = await _guestService.getKey();
    if (guestKey != null) {
      _guestService.renewIfNeeded();
      return {'X-Guest-Key': guestKey, 'Content-Type': 'application/json'};
    }

    throw Exception('Not authenticated');
  }

  Future<Map<String, dynamic>> checkIn(String qrHash) async {
    final headers = await _headers();
    final response = await http.post(
      Uri.parse('$baseUrl/api/events/checkin/'),
      headers: headers,
      body: jsonEncode({'qr_hash': qrHash}),
    );

    final body = _decode(response);

    String msg;

    if (response.statusCode == 200) {
      return body;
    } else if (response.statusCode == 401) {
      msg =
          'Unauthorized To Register Attendance\n'
          'Note: Guests Cannot Register Attendance';
    } else {
      msg = body['message'] as String? ?? 'Unknown error';
    }

    throw Exception('Check-in failed (${response.statusCode}): $msg');
  }

  Future<List<dynamic>> getMyClasses() async {
    final headers = await _headers();
    final response = await http.get(
      Uri.parse('$baseUrl/api/my-classes/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(
        'Authentication failed. Please log in again.\n'
        'Note: Guest users cannot access event attendance',
      );
    }

    throw Exception('Failed to load classes (${response.statusCode})');
  }

  Future<List<dynamic>> getEvents(int? month, int? year) async {
    final headers = await _headers();

    final uri = Uri.parse('$baseUrl/api/events/').replace(
      queryParameters: {
        'format': 'json',
        if (month != null) 'month': month.toString(),
        if (year != null) 'year': year.toString(),
      },
    );

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Authentication failed. Please log in again.');
    }

    throw Exception('Failed to load events (${response.statusCode})');
  }

  Future<dynamic> getEvent(String eventId) async {
    final headers = await _headers();
    final response = await http.get(
      Uri.parse('$baseUrl/api/events/$eventId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Authentication failed. Please log in again.');
    }

    throw Exception('Failed to load event (${response.statusCode})');
  }

  Future<dynamic> getPamphlet(int pamphletId) async {
    // print('ApiService: fetching pamphlet $pamphletId');
    final headers = await _headers();
    final response = await http.get(
      Uri.parse('$baseUrl/api/pamphlet/$pamphletId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Authentication failed. Please log in again.');
    }

    throw Exception('Failed to load pamphlet (${response.statusCode})');
  }

  Future<Uint8List> getPamphletPdf(int pamphletId) async {
    final headers = await _headers();

    final uri = Uri.parse("$baseUrl/api/uploaded_pamphlet/$pamphletId");

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception("Failed to load PDF (${response.statusCode})");
  }

  Future<bool> toggleFavorite(String eventId) async {
    final headers = await _headers();
    final response = await http.post(
      Uri.parse('$baseUrl/api/toggle_favorite/'),
      headers: headers,
      body: jsonEncode({'eventID': eventId}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to toggle favorite");
    }

    final data = jsonDecode(response.body);

    return data['favorited'] as bool;
  }

  Future<Set<String>> getFavorites() async {
    final headers = await _headers();

    final response = await http.get(
      Uri.parse('$baseUrl/api/favorites/'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load favorites (${response.statusCode})');
    }

    final List data = jsonDecode((response.body));

    return data.map<String>((e) => e.toString()).toSet();
  }

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (e) {
      debugPrint('ApiService: could not decode response body: $e');
    }
    return {};
  }

  Future<List<AnnouncementData>> getCurrentAnnouncements() async {
    try {
      final headers = await _headers(); 
      final response = await http.get(
        Uri.parse('$baseUrl/api/announcements/current/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {

          final List<dynamic> listData = data['data'];
          return listData.map((json) => AnnouncementData.fromJson(json)).toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching announcements: $e');
    }
    return []; 
  }

  Future<void> markEventsAsRead() async {
    final headers = await _headers(); 
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/events/mark-read/'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        debugPrint("Failed to mark events as read: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error marking events as read: $e");
    }
  }
}