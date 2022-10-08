import 'package:bytepass/api.dart';
import 'package:bytepass/storage.dart';
import 'package:bytepass/ui/pages/home.dart';
import 'package:bytepass/ui/pages/register.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController masterPasswordController = TextEditingController();

  bool loadingStuff = false;

  Future _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loadingStuff = true;
      });

      String email = emailController.text;
      String masterPassword = masterPasswordController.text;

      try {
        final response = await APIClient.login(email, masterPassword);

        // show snack bar if error is returned
        if (!response.success) {
          final snackBar = SnackBar(content: Text(response.error ?? ''));

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          setState(() {
            loadingStuff = false;
          });
        } else {
          // get access token from API response
          String accessToken = response.response['accessToken'];

          // insert some variables into secure application storage
          // access token
          await Storage.insert(
            key: StorageKey.accessToken,
            value: accessToken,
          );
          // email
          await Storage.insert(
            key: StorageKey.email,
            value: email,
          );
          // master password
          await Storage.insert(
            key: StorageKey.masterPassword,
            value: masterPassword,
          );

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      } catch (error) {
        final snackBar = SnackBar(
          content: Text(error.toString()),
          action: SnackBarAction(
            label: context.localeString('toast_retry'),
            onPressed: _handleLogin,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          loadingStuff = false;
        });
      }
    }
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
            const Icon(
              Icons.android,
              size: 100,
            ),

            // Title
            Text(
              context.localeString('login_page_title'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            const SizedBox(
              height: 40,
            ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email
                  TextFormField(
                    controller: emailController,
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : context.localeString('auth_invalid_email'),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Master Password
                  TextFormField(
                    controller: masterPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context
                            .localeString('auth_empty_master_password');
                      }

                      if (value.length < 8) {
                        return context
                            .localeString('auth_too_short_master_password');
                      }

                      return null;
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Master Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Sign in button
                  loadingStuff
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          ),
                          child: Text(
                            context.localeString('login_page_button'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          context.localeString('auth_not_registered_question')),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                            context.localeString('auth_not_registered_link')),
                      ),
                    ],
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
