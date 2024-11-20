import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  Future<Map<String, String>> fetchUserData() async {
    // Get the current user's email from Firebase Auth
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail != null) {
      try {
        // Query Firestore for a document where the 'email' field matches the current user's email
        QuerySnapshot userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .limit(1) // Fetch only one document
            .get();

        if (userQuery.docs.isNotEmpty) {
          // Extract the first document
          Map<String, dynamic> data =
              userQuery.docs.first.data() as Map<String, dynamic>;

          return {
            "name": data['name'] ?? 'Unknown User',
            "designation": data['designation'] ?? 'Unknown Designation',
          };
        } else {
          print("No user found with email: $userEmail");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }

    // Fallback values if the user is not found or email is null
    return {"name": "Unknown User", "designation": "Unknown Designation"};
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFB5CFCE),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(
                          context); // Navigate back to the previous screen
                    },
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.sp),
                    ),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pushNamed(context, "add_task_page");
                    },
                    child: Text(
                      "+ Add Task",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: FutureBuilder<Map<String, String>>(
                future: fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error fetching user data"),
                    );
                  }

                  final userData = snapshot.data ??
                      {
                        "name": "Unknown User",
                        "designation": "Unknown Designation"
                      };

                  return ListView.builder(
                    itemCount: 1, // Replace with the actual number of items
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(13.sp),
                          ),
                          width: size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 8.w),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 150),
                                          child: Text(
                                            "Task Information:", // Replace with actual task title
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                            'We focus on delivering stunning results with a blend of creativity and technical expertise')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Due Date: Thursday, 22 August 2024", // Replace with actual due date
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  SizedBox(width: 8.w),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 250),
                                          child: Text(
                                            "Assigned to:", // Replace with actual assignee name
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'asset/images/boy1.png',
                                              width: 80,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(userData["name"]!),
                                                Text(
                                                  userData["designation"]!,
                                                  style: const TextStyle(
                                                    color: Color(0xFF62359C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Status: Pending",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
