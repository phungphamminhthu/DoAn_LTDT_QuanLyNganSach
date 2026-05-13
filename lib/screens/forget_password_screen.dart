import 'package:doan_quanlychitieu/helpers/api_helpers.dart';
import 'package:doan_quanlychitieu/screens/otp_verify_screen.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ForgetPasswordState();
  }
}

class ForgetPasswordState extends State<ForgetPasswordScreen>{

  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> sendOtp() async {
    setState(() => isLoading = true);

    String phone = phoneController.text.trim();


    // kiểm tra số điện thoại có trong DB
    var user = await ApiHelpers.checkPhoneExists(phone);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Số điện thoại không tồn tại")),
      );
      setState(() => isLoading = false);
      return;
    }

    int userId = user['id']; // lấy đúng id từ DB

    String? otp = await ApiHelpers.sendOtp(userId);

    if (otp != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP của bạn là: $otp"),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerifyScreen(
            phone: phoneController.text,
            userId: userId,
          ),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gửi OTP thất bại"),
        ),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: const Icon(Icons.lock_reset,
                    color: Colors.blueAccent, size: 40),
              ),
              const SizedBox(height: 20),
              const Text("Quên mật khẩu",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F172A))),
              const SizedBox(height: 10),
              const Text("Vui lòng nhập số điện thoại để nhận mã xác thực",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Số điện thoại",
                        hintText: "Nhập số điện thoại của bạn",
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
                        onPressed: isLoading ? null : sendOtp,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Gửi mã OTP →",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text("‹ Quay lại đăng nhập",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500)),
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