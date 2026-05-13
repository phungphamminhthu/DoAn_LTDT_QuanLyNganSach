import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/api_helpers.dart';

class PasswordPage extends StatefulWidget{
  final int userId;
  PasswordPage({super.key, required this.userId});
  @override
  State<StatefulWidget> createState() {
   return PasswordPageState();
  }
}

class PasswordPageState extends State<PasswordPage>{
  TextEditingController oldPass =
  TextEditingController();
  TextEditingController newPass =
  TextEditingController();
  TextEditingController confirmPass =
  TextEditingController();
  bool showOld = false;
  bool showNew = false;
  bool showConfirm = false;
  bool isLoading = false;

  Future updatePassword() async {
    if (newPass.text != confirmPass.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success = await ApiHelpers.updatePassword_v2(
      widget.userId,
      oldPass.text,
      newPass.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thành công')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sai mật khẩu cũ hoặc đổi thất bại')),
      );
    }
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
        'Đổi mật khẩu',
        style: TextStyle(color: Colors.black,fontSize: 18),
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


      body: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          children: [
            buildPasswordField(
              'Mật khẩu cũ',
              oldPass,
              showOld,
                  () {
                setState(() {
                  showOld = !showOld;
                });
              },
            ),
            const SizedBox(height: 20),
            buildPasswordField(
              'Mật khẩu mới',
              newPass,
              showNew,
                  () {
                setState(() {
                  showNew = !showNew;
                });
              },
            ),

            const SizedBox(height: 20),

            buildPasswordField(
              'Xác nhận mật khẩu',
              confirmPass,
              showConfirm,
                  () {
                setState(() {
                  showConfirm =
                  !showConfirm;
                });
              },
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

                onPressed:
                isLoading
                    ? null
                    : updatePassword,
                child:
                isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(
                  'Cập nhật',
                  style:
                  GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPasswordField(
      String label,
      TextEditingController controller,
      bool obscure,
      VoidCallback onTap,
      ) {

    return TextField(
      controller: controller,
      obscureText: !obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          onPressed: onTap,
          icon: Icon(
            obscure
                ? Icons.visibility
                : Icons.visibility_off,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}