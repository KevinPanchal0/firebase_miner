import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_miner/helpers/fb_helper.dart';
import 'package:firebase_miner/helpers/fs_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = FbHelper.firebaseAuth.currentUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/settings_page', arguments: user);
              },
              child: Hero(
                tag: 'profile',
                child: (user!.photoURL == null)
                    ? CircleAvatar(
                        child:
                            Text(user!.email!.substring(0, 2).capitalizeFirst!),
                      )
                    : CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(user!.photoURL!),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FsHelper.fsHelper.fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;

            List<QueryDocumentSnapshot<Map<String, dynamic>>> allUser =
                (data == null) ? [] : data.docs;

            return ListView.builder(
              itemCount: allUser.length,
              itemBuilder: (context, index) {
                return (FbHelper.firebaseAuth.currentUser!.email ==
                        allUser[index].data()['email'])
                    ? Container()
                    : ListTile(
                        onTap: () {
                          Get.toNamed('/chat_page', arguments: allUser[index]);
                        },
                        leading: Text('${index + 1}'),
                        title: Text(allUser[index].data()['name']),
                        subtitle: Text(
                          allUser[index].data()['email'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'sanserif',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
