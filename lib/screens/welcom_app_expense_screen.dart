import 'package:doan_quanlychitieu/screens/login_app_expense_screen.dart';
import 'package:doan_quanlychitieu/screens/register_app_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class WelcomAppExpenseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomAppExpenseState();
  }
}


class WelcomAppExpenseState extends State<WelcomAppExpenseScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FB),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                const Spacer(),

                //icon
                Container(
                  width: 140,
                  height: 140,

                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined,

                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                //tieu de
                const Text(
                  'Chào mừng bạn',

                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff111827),
                  ),
                ),

                const SizedBox(height: 14),

                // mo ta
                const Text(
                  'Quản lý tài chính cá nhân ',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xff6B7280),
                  ),
                ),

                const Spacer(),

                // dang nhap
                SizedBox(

                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(

                      backgroundColor:
                      Colors.blueAccent,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                          LoginAppExpenseScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'Đăng nhập',

                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                //dang ky
                SizedBox(

                  width: double.infinity,
                  height: 58,

                  child: OutlinedButton(

                    style: OutlinedButton.styleFrom(

                      side: const BorderSide(
                        color: Colors.blueAccent,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                          RegisterAppExpenseScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'Đăng ký',

                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.public, color: Colors.grey, size: 20), // icon quả địa cầu
                        SizedBox(width: 8),
                        Text(
                          'TIẾNG VIỆT',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    )
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}