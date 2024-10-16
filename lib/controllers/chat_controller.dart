import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var isEditing = false.obs;
  var editingMessageId = "".obs;

  void startEditing(String messageId, String messageText,
      TextEditingController msgController) {
    editingMessageId.value = messageId;
    isEditing.value = true;
    msgController.text = messageText;
  }

  void resetEditing(TextEditingController msgController) {
    editingMessageId.value = "";
    isEditing.value = false;
    msgController.clear();
  }
}
