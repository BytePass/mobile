import 'package:bytepass/api.dart';
import 'package:bytepass/ui/pages/login.dart';
import 'package:bytepass/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController masterPasswordController = TextEditingController();
  TextEditingController masterPasswordHintController = TextEditingController();

  bool loadingStuff = false;

  Future _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loadingStuff = true;
      });

      try {
        final response = await APIClient.register(
          emailController.text,
          masterPasswordController.text,
          masterPasswordHintController.text,
        );

        if (!mounted) return;

        // show snack bar if error is returned
        if (!response.success) {
          final snackBar = SnackBar(content: Text(response.error ?? ''));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          setState(() {
            loadingStuff = false;
          });
        }
        // registered successfully, redirect to login page
        else {
          Utils.showSnackBar(
            context,
            content: context.localeString('register_successfully_toast'),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
      } catch (error) {
        Utils.showSnackBar(
          context,
          content: context.localeString('toast_retry'),
          retryAction: _handleRegister,
        );

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

            // Title text
            Text(
              context.localeString('register_page_title'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 40,
            ),

            // Register form
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

                  // Master password
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

                  // Re-type Master password
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context
                            .localeString('auth_empty_master_password');
                      }

                      if (value != masterPasswordController.text) {
                        return context
                            .localeString('auth_match_master_password');
                      }

                      return null;
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: context.localeString(
                          'register_password_master_password_retype'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Master password hint
                  TextFormField(
                    controller: masterPasswordHintController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      hintText: context.localeString(
                          'register_password_master_password_hint'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Submit button
                  loadingStuff
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleRegister,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          ),
                          child: Text(
                            context.localeString('register_page_button'),
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
                      Text(context.localeString('auth_already_registered')),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(context
                            .localeString('auth_already_registered_link')),
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
