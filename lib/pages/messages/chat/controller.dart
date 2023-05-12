import 'dart:io';
import 'package:firebase_chat/common/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_chat/common/entities/entities.dart';
import 'package:firebase_chat/common/entities/user.dart';
import 'package:firebase_chat/common/routes/names.dart';
import 'package:firebase_chat/common/widgets/toast.dart';
import 'package:firebase_chat/pages/messages/chat/index.dart';
import 'package:firebase_chat/pages/signin/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common/store/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatController extends GetxController {
  ChatController();
  ChatState state = ChatState();
  var doc_id;

  final textController = TextEditingController();
  ScrollController msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();
  final user_id = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  var listener;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    doc_id = data['doc_id'];
    state.to_uid.value = data['to_uid'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
    print(Get.parameters);
    print(doc_id);
  }

  sendMessage() async {
    String sendContent = textController.text;
    final content = Msgcontent(
      uid: user_id,
      content: sendContent,
      type: "text",
      addtime: Timestamp.now(),
    );
    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (Msgcontent msgcontent, options) =>
              msgcontent.toFirestore(),
        )
        .add(content)
        .then(
      (value) {
        textController.clear();
        Get.focusScope?.unfocus();
      },
    );
    print(doc_id);

    await db.collection("message").doc(doc_id).update(
      {
        "last_msg": sendContent,
        "last_time": Timestamp.now(),
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    var messages = db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirestore())
        .orderBy("addtime", descending: false);
    state.msgcontentlist.clear();

    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              state.msgcontentlist.insert(0, change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
    }, onError: (error) => print("Listen Failed: ${error}"));
  }

  @override
  void dispose() {
    msgScrolling.dispose();
    listener.cancel();
    super.dispose();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print("No Image Selected");
    }
  }

  Future getImgUrl(String name) async {
    final spaceRef = FirebaseStorage.instance.ref("chat").child(name);
    var str = await spaceRef.getDownloadURL();
    return str ?? "";
  }

  sendImageMessage(String url) async {
    final content = Msgcontent(
        uid: user_id, content: url, type: "image", addtime: Timestamp.now());
    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (Msgcontent msgcontent, options) =>
              msgcontent.toFirestore(),
        )
        .add(content)
        .then(
      (value) {
        textController.clear();
        Get.focusScope?.unfocus();
      },
    );
    print(doc_id);

    await db.collection("message").doc(doc_id).update(
      {
        "last_msg": " [image] ",
        "last_time": Timestamp.now(),
      },
    );
  }

  Future uploadFile() async {
    if (_photo == null) return;
    // final fileName = getRandomString(15) + extension(_photo!.path);
    final fileName = getRandomString(15) + (_photo!.path);
    try {
      final ref = FirebaseStorage.instance.ref("chat").child(fileName);
      await ref.putFile(_photo!).snapshotEvents.listen(
        (event) async {
          switch (event.state) {
            case TaskState.running:
              break;
            case TaskState.paused:
              break;
            case TaskState.success:
              String imgUrl = await getImgUrl(fileName);
              sendImageMessage(imgUrl);
              break;
          }
        },
      );
    } catch (e) {
      print("Theres'a an error");
    }
  }
}
