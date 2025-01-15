import 'package:drawee/presentation/ui/login/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class ThirdPartyPolicyLink extends StatelessWidget {
  const ThirdPartyPolicyLink({
    super.key,
    required this.strings,
  });

  final Strings strings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Google Play Services ----------------------------
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () async {
              if (await canLaunchUrl(strings.googlePlayServices)) {
                await launchUrl(strings.googlePlayServices);
              }
            },
            child: const Text('- Google Play Services'),
          ),
        ),
        // Google Analytics for Firebase ----------------------------
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
              onTap: () async {
                if (await canLaunchUrl(strings.googleAnalytics)) {
                  await launchUrl(strings.googleAnalytics);
                }
              },
              child: const Text('- Google Analytics for Firebase')),
        ),
        // Firebase Crashlytics ----------------------------
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () async {
              if (await canLaunchUrl(strings.firebaseCrashlytics)) {
                await launchUrl(strings.firebaseCrashlytics);
              }
            },
            child: const Text('- Firebase Crashlytics'),
          ),
        ),
      ],
    );
  }
}
