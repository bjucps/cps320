import 'dart:async';
import 'package:flutter/material.dart';
import 'package:arts_and_culture/api/api_service.dart';
import 'package:arts_and_culture/api/announcement.dart';
import 'package:arts_and_culture/constants.dart';

class AnnouncementBanner extends StatefulWidget {
  const AnnouncementBanner({super.key});

  @override
  State<AnnouncementBanner> createState() => AnnouncementBannerState();
}

class AnnouncementBannerState extends State<AnnouncementBanner> {
  final ApiService _apiService = ApiService();
  List<AnnouncementData> _announcements = [];
  bool _isLoading = true;
  
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await _apiService.getCurrentAnnouncements();
    if (mounted) {
      setState(() {
        _announcements = data;
        _isLoading = false;
        _currentIndex = 0;
      });
      // if there are multiple announcements, start the timer to rotate them every 5 seconds
      if (_announcements.length > 1) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _announcements.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // show a bottom sheet with all announcements when the user taps the dropdown icon
  void _showAllNotifications() {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Icon(Icons.notifications_active, color: scheme.onSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'All Notifications',
                      style: textTheme.titleLarge?.copyWith(
                            color: scheme.onSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
              Divider(color: scheme.onSecondary),
              Expanded(
                child: ListView.builder(
                  itemCount: _announcements.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (context, index) {
                    final item = _announcements[index];
                    final isUrgent = item.type == 'announcement';
                    return Card(
                      color: isUrgent ? brandRedAccent.withValues(alpha: 0.15) : brandDarkBlue.withValues(alpha: 0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: isUrgent ? brandRedAccent : textTheme.titleMedium!.color!.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          isUrgent ? Icons.campaign_rounded : Icons.info_outline,
                          color: isUrgent ? brandRedAccent : textTheme.titleMedium?.color,
                        ),
                        title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, color: textTheme.titleMedium?.color)),
                        subtitle: Text(item.body, style: TextStyle(color: textTheme.titleMedium?.color)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _announcements.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentData = _announcements[_currentIndex];
    final isUrgent = currentData.type == 'announcement';
    final bgColor = isUrgent ? brandRedAccent : brandDarkBlue;
    final icon = isUrgent ? Icons.campaign_rounded : Icons.info_outline;

    return Container(
      width: double.infinity,
      color: bgColor.withValues(alpha: 0.95),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(icon, key: ValueKey(icon), color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(currentData.id), // Key tells Flutter to do the animation when the announcement changes
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentData.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentData.body,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              // if more than 1 announcement, show a dropdown icon
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 28),
                  onPressed: _showAllNotifications,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
