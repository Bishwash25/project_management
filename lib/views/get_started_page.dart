import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fix MediaQuery size call
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          color: Color(0xFFB5CFCE), // Background color B5CFCE
        ),
        child: Center(
          child: MaterialButton(
            minWidth: 150.w,
            height: 54.h,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.w),
            ),
            color: const Color.fromRGBO(24, 24, 24, 1),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "loginscreen");
            },
            child: Text(
              "Get Started",
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
