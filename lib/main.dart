import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/views/about_page.dart';
import 'package:project_management/views/add_task_page.dart';
import 'package:project_management/views/add_user_page.dart';
import 'package:project_management/views/edit_tasks_page.dart';
import 'package:project_management/views/get_started_page.dart';
import 'package:project_management/views/home_page.dart';
import 'package:project_management/views/landing_home_page.dart';
import 'package:project_management/views/login_screen.dart';
import 'package:project_management/views/register_page.dart';
import 'package:project_management/views/task_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Adjust as per your design
      minTextAdapt: true,
      splitScreenMode: true, // Helps in supporting split screen modes
      builder: (context, child) {
        return MaterialApp(
          title: 'PROJECT MANAGEMENT',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const GetStartedPage(),
          routes: {
            'loginscreen': (context) => const LoginScreen(),
            'registerpage': (context) => const RegisterPage(),
            'home_page': (context) => const MyHomePage(),
            'task_page': (context) => const TaskPage(),
            'add_task_page': (context) => const AddTaskPage(),
            'add_user_page': (context) => const AddUserPage(),
            'landing_home_page': (context) => const LandingHomePage(),
            'about_page': (context) => const AboutPage(),
            'edit_tasks_page': (context) => const EditTaskPage(
                name: 'defaultname',
                description: 'Task Description',
                title: 'Task Title')
          },
          // To ensure error reporting during development
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            // Catching errors during development to avoid crashes
            return widget!;
          },
        );
      },
    );
  }
}
