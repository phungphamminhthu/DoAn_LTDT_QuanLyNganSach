import 'package:doan_quanlychitieu/helpers/api_helpers.dart';
import 'package:doan_quanlychitieu/screens/login_app_expense_screen.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget{
  final int userId;
  ResetPasswordScreen({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() {
    return ResetPasswordState();
  }
}

class ResetPasswordState extends State<ResetPasswordScreen>{

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool showConfirm = false;

  Future<void> updatePassword() async {

    String password =
    passwordController.text.trim();

    String confirm =
    confirmController.text.trim();

    /// EMPTY
    if(password.isEmpty || confirm.isEmpty){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Vui lòng nhập đầy đủ thông tin"),
        ),
      );

      return;
    }

    /// MIN LENGTH
    if(password.length < 2){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Mật khẩu tối thiểu 2 ký tự"),
        ),
      );

      return;
    }

    /// CHECK MATCH
    if(password != confirm){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Mật khẩu xác nhận không khớp"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success =
    await ApiHelpers.updatePassword(
      widget.userId,
      password,
    );

    if(!mounted) return;

    setState(() {
      isLoading = false;
    });

    if(success){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Cập nhật mật khẩu thành công"),
        ),
      );

      Navigator.pushAndRemoveUntil(

        context,

        MaterialPageRoute(
          builder: (_) =>
             LoginAppExpenseScreen(),
        ),

            (route) => false,
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Cập nhật mật khẩu thất bại"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black,),
      ),

      body: Padding(
          padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Đặt lại mật khẩu",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0F172A))),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                labelText: "Mật khẩu mới",
                hintText: "",
                suffixIcon: IconButton(
                  icon: Icon(showPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => showPassword = !showPassword),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: confirmController,
              obscureText: !showConfirm,
              decoration: InputDecoration(
                labelText: "Xác nhận mật khẩu",
                hintText: "Nhập lại mật khẩu",
                suffixIcon: IconButton(
                  icon: Icon(showConfirm
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => showConfirm = !showConfirm),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: isLoading ? null : updatePassword,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Cập nhật mật khẩu",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy bỏ",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500)
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }
}