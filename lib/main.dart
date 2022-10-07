import "package:bytepass/ui/pages/login.dart";
import "package:flutter/material.dart";
import "package:flutter_locales/flutter_locales.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(["en"]);

  runApp(const App());
}

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        title: "BytePass",
        themeMode: ThemeMode.system,
        theme: ThemeClass.lightTheme,
        darkTheme: ThemeClass.darkTheme,
        home: const LoginScreen(),
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
      ),
    );
  }
}
