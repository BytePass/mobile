import "package:bytepass/api.dart";
import "package:bytepass/storage.dart";
import "package:bytepass/ui/pages/home.dart";
import "package:bytepass/ui/pages/register.dart";
import "package:email_validator/email_validator.dart";
import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
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
          final snackBar = SnackBar(content: Text(response.error ?? ""));

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          setState(() {
            loadingStuff = false;
          });
        } else {
          // get access token from API response
          String accessToken = response.response["accessToken"];

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
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      } catch (error) {
        final snackBar = SnackBar(
          content: Text(error.toString()),
          action: SnackBarAction(
            label: "Retry",
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
            const Text(
              "Log in",
              style: TextStyle(
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

                  // Master Password
                  TextFormField(
                    controller: masterPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your master password";
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

                  // Sign in button
                  loadingStuff
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          ),
                          child: const Text(
                            "Sign in",
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
                      const Text("Not registered yet?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text("Create an account"),
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
