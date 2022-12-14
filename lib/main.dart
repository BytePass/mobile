import 'package:bytepass/storage.dart';
import 'package:bytepass/ui/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en']);

  final accessToken = await Storage.read(StorageKey.accessToken);

  bool loggedIn = false;

  if (accessToken != null) {
    loggedIn = true;
  }

  runApp(App(loggedIn: loggedIn));
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
  final bool loggedIn;

  const App({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        title: 'BytePass',
        themeMode: ThemeMode.system,
        theme: ThemeClass.lightTheme,
        darkTheme: ThemeClass.darkTheme,
        home: HomePage(loggedIn: loggedIn),
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
      ),
    );
  }
}
