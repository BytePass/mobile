import 'package:bytepass/api.dart';
import 'package:bytepass/storage.dart';
import 'package:bytepass/ui/pages/login.dart';
import 'package:bytepass/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool loadingStuff = true;

  String email = '';

  @override
  initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    final storageEmail = await Storage.read(key: StorageKey.email);
    final accessToken = await Storage.read(key: StorageKey.accessToken);

    if (storageEmail == null || accessToken == null) {
      return goToLoginPage();
    }

    try {
      final response = await APIClient.whoami(accessToken);

      if (!response.success) {
        if (!mounted) return;

        Utils.showSnackBar(
          context,
          content: response.error.toString(),
        );

        return goToLoginPage();
      }
    } catch (error) {
      if (!mounted) return;

      Utils.showSnackBar(
        context,
        content: error.toString(),
      );
    }

    setState(() {
      loadingStuff = false;
      email = storageEmail;
    });
  }

  goToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future _handleLogout() async {
    await Storage.deleteAll();

    goToLoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: loadingStuff
              ? <Widget>[const Center(child: CircularProgressIndicator())]
              : <Widget>[
                  Center(
                    child: Text(
                      'Hello $email',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Log out button
                  ElevatedButton(
                    onPressed: _handleLogout,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    ),
                    child: Text(
                      context.localeString('logout_button'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
