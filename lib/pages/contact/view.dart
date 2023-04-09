import 'package:firebase_chat/common/values/colors.dart';
import 'package:firebase_chat/common/widgets/app.dart';
import 'package:firebase_chat/common/widgets/button.dart';
import 'package:firebase_chat/pages/contact/controller.dart';
import 'package:firebase_chat/pages/contact/widgets/contact_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../../common/values/shadows.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return transparentAppBar(
      title: Text("Contact",
          style: TextStyle(
            color: AppColors.primaryBackground,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: ContactList());
  }
}
