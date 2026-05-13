import 'package:doan_quanlychitieu/helpers/api_helpers.dart';
import 'package:doan_quanlychitieu/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';

class OtpVerifyScreen extends StatefulWidget{
  final String phone;
  final int userId;
  OtpVerifyScreen({super.key, required this.phone,required this.userId});
  @override
  State<StatefulWidget> createState() {
    return OtpVerifyState();
  }
}

 class OtpVerifyState extends State<OtpVerifyScreen>{

   String otpDemo = '';
   List<TextEditingController> otpControllers =
   List.generate(4, (index) => TextEditingController());
   int countdown = 60;
   bool isLoading = false;

   void initState(){
     super.initState();
     startCountdown();
     sendOtpCode();
   }

   //gửi mã otp
   Future<void> sendOtpCode() async {

     String? otp =
     await ApiHelpers.sendOtp(widget.userId);

     if(otp != null){

       setState(() {
         otpDemo = otp;
       });

       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text("OTP của bạn là: $otp"),
         ),
       );
     }
   }

   //hàm đếm ngược thời gian để gửi OTP
   void startCountdown() {
     Future.delayed(const Duration(seconds: 1), () {
       if (countdown > 0) {
         setState(() {
           countdown--;
         });
         startCountdown();
       }
     });
   }

   Future<void> verifyOtp() async {
     setState(() => isLoading = true);
     String code = otpControllers.map((c) => c.text).join(); // tạo ô để điền otp

     bool success =
     await ApiHelpers.verifyOtp(widget.userId, code,);

     if (success) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Xác thực OTP thành công")),
       );
       // Chuyển sang màn hình Reset Password
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(
           builder: (context) => ResetPasswordScreen(userId: widget.userId,),
         ),
       );
     } else {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("OTP không hợp lệ")),
       );
     }

     setState(() => isLoading = false);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,//xóa độ bóng của appBar
        leading: const BackButton(color: Colors.black,) //nút mũi tên quay lại màn hình trc
      ),

      body: Padding(
          padding: const EdgeInsets.all(24),
        child: Column(
          children: [
             const SizedBox(height: 20,),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: const Icon(Icons.verified_user,
                  color: Colors.blueAccent, size: 40),
            ),
            const SizedBox(height: 20),
            const Text("Xác thực OTP",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0F172A))),
            const SizedBox(height: 10),
            Text(
              "Mã OTP đã gửi tới ${widget.phone}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "OTP: $otpDemo",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => buildOtpBox(index)),
            ),
            const SizedBox(height: 20),
            Text("Gửi lại mã sau 00:${countdown.toString().padLeft(2, '0')}",
                style: const TextStyle(color: Colors.grey)),
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
                onPressed: isLoading ? null : verifyOtp,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Xác nhận",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget buildOtpBox(int index) {
     return SizedBox(
       width: 60,
       child: TextField(
         controller: otpControllers[index],
         keyboardType: TextInputType.number,
         textAlign: TextAlign.center,
         maxLength: 1,
         decoration: InputDecoration(
           counterText: "",
           filled: true,
           fillColor: Colors.white,
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide.none,
           ),
         ),
         onChanged: (val) {
           if (val.isNotEmpty && index < otpControllers.length - 1) {
             FocusScope.of(context).nextFocus();
           }
         },
       ),
     );
   }
 }