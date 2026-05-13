import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:arts_and_culture/auth/guest_auth_service.dart';
import 'package:arts_and_culture/components/launch_url.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:arts_and_culture/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:go_router/go_router.dart';

class GuestLoginScreen extends StatefulWidget {
  const GuestLoginScreen({super.key});

  @override
  State<GuestLoginScreen> createState() => _GuestLoginScreenState();
}

class _GuestLoginScreenState extends State<GuestLoginScreen> {
  final _guestService = GuestAuthService();
  StreamSubscription<Uri>? _linkSub;
  bool _waiting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _listenForCallback();
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  void _listenForCallback() {
    final appLinks = AppLinks();
    _linkSub = appLinks.uriLinkStream.listen(
      (uri) => _handleDeepLink(uri),
      onError: (e) => debugPrint('[GuestLogin] Deep link error: $e'),
    );
  }

  Future<void> _handleDeepLink(Uri uri) async {
    if (uri.scheme != guestDeepLinkUrl ||
        uri.host != 'guest-callback') {
      return;
    }

    await closeCustomTabs();

    final key = uri.queryParameters['key'] ?? '';
    if (key.isEmpty) {
      if (mounted) setState(() => _error = 'No key received. Please try again.');
      return;
    }

    final expiry = DateTime.now()
        .add(Duration(days: guestKeyExpiryDays))
        .toIso8601String();

    await _guestService.saveKey(key, expiry);

    authProvider.setGuest();

    if (mounted) context.go(homeScreenPath);
  }

  Future<void> _openCaptchaPage() async {
    setState(() { _waiting = true; _error = null; });

    try {
      await launchURL(GuestAuthService.guestLoginUrl());
    } catch (e) {
      debugPrint('[GuestLogin] Custom tab error: $e');
      if (mounted) {
        setState(() {
          _error   = 'Could not open the login page. Please try again.';
          _waiting = false;
        });
      }
      return;
    }

    if (mounted) setState(() => _waiting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(guestLoginTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, size: 72, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                guestLoginSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                guestLoginDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                Text(_error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
              ],
              _waiting
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text(guestLoginButtonText),
                      onPressed: _openCaptchaPage,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
