import 'package:firebase_chat/common/values/colors.dart';
import 'package:firebase_chat/common/widgets/button.dart';
import 'package:firebase_chat/pages/application/controller.dart';
import 'package:firebase_chat/pages/contact/index.dart';
import 'package:firebase_chat/pages/messages/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../../common/values/shadows.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildPageView() {
      return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.handlePageChanged(index);
          // controller.state.page.value = index;
        },
        children: const [
          MessagePage(),
          ContactPage(),
          Center(
            child: Text('Profile'),
          ),
        ],
      );
    }

    Widget _buildBottomNavigationBar() {
      return Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.state.page,
          onTap: (index) {
            controller.handleNavBarTap(index);
          },
          items: controller.bottomTabs,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          unselectedItemColor: AppColors.tabBarElement,
          selectedItemColor: AppColors.thirdElementText,
        ),
      );
    }

    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
