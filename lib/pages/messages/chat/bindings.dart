import 'package:firebase_chat/pages/messages/chat/controller.dart';
import 'package:firebase_chat/pages/signin/controller.dart';
import 'package:get/get.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
