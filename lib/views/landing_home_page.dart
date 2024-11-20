import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/views/about_page.dart';
import 'package:project_management/views/home_page.dart';
import 'package:project_management/views/notification_page.dart';
import 'package:project_management/views/task_page.dart';

class LandingHomePage extends StatefulWidget {
  const LandingHomePage({super.key});

  @override
  State<LandingHomePage> createState() => _LandingHomePageState();
}

class _LandingHomePageState extends State<LandingHomePage> {
  int currentIndex = 0; // To keep track of the current tab

  // List of pages for bottom navigation
  final List<Widget> _pages = const [
    MyHomePage(),
    TaskPage(),
    NotificationPage(),
    AboutPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index; // Update the current index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[currentIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 24.sp,
        currentIndex: currentIndex, // Highlight the current icon
        onTap: onTabTapped, // Call the function when an icon is tapped
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home),
            label: "", // Label is optional, hence kept empty
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "",
          )
        ],
      ),
    );
  }
}
