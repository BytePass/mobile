import 'package:bytepass/api/auth.dart';
import 'package:bytepass/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _State();
}

class _State extends State<RegisterPage> {
  // create a form state
  final _formKey = GlobalKey<FormState>();

  // create a text editing controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController masterPasswordController = TextEditingController();
  TextEditingController masterPasswordHintController = TextEditingController();

  // state of loading stuff
  bool loadingStuff = false;

  Future _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loadingStuff = true;
      });

      // get the email, master password and master password hint from the text editing controllers
      String email = emailController.text;
      String masterPassword = masterPasswordController.text;
      String masterPasswordHint = masterPasswordHintController.text;

      try {
        await AuthApi.register(
          email,
          masterPassword,
          masterPasswordHint,
        );

        if (!mounted) return;

        // registered successfully, redirect to login page
        Utils.showSnackBar(
          context,
          content: context.localeString('register_successfully_toast'),
        );

        // navigate to login page
        NavigatorPage.login(context);
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

  // show/hide password
  bool _passwordHide = true;

  // toogle password visibility
  void _togglePasswordView() {
    setState(() {
      _passwordHide = !_passwordHide;
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
                      hintText: context.localeString(
                        'auth_field_email',
                      ),
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
                        return context.localeString(
                          'auth_empty_master_password',
                        );
                      }

                      if (value.length < 8) {
                        return context.localeString(
                          'auth_too_short_master_password',
                        );
                      }

                      return null;
                    },
                    maxLines: 1,
                    obscureText: _passwordHide,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(_passwordHide
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      hintText: context.localeString(
                        'auth_field_master_password',
                      ),
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
                        return context.localeString(
                          'auth_empty_master_password',
                        );
                      }

                      if (value != masterPasswordController.text) {
                        return context.localeString(
                          'auth_match_master_password',
                        );
                      }

                      return null;
                    },
                    maxLines: 1,
                    obscureText: _passwordHide,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(_passwordHide
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      hintText: context.localeString(
                        'register_password_master_password_retype',
                      ),
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
                        'register_password_master_password_hint',
                      ),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                        onPressed: () => NavigatorPage.login(context),
                        child: Text(
                          context.localeString('auth_already_registered_link'),
                        ),
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
