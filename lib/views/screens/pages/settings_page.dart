import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_miner/controllers/theme_controller.dart';
import 'package:firebase_miner/helpers/fb_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_list/toggle_list.dart';

const Color appColor = Color.fromRGBO(225, 195, 64, 1);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    User user = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 500,
                minHeight: 50,
              ),
              child: ToggleList(
                divider: const SizedBox(height: 10),
                toggleAnimationDuration: const Duration(milliseconds: 400),
                scrollPosition: AutoScrollPosition.begin,
                trailing: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.expand_more),
                ),
                children: [
                  ToggleListItem(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: 'profile',
                        child: (user.photoURL == null)
                            ? CircleAvatar(
                                radius: 25,
                                child: Text(
                                  user.email!.substring(0, 2).capitalizeFirst!,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              )
                            : CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(user.photoURL!),
                              ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        '${user.email}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                    ),
                    content: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        color: appColor.withOpacity(0.15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.email}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            color: Colors.white,
                            height: 2,
                            thickness: 2,
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            buttonHeight: 32.0,
                            buttonMinWidth: 90.0,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Column(
                                  children: [
                                    Icon(Icons.edit),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    headerDecoration: const BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    expandedHeaderDecoration: const BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                  ToggleListItem(
                    leading: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.light_mode_outlined)),
                    title: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Set Theme',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                    ),
                    content: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        color: appColor.withOpacity(0.15),
                      ),
                      child: Builder(builder: (context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => RadioListTile(
                                  activeColor: Colors.orangeAccent,
                                  title: const Text('Light Theme'),
                                  value: 'light',
                                  groupValue:
                                      themeController.themeModel.theme.value,
                                  onChanged: (val) {
                                    themeController.themeToggle(val);
                                  },
                                )),
                            Obx(() => RadioListTile(
                                  activeColor: Colors.orangeAccent,
                                  title: const Text('Dark Theme'),
                                  value: 'dark',
                                  groupValue:
                                      themeController.themeModel.theme.value,
                                  onChanged: (val) {
                                    themeController.themeToggle(val);
                                  },
                                )),
                            Obx(() => RadioListTile(
                                  activeColor: Colors.orangeAccent,
                                  title: const Text('System Theme'),
                                  value: 'system',
                                  groupValue:
                                      themeController.themeModel.theme.value,
                                  onChanged: (val) {
                                    themeController.themeToggle(val);
                                  },
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        );
                      }),
                    ),
                    headerDecoration: const BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    expandedHeaderDecoration: const BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: OutlinedButton(
                onPressed: () async {
                  await FbHelper.fbHelper.signOutUser();
                  themeController.themeToggle('light');
                  Get.offAllNamed('/sign_in');
                  SnackBar snackBar =
                      const SnackBar(content: Text('Sign Out Successful'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
