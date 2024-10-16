import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_miner/helpers/fb_helper.dart';
import 'package:firebase_miner/models/fire_store_model.dart';

class FsHelper {
  FsHelper._();

  static final FsHelper fsHelper = FsHelper._();
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  addUsers({required FireStoreModel fsModel}) async {
    bool isUserExists = false;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection('users').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
        querySnapshot.docs;

    allDocs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      String email = doc.data()['email'];

      if (email == fsModel.email) {
        isUserExists = true;
      }
    });

    if (isUserExists == false) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firebaseFirestore.collection('records').doc('users').get();
      int id = documentSnapshot['id'];
      int counter = documentSnapshot['counter'];

      id++;
      await firebaseFirestore.collection('users').doc('User_$id').set({
        'name': fsModel.name,
        'email': fsModel.email,
        'timestamp': fsModel.timestamp,
      });

      await firebaseFirestore.collection('records').doc('users').update(
        {
          'id': id,
          'counter': ++counter,
        },
      );
    }
  }

  //fetch all users
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return firebaseFirestore.collection('users').snapshots();
  }

  //send msg
  sendMessage({required String msg, required String receiverEmail}) async {
    String? senderMail = FbHelper.firebaseAuth.currentUser!.email;

    bool isUserExists = false;
    String? docId;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection('chatRooms').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatRooms =
        querySnapshot.docs;

    allChatRooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> chatroom) {
      List users = chatroom.data()['users'];

      if (users.contains(senderMail!) && users.contains(receiverEmail)) {
        isUserExists = true;
        docId = chatroom.id;
      }
    });

    if (isUserExists == false) {
      DocumentReference<Map<String, dynamic>> chatroomRefs =
          await firebaseFirestore.collection('chatRooms').add(
        {
          'users': [
            receiverEmail,
            senderMail,
          ],
        },
      );
      docId = chatroomRefs.id;
    }
    await firebaseFirestore
        .collection('chatRooms')
        .doc(docId)
        .collection('messages')
        .add(
      {
        'msg': msg,
        'sentBy': senderMail,
        'receiverEmail': receiverEmail,
        'timeStamp': FieldValue.serverTimestamp(),
      },
    );
  }

  //fetch messages

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessages(
      {required String receiverEmail}) async* {
    String? senderMail = FbHelper.firebaseAuth.currentUser!.email;

    String? docId;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection('chatRooms').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatRooms =
        querySnapshot.docs;

    for (var chatroom in allChatRooms) {
      List users = chatroom.data()['users'];

      if (users.contains(senderMail!) && users.contains(receiverEmail)) {
        docId = chatroom.id;
        break; // Exit the loop once docId is found
      }
    }

    if (docId != null) {
      yield* firebaseFirestore
          .collection('chatRooms')
          .doc(docId)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .snapshots();
    } else {
      // Handle the case where docId is not found
      // You might want to throw an exception or return an empty stream
      print('Chat room not found for users: $senderMail and $receiverEmail');
      // yield* const Stream.empty(); // Return an empty stream
    }
  }

  //delete messages

  Future<void> deleteMessages(
      {required String receiverEmail, required String messagesDocId}) async {
    String? senderEmail = FbHelper.firebaseAuth.currentUser!.email;
    String? chatroomId;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection('chatRooms').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatRooms =
        querySnapshot.docs;

    allChatRooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> chatroom) {
      List users = chatroom.data()['users'];

      if (users.contains(senderEmail!) && users.contains(receiverEmail)) {
        chatroomId = chatroom.id;
      }
    });
    firebaseFirestore
        .collection('chatRooms')
        .doc(chatroomId)
        .collection('messages')
        .doc(messagesDocId)
        .delete();
  }

  //edit messages

  Future<void> editMessages({
    required String receiverEmail,
    required String messagesDocId,
    required String updatedMsg,
  }) async {
    String? senderEmail = FbHelper.firebaseAuth.currentUser!.email;
    String? chatroomId;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection('chatRooms').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatRooms =
        querySnapshot.docs;

    allChatRooms.forEach(
      (QueryDocumentSnapshot<Map<String, dynamic>> chatroom) {
        List users = chatroom.data()['users'];

        if (users.contains(senderEmail!) && users.contains(receiverEmail)) {
          chatroomId = chatroom.id;
        }
      },
    );
    await firebaseFirestore
        .collection('chatRooms')
        .doc(chatroomId)
        .collection('messages')
        .doc(messagesDocId)
        .update(
      {
        'msg': updatedMsg,
        'isEdited': true,
      },
    );
  }
}
