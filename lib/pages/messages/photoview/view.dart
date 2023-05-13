import 'package:flutter/cupertino.dart';
import 'package:firebase_chat/pages/messages/photoview/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/values/colors.dart';

class PhotoImageView extends GetView<PhotoImageViewController> {
  const PhotoImageView({Key? key}) : super(key: key);
  AppBar _buildAppBar() {
    return AppBar(
      bottom: PreferredSize(
        child: Container(
          color: AppColors.secondaryElement,
          height: 2.0,
        ),
        preferredSize: Size.fromHeight(1.0),
      ),
      title: Text(
        "Photoview",
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(controller.state.url.value),
        ),
      ),
    );
  }
}
