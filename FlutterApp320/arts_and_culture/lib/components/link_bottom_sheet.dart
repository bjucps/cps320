import 'package:arts_and_culture/components/launch_url.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: brandBrown, width: 1),
      ),
      onPressed: () => launchURL(link),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: brandDarkBlue,
        ),
      ),
    ),
  );
}

Future<void> linkModalBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: brandSandstorm,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (BuildContext context) {
      return SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  linkBankTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: brandDarkBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: brandDarkBlue),
              ),
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
      );
    },
  );
}
