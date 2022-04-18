import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    Map<String, TextEditingController> inputText = {
      "Email" : TextEditingController(),
      "Password" : TextEditingController()
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.chevron_left,
                    size: MediaQuery.of(context).size.width / 20,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: MediaQuery.of(context).size.width / 5,
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: inputText["Email"],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: inputText["Password"],
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width / 61,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  for (String typeText in inputText.keys) { // null checks
                                    if (inputText[typeText]!.text.isEmpty) throw CustomException('Fill in all fields');
                                  }
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: inputText['Email']!.text,
                                      password: inputText['Password']!.text
                                  );
                                  User? user = FirebaseAuth.instance.currentUser;
                                  if (user != null && user.emailVerified) {
                                    Navigator.pop(context);
                                    return;
                                  }
                                  throw CustomException("Verify account email");
                                } on FirebaseAuthException catch (e) {
                                  String error = "Server error: " + e.code;
                                  if (e.code == 'user-not-found') {
                                    error = 'No user found for that email.';
                                  } else if (e.code == 'wrong-password') {
                                    error = 'Wrong password provided for that user.';
                                  }
                                  createErrorScreen (error, context, "Sign in");
                                } on CustomException catch (e) {
                                  createErrorScreen (e.cause, context, "Sign in");
                                } catch (e) {
                                  createErrorScreen (e.toString(), context, "Sign in");
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width / 61,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  for (String typeText in inputText.keys) { // null checks
                                    if (inputText[typeText]!.text.isEmpty) throw CustomException('Fill in all fields');
                                  }
                                  // valid email check
                                  String email = inputText['Email']!.text;
                                  if (!email.contains('@') || !email.contains('.') || email.indexOf('.') == (email.length - 1)) throw CustomException('Fill in a valid email');
                                  // create account
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                      email: email, password: inputText['Password']!.text);
                                  user = FirebaseAuth.instance.currentUser;
                                  if (user != null && user!.emailVerified) {
                                    await user!.sendEmailVerification();
                                    showDialog<void>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Account Created"),
                                        content: const Text("Verify your email before logging in."),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    );
                                    await FirebaseAuth.instance.signOut();
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    createErrorScreen ("The password provided is too weak.", context, "Registration");
                                  } else if (e.code == 'email-already-in-use') {
                                    createErrorScreen ("The account already exists for that email.", context, "Registration");
                                  }
                                }on CustomException catch (e) {
                                  createErrorScreen (e.cause, context, "Registration");
                                } catch (e) {
                                  createErrorScreen (e.toString(), context, "Registration");
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Align(
                          alignment: Alignment.centerRight,
                          child: Text("Forgot password?")
                      ),
                    )
                  ],
                ),
              ),
            ]
        )
      ),
    );
  }
}

class CustomException implements Exception {
  String cause;
  CustomException(this.cause);
}

void createErrorScreen (error, context, sourceString) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(sourceString + " Failure"),
      content: Text(error),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}