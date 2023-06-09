import 'package:firebase_chat/common/store/store.dart';
import 'package:firebase_chat/pages/messages/state.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:location/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../common/entities/msg.dart';

class MessageController extends GetxController {
  MessageController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final MessageState state = MessageState();
  var listener;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  void onRefresh() {
    asyncLoadAllData().then((value) {
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((error) {
      refreshController.refreshFailed();
    });
  }

  void onLoading() {
    asyncLoadAllData().then((value) {
      refreshController.loadComplete();
    }).catchError((error) {
      refreshController.loadFailed();
    });
  }

  @override
  void onReady() {
    super.onReady();
    getFcmToken();
  }

  asyncLoadAllData() async {
    var from_message = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token)
        .get();

    var to_messages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("to_uid", isEqualTo: token)
        .get();
    state.msgList.clear();
    if (from_message.docs.isNotEmpty) {
      state.msgList.assignAll(from_message.docs);
    }

    if (to_messages.docs.isNotEmpty) {
      state.msgList.assignAll(to_messages.docs);
    }
  }

  getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      var user =
          await db.collection("user").where("id", isEqualTo: token).get();
      if (user.docs.isNotEmpty) {
        await db
            .collection("user")
            .doc(user.docs.first.id)
            .update({"fcm_token": fcmToken});
      }
    }
  }
}
