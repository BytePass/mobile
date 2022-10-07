import "package:bytepass/storage.dart";
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool loadingStuff = true;

  String email = "";

  @override
  initState() {
    super.initState();

    setState(() async {
      loadingStuff = false;
      email = await Storage.read(key: StorageKey.email) ?? "";
    });
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
          children: <Widget>[
            loadingStuff
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Text(
                      "Hello $email",
                      textAlign: TextAlign.center,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
