import 'package:firebase_chat/common/entities/user.dart';
import 'package:firebase_chat/common/routes/names.dart';
import 'package:firebase_chat/common/style/color.dart';
import 'package:firebase_chat/common/values/colors.dart';
import 'package:firebase_chat/common/widgets/toast.dart';
import 'package:firebase_chat/pages/application/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/store/user.dart';

class ApplicationController extends GetxController {
  final state = ApplicationState();
  ApplicationController();

  late final List<String> tabTitles;
  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;

  void handlePageChanged(int index) {
    state.page = index;
    update();
  }

  void handleNavBarTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    super.onInit();
    tabTitles = ['Chat', 'Contact', 'Profile'];
    bottomTabs = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.chat_bubble_2,
          color: AppColors.thirdElementText,
        ),
        activeIcon: Icon(
          CupertinoIcons.chat_bubble_2,
          color: AppColors.secondaryElementText,
        ),
        label: tabTitles[0],
        backgroundColor: AppColors.primaryBackground,
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.contact_page,
          color: AppColors.thirdElementText,
        ),
        activeIcon: Icon(
          Icons.contact_page,
          color: AppColors.secondaryElementText,
        ),
        label: tabTitles[1],
        backgroundColor: AppColors.primaryBackground,
      ),
      BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.person,
          color: AppColors.thirdElementText,
        ),
        activeIcon: Icon(
          CupertinoIcons.person,
          color: AppColors.secondaryElementText,
        ),
        label: tabTitles[2],
        backgroundColor: AppColors.primaryBackground,
      ),
    ];

    pageController = PageController(initialPage: state.page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
