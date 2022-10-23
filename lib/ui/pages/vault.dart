import 'package:bytepass/api/user.dart';
import 'package:bytepass/storage.dart';
import 'package:bytepass/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  bool loadingStuff = true;

  String email = '';

  @override
  initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    final storageEmail = await Storage.read(StorageKey.email);
    final accessToken = await Storage.read(StorageKey.accessToken);

    if (storageEmail == null || accessToken == null) {
      if (mounted) NavigatorPage.login(context);

      return;
    }

    try {
      await UserApi.whoami(accessToken);
    } catch (error) {
      if (!mounted) return;

      Utils.showSnackBar(
        context,
        content: error.toString(),
      );

      // navigate to login page
      NavigatorPage.login(context);
    }

    setState(() {
      loadingStuff = false;
      email = storageEmail;
    });
  }

  Future _handleLogout() async {
    await Storage.deleteAll();

    if (mounted) NavigatorPage.login(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Vault'),
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => NavigatorPage.vaultAddItem(context),
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
