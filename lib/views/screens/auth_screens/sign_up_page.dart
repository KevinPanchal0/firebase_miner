import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_miner/models/fire_store_model.dart';
import 'package:firebase_miner/prefs/user_preferences.dart';
import 'package:firebase_miner/utils/helpers/fb_helper.dart';
import 'package:firebase_miner/utils/helpers/fcm_helper.dart';
import 'package:firebase_miner/utils/helpers/fs_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? name;
  String? email;
  String? password;
  String? token;
  getToken() async {
    token = await FcmHelper.fcmHelper.fetchFCMToken();
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

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
                'Sign up with Email',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Get chatting with friends and family today by signing up for our chat app!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
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
                        controller: nameController,
                        decoration: const InputDecoration(
                          label: Text('Name'),
                          hintText: 'John Deo',
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Name field can\'t be empty';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          name = val!;
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          label: Text(
                            'Email',
                          ),
                          hintText: 'example@gmail.com',
                        ),
                        style: TextStyle(fontSize: 16),
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
                        obscureText: true,
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              RichText(
                text: TextSpan(
                  text: '------------------',
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
                      text: '------------------',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              OutlinedButton(
                onPressed: () async {
                  Map<String, dynamic> res =
                      await FbHelper.fbHelper.signInWithGoogle();

                  User user = res['user'];
                  FireStoreModel fsModel = FireStoreModel(
                      name: user.displayName!,
                      email: user.email!,
                      token: token!,
                      timestamp: FieldValue.serverTimestamp());
                  await FsHelper.fsHelper.addUsers(fsModel: fsModel);
                  await UserPreferences.setUserLoggedIn(true);
                  Get.offAllNamed('/');
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
              const Spacer(
                flex: 30,
              ),
              OutlinedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Map<String, dynamic> res = await FbHelper.fbHelper
                        .signUpUser(email: email!, password: password!);

                    if (res['user'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sign Up Success.....'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      User user = res['user'];
                      FireStoreModel fsModel = FireStoreModel(
                        name: name!,
                        token: token!,
                        email: user.email!,
                        timestamp: FieldValue.serverTimestamp(),
                      );
                      await FsHelper.fsHelper.addUsers(fsModel: fsModel);
                      emailController.clear();
                      nameController.clear();
                      passwordController.clear();
                      email = null;
                      password = null;
                      name = null;
                      Get.offAllNamed('/sign_in');
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
                    EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 10,
                    ),
                  ),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              const Spacer(
                flex: 10,
              ),
              TextButton(
                onPressed: () {
                  Get.offAllNamed('/sign_in');
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Already have an account?',
                    style: TextStyle(
                      color: Color(0xFF24786D),
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: ' Sign In',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 16,
                        ),
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
