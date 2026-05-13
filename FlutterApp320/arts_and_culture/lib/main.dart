import 'package:arts_and_culture/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await authProvider.checkAuthStatus();
  } catch (e) {
    debugPrint("$startupAuthErrMsg: $e");
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ArtsAndCulture());
}

class ArtsAndCulture extends StatelessWidget {
  const ArtsAndCulture({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // enable debugger temporarily before releases to check accessibility
      showSemanticsDebugger: false,
      routerConfig: appRouter,
      title: title,
      debugShowCheckedModeBanner: false,
      theme: appLightTheme,
      darkTheme: appDarkTheme,
    );
  }
}
