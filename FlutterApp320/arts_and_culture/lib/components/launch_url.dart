import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

Future<void> launchURL(String url) async {
  Uri uri = Uri.parse(url);
  await launchUrl(
    uri,
    customTabsOptions: CustomTabsOptions(
      browser: CustomTabsBrowserConfiguration(
        prefersDefaultBrowser: true,
      ),
    ),
    safariVCOptions: SafariViewControllerOptions(
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.cancel,
    ),
  );
}