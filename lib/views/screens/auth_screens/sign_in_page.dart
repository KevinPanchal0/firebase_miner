import 'package:firebase_miner/utils/helpers/fb_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../prefs/user_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 2,
              ),
              Text(
                'Login to ChatBox',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Welcome back!\nSign in using your social account or email to continue',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              OutlinedButton(
                onPressed: () async {
                  Map<String, dynamic> res =
                      await FbHelper.fbHelper.signInWithGoogle();
                  if (res['user'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sign Up Success.....'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    emailController.clear();
                    passwordController.clear();
                    email = null;
                    password = null;
                    await UserPreferences.setUserLoggedIn(true);
                    Get.offAllNamed('/');
                  } else if (res['error'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${res['error']}.....'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sign Up Failed.....'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    CircleBorder(),
                  ),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.all(7),
                  ),
                ),
                child: Image.asset(
                  'assets/icons/google.png',
                  height: 30,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                  text: '--------------------------------',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  children: [
                    const TextSpan(
                      text: ' OR ',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 20,
                      ),
                    ),
                    TextSpan(
                      text: '---------------------------------',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          label: Text('Email'),
                          hintText: 'example@gmail.com',
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Email field can\'t be empty';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          email = val!;
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          label: Text('Password'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Email field can\'t be empty';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          password = val!;
                        },
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(
                flex: 30,
              ),
              OutlinedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Map<String, dynamic> res = await FbHelper.fbHelper
                        .signInUser(email: email!, password: password!);

                    if (res['user'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sign Up Success.....'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      emailController.clear();
                      passwordController.clear();
                      email = null;
                      password = null;
                      await UserPreferences.setUserLoggedIn(true);
                      Get.offAllNamed('/');
                    } else if (res['error'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${res['error']}.....'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sign Up Failed.....'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  backgroundColor: const WidgetStatePropertyAll(
                    Color(0xFF24786D),
                  ),
                  foregroundColor: const WidgetStatePropertyAll(
                    Color(0xFFFFFFFF),
                  ),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              const Spacer(
                flex: 10,
              ),
              TextButton(
                onPressed: () {
                  Get.offAllNamed('/sign_up');
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Don\'t have an account',
                    style: TextStyle(color: Color(0xFF24786D), fontSize: 16),
                    children: [
                      TextSpan(
                        text: ' Sign Up',
                        style:
                            TextStyle(color: Colors.orangeAccent, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
