import 'package:bytepass/api/cliphers.dart';
import 'package:bytepass/crypto/cipher.dart';
import 'package:bytepass/storage.dart';
import 'package:bytepass/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class VaultAddItemPage extends StatefulWidget {
  const VaultAddItemPage({super.key});

  @override
  State<VaultAddItemPage> createState() => _VaultAddItemPageState();
}

class _VaultAddItemPageState extends State<VaultAddItemPage> {
  final _formKey = GlobalKey<FormState>();

  bool loadingStuff = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  Future<void> _handleInsert() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          loadingStuff = true;
        });

        final cipherData = CipherData(
          type: CipherType.account,
          name: nameController.text,
          username: usernameController.text,
          password: passwordController.text,
        );

        final secretKey = await Storage.read(StorageKey.aesSecretKey);

        final cipherText = await cipherData.encrypt(secretKey: secretKey!);

        final accessToken = await Storage.read(StorageKey.accessToken);

        await CiphersApi.insert(accessToken: accessToken!, cipherText: cipherText);

        if (!mounted) return;

        Navigator.pop(context);

        Utils.showSnackBar(context, content: 'Item added successfully!');
      } catch (err) {
        setState(() {
          loadingStuff = false;
        });

        Utils.showSnackBar(context, content: 'Error: $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Item information',
                  ),

                  // Name
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The value cannot be empty';
                      }

                      return null;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: context.localeString('vault_add_item_name'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Username
                  TextFormField(
                    controller: usernameController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText:
                          context.localeString('vault_add_item_username'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Password
                  // TODO: add generator
                  TextFormField(
                    controller: passwordController,
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText:
                          context.localeString('vault_add_item_password'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Submit button
                  loadingStuff
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleInsert,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          ),
                          child: Text(
                            context.localeString('vault_add_item_button'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
