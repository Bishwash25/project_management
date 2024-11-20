import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final selectedDay = DateTime.now();
  List<String> status = ["Pending", "Completed"];
  List<String> users = ["User1", "User2", "User3"]; // Add list of users here
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? selectedStatus;
  DateTime? dueDate;
  String? assignedTo;

  Future<void> submitTaskData() async {
    if (!globalKey.currentState!.validate()) return;

    String taskTitle = taskTitleController.text.trim();
    String description = descriptionController.text.trim();
    String taskStatus = selectedStatus ?? "Pending";
    DateTime taskDueDate = dueDate ?? DateTime.now();

    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'taskTitle': taskTitle,
        'description': description,
        'status': taskStatus,
        'dueDate': taskDueDate,
        'assignedTo': assignedTo,
        'created_at': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task added successfully")),
      );

      // Clear fields
      taskTitleController.clear();
      descriptionController.clear();
      setState(() {
        selectedStatus = null;
        dueDate = null;
        assignedTo = null;
      });
    } catch (e) {
      print("Error adding task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding task: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFB5CFCE),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 28.sp,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Add Task",
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
          child: Form(
            key: globalKey,
            child: Column(
              children: [
                TextFormField(
                  controller: taskTitleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Task title is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Task Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Date picker
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.sp),
                  ),
                  child: MaterialButton(
                    elevation: 10,
                    height: size.height * 0.06,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: selectedDay,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 4),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            dueDate = value;
                          });
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dueDate == null
                              ? "Select Due Date"
                              : "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black54,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 22.sp,
                          color: Colors.black54,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Task description
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description is required";
                    }
                    return null;
                  },
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Task Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Dropdown for status
                DropdownButtonFormField<String>(
                  hint: const Text("Select Status"),
                  value: selectedStatus,
                  items: status.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedStatus = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),

                // Dropdown for assignedTo
                DropdownButtonFormField<String>(
                  hint: const Text("Assign To"),
                  value: assignedTo,
                  items: users.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      assignedTo = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please assign a user";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),

                // Submit button
                MaterialButton(
                  elevation: 7,
                  minWidth: size.width,
                  height: size.height * 0.07,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  color: Colors.black,
                  onPressed: submitTaskData,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
