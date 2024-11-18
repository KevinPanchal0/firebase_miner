import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_miner/controllers/chat_controller.dart';
import 'package:firebase_miner/utils/helpers/fb_helper.dart';
import 'package:firebase_miner/utils/helpers/fs_helper.dart';
import 'package:firebase_miner/views/widgets/chat_bubble.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_context_menu/super_context_menu.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController chatController = Get.put(ChatController());
  TextEditingController msgController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot<Map> receiverEmail = ModalRoute.of(context)!
        .settings
        .arguments as QueryDocumentSnapshot<Map>;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${receiverEmail.data()['email']}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: StreamBuilder(
              stream: FsHelper.fsHelper.fetchMessages(
                receiverEmail: receiverEmail.data()['email'],
              ),
              builder: (context, streamSnapshot) {
                if (streamSnapshot.hasError) {
                  return Center(
                    child: Text('Error ${streamSnapshot.error}'),
                  );
                } else if (streamSnapshot.hasData) {
                  QuerySnapshot<Map<String, dynamic>>? data =
                      streamSnapshot.data;
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>
                      allMessages = (data == null) ? [] : data.docs;
                  return (allMessages.isEmpty)
                      ? const Center(child: Text('Send Hi to Start the chat'))
                      : ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          itemCount: allMessages.length,
                          itemBuilder: (context, i) {
                            String sentBy = allMessages[i].data()['sentBy'];
                            bool isEdited =
                                allMessages[i].data()['isEdited'] ?? false;

                            Timestamp? timestamp =
                                allMessages[i].data()['timeStamp'];

                            DateTime? dateTime = timestamp?.toDate();
                            return Row(
                              mainAxisAlignment:
                                  (FbHelper.firebaseAuth.currentUser!.email ==
                                          sentBy)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                (FbHelper.firebaseAuth.currentUser!.email !=
                                        sentBy)
                                    ? ContextMenuWidget(
                                        menuProvider: (MenuRequest request) {
                                          return Menu(
                                            children: [
                                              MenuAction(
                                                callback: () async {
                                                  await FsHelper.fsHelper
                                                      .deleteMessages(
                                                    receiverEmail: receiverEmail
                                                        .data()['email'],
                                                    messagesDocId:
                                                        allMessages[i].id,
                                                  );
                                                },
                                                title: 'Delete from all',
                                                attributes:
                                                    const MenuActionAttributes(
                                                  destructive: true,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ChatBubble(
                                            isMe: (FbHelper.firebaseAuth
                                                        .currentUser!.email ==
                                                    sentBy)
                                                ? true
                                                : false,
                                            message:
                                                allMessages[i].data()['msg'],
                                            dateTime: dateTime,
                                          ),
                                        ),
                                      )
                                    : ContextMenuWidget(
                                        menuProvider: (MenuRequest request) {
                                          return Menu(
                                            children: [
                                              MenuAction(
                                                callback: () {
                                                  chatController.startEditing(
                                                    allMessages[i].id,
                                                    allMessages[i]
                                                        .data()['msg'],
                                                    msgController,
                                                  );
                                                  focusNode.requestFocus();
                                                },
                                                title: 'Edit',
                                              ),
                                              MenuAction(
                                                callback: () async {
                                                  await FsHelper.fsHelper
                                                      .deleteMessages(
                                                          receiverEmail:
                                                              receiverEmail
                                                                      .data()[
                                                                  'email'],
                                                          messagesDocId:
                                                              allMessages[i]
                                                                  .id);
                                                },
                                                title: 'Delete from all',
                                                attributes:
                                                    const MenuActionAttributes(
                                                        destructive: true),
                                              ),
                                            ],
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ChatBubble(
                                            isMe: (FbHelper.firebaseAuth
                                                        .currentUser!.email ==
                                                    sentBy)
                                                ? true
                                                : false,
                                            message: isEdited
                                                ? "${allMessages[i].data()['msg']} (Edited)" // Append "Edited" if the message was edited
                                                : allMessages[i].data()['msg'],
                                            dateTime: dateTime,
                                          ),
                                        ),
                                      ),
                              ],
                            );
                          },
                        );
                }
                return const Center(child: Text('Send Hi to Start the chat'));
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Center(
                child: TextField(
                  controller: msgController,
                  textInputAction: TextInputAction.send,
                  focusNode: focusNode,
                  onSubmitted: (val) async {
                    if (chatController.isEditing.value) {
                      // Update the existing message
                      await FsHelper.fsHelper.editMessages(
                        receiverEmail: receiverEmail.data()['email'],
                        messagesDocId: chatController.editingMessageId.value,
                        updatedMsg: msgController.text,
                      );

                      // Reset the editing state
                      chatController.resetEditing(msgController);
                    } else {
                      if (msgController.text.isNotEmpty) {
                        await FsHelper.fsHelper.sendMessage(
                            msg: msgController.text,
                            receiverEmail: receiverEmail.data()['email'],
                            token: receiverEmail.data()['token']);
                        setState(() {});
                        FocusManager.instance.primaryFocus?.unfocus();
                        msgController.clear();
                      } else {
                        floatingSnackBar(
                          message: 'Enter something to send',
                          context: context,
                          textColor: Colors.black,
                          textStyle: const TextStyle(
                              color: Colors.green, fontSize: 16),
                          duration: const Duration(milliseconds: 4000),
                          backgroundColor:
                              const Color.fromARGB(255, 220, 234, 236),
                        );
                      }
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Circular shape
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.grey.shade200, // Background color
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (chatController.isEditing.value) {
                          // Update the existing message
                          await FsHelper.fsHelper.editMessages(
                            receiverEmail: receiverEmail.data()['email'],
                            messagesDocId:
                                chatController.editingMessageId.value,
                            updatedMsg: msgController.text,
                          );

                          // Reset the editing state
                          chatController.resetEditing(msgController);
                        } else {
                          if (msgController.text.isNotEmpty) {
                            await FsHelper.fsHelper.sendMessage(
                              msg: msgController.text,
                              receiverEmail: receiverEmail.data()['email'],
                              token: receiverEmail.data()['email'],
                            );
                            setState(() {});
                            FocusManager.instance.primaryFocus?.unfocus();
                            msgController.clear();
                          } else {
                            floatingSnackBar(
                              message: 'Enter something to send',
                              context: context,
                              textColor: Colors.black,
                              textStyle: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                              duration: const Duration(milliseconds: 4000),
                              backgroundColor:
                                  const Color.fromARGB(255, 220, 234, 236),
                            );
                          }
                        }
                      },
                      icon: Icon(
                        chatController.isEditing.value
                            ? Icons.edit
                            : Icons.send_outlined,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
