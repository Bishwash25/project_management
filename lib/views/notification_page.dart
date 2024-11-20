import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    // Dummy data for the purpose of UI only
    final List<Map<String, dynamic>> tasks = [
      {
        "name": "Jayandra Hamal",
        "dueDate": "2024-09-15",
        "taskTitle": "Complete Project Documentation"
      },
      {
        "name": "Bishwash Acharya",
        "dueDate": "2024-09-15",
        "taskTitle": "Review Design Drafts"
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFB5CFCE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                "No completed tasks yet!!!",
                style: TextStyle(
                  fontSize: 20.sp,
                ),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Container(
                    height: size.height * 0.18,
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(
                        10.sp,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              "${tasks[index]["name"]} has completed assigned task",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 16.sp,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                tasks[index]["dueDate"],
                                style: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 16.sp,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Flexible(
                                child: Text(
                                  tasks[index]["taskTitle"],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
