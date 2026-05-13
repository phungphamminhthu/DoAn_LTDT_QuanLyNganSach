import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/api_helpers.dart';

class ProfilePage extends StatefulWidget{
  final Map<String, dynamic> user;
  ProfilePage({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage>{
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.user['full_name'],
    );

    phoneController = TextEditingController(
      text: widget.user['phone'],
    );

    emailController = TextEditingController(
      text: widget.user['email'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xffF6F8FB),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: () {
              Navigator.pop(context); // quay lại màn hình trước
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(color: Colors.black,
          fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,

        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_outlined,
                color: Colors.blue,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
              widget.user['avatar'] != null &&
                  widget.user['avatar']
                      .toString()
                      .isNotEmpty
                  ? NetworkImage(
                widget.user['avatar'],
              )
                  : null,
              child:
              widget.user['avatar'] == null
                  ? const Icon(
                Icons.person,
                size: 40,
              ) : null,
            ),
            const SizedBox(height: 30),
            buildTextField(
              'Họ và tên',
              nameController,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'Số điện thoại',
              phoneController,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'Email',
              emailController,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.blue,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),
                onPressed: () async {

                  setState(() {
                    isLoading = true;
                  });

                  bool success =
                  await ApiHelpers.updateProfile(

                    userId: widget.user['id'],

                    fullName: nameController.text.trim(),

                    phone: phoneController.text.trim(),

                    email: emailController.text.trim(),
                  );

                  setState(() {
                    isLoading = false;
                  });

                  if(success){

                    widget.user['full_name'] =
                        nameController.text;

                    widget.user['phone'] =
                        phoneController.text;

                    widget.user['email'] =
                        emailController.text;

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(
                        content: Text(
                          'Cập nhật thành công',
                        ),
                      ),
                    );

                  } else {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(
                        content: Text(
                          'Cập nhật thất bại',
                        ),
                      ),
                    );
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(
                  'Lưu thay đổi',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label,
      TextEditingController controller,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        )
      ],
    );
  }
}