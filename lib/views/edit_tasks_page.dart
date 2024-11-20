import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTaskPage extends StatefulWidget {
  final String name;
  final String description;
  final String title;

  const EditTaskPage({
    super.key,
    required this.name,
    required this.description,
    required this.title,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedDate = "Select Date";
  String? assignedUser;
  String? selectedStatus;

  List<String> users = ["Employee 1", "Employee 2", "Employee 3"]; // Dummy data
  List<String> status = ["Pending", "Completed"];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    descriptionController.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color(0xFFB5CFCE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB5CFCE),
        title: Text(
          'Update Task',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              // Title TextField
              Padding(
                padding: EdgeInsets.only(bottom: 15.h), // Margin between inputs
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Task Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    // Make input background white
                  ),
                ),
              ),

              // Date Picker Button
              Padding(
                padding: EdgeInsets.only(bottom: 15.h), // Margin between inputs
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.sp),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: MaterialButton(
                    elevation: 10,
                    height: size.height * 0.07,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 4),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            selectedDate = value.toString().substring(0, 10);
                          });
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.date_range, size: 20.sp),
                      ],
                    ),
                  ),
                ),
              ),

              // User Dropdown
              Padding(
                padding: EdgeInsets.only(bottom: 15.h), // Margin between inputs
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.sp),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: assignedUser,
                    hint: const Text("Assign to"),
                    items: users.map((user) {
                      return DropdownMenuItem(
                        value: user,
                        child: Text(user),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        assignedUser = value;
                      });
                    },
                    underline: const SizedBox(),
                  ),
                ),
              ),

              // Description TextField
              Padding(
                padding: EdgeInsets.only(bottom: 15.h), // Margin between inputs
                child: TextFormField(
                  maxLines: 4,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Task Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    // Make input background white
                  ),
                ),
              ),

              // Status Dropdown
              Padding(
                padding:
                    EdgeInsets.only(bottom: 30.h), // Larger margin for spacing
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.sp),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedStatus,
                    hint: const Text("Status"),
                    items: status.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                    underline: const SizedBox(),
                  ),
                ),
              ),

              // Spacer to push the button lower
              SizedBox(height: 40.h), // Increase the height to push button down

              // Update Task Button
              MaterialButton(
                minWidth: size.width,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.sp),
                ),
                height: size.height * 0.07,
                color: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, "home_page");
                  // Add update task logic here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10.w),
                    Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
