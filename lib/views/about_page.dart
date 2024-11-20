import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final currentPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch and prefill user data when page initializes
  }

  // Fetch user data from Firestore using email
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? userEmail = user.email;

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          Map<String, dynamic> data =
              querySnapshot.docs.first.data() as Map<String, dynamic>;

          setState(() {
            nameController.text = data['name'] ?? 'Unknown Name';
            emailController.text = data['email'] ?? userEmail!;
          });
        } else {
          // If no document found, set default values
          setState(() {
            nameController.text = 'Unknown Name';
            emailController.text = userEmail!;
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
        setState(() {
          nameController.text = 'Unknown Name';
          emailController.text = userEmail ?? 'Unknown Email';
        });
      }
    }
  }

  // Update User Data in Firebase
  Future<void> updateUserData() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String newPassword = passwordController.text.trim();
    String currentPassword = currentPasswordController.text.trim();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Re-authenticate user with the current password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update email if changed
        if (email.isNotEmpty && email != user.email) {
          await user.updateEmail(email);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'email': email});
        }

        // Update password if changed
        if (newPassword.isNotEmpty) {
          await user.updatePassword(newPassword);
        }

        // Update name in Firestore and FirebaseAuth if changed
        if (name.isNotEmpty && name != user.displayName) {
          await user.updateDisplayName(name);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'name': name});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")),
        );
      }
    }
  }

  // Logout function
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'loginscreen');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFB5CFCE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: CircleAvatar(
                  backgroundImage: const AssetImage('asset/images/boy1.png'),
                  radius: 58.sp,
                  backgroundColor: Colors.grey.shade300,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 18.sp,
                          backgroundColor: Colors.white70,
                          child: Icon(
                            CupertinoIcons.camera,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 51.h),

              // Name Label & Input
              Text(
                "Name",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Jayandra Hamal",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFE2DCDC)),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Email Label & Input
              Text(
                "Email",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "company@company.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFE2DCDC)),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Current Password Input
              Text(
                "Current Password",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "*************",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFE2DCDC)),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // New Password Input
              Text(
                "New Password",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "*************",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFE2DCDC)),
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Update Button
              MaterialButton(
                minWidth: double.infinity,
                height: size.height * 0.065,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                onPressed: updateUserData,
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Logout Button
              MaterialButton(
                minWidth: double.infinity,
                height: size.height * 0.065,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                onPressed: logout,
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
