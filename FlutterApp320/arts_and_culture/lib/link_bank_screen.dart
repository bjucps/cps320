import 'package:arts_and_culture/constants.dart';
import 'package:flutter/material.dart';
import 'package:arts_and_culture/components/launch_url.dart';

class LinkBankScreen extends StatelessWidget {
  const LinkBankScreen({super.key});

  Widget _linkButton(
    BuildContext context,
    String link,
    String text, {
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: brandDarkBlue,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: brandBrown, width: 1),
        ),
        onPressed: () => launchURL(link),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: brandDarkBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(linkBankTitle),
        backgroundColor: brandDarkBlue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: brandSandstorm,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _linkButton(
                context,
                faCommURL,
                faCommLink,
                backgroundColor: brandSandstorm,
              ),
              _linkButton(
                context,
                showpassURL,
                showpassLink,
                backgroundColor: brandSandstorm,
              ),
              _linkButton(
                context,
                giveURL,
                giveLink,
                backgroundColor: brandSandstorm,
              ),
              _linkButton(
                context,
                visitURL,
                visitLink,
                backgroundColor: brandSandstorm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
