import "package:bytepass/api.dart";
import "package:bytepass/ui/pages/login.dart";
import "package:email_validator/email_validator.dart";
import "package:flutter/material.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
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
          final snackBar = SnackBar(content: Text(response.error ?? ""));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          setState(() {
            loadingStuff = false;
          });
        }
        // registered successfully, redirect to login page
        else {
          const snackBar = SnackBar(
            content: Text("Registered successfully! Please Sign in now."),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      } catch (error) {
        final snackBar = SnackBar(
          content: Text(error.toString()),
          action: SnackBarAction(
            label: "Retry",
            onPressed: _handleRegister,
          ),
        );

        if (!mounted) return;
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

            // Title text
            const Text(
              "Sign up",
              style: TextStyle(
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
                        : "Please enter a valid email",
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Email",
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
                        return "Please enter your master password";
                      }

                      if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }

                      return null;
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: "Master Password",
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
                        return "Please enter your master password";
                      }

                      if (value != masterPasswordController.text) {
                        return "Passwords aren't the same";
                      }

                      return null;
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: "Re-type Master Password",
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
                      hintText: "Master Password hint (optional)",
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
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
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
                      const Text("Already registered?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Sign in"),
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
