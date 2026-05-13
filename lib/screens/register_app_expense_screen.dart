import 'package:doan_quanlychitieu/helpers/api_helpers.dart';
import 'package:doan_quanlychitieu/screens/login_app_expense_screen.dart';
import 'package:flutter/material.dart';

import 'main_app_screen.dart';

class RegisterAppExpenseScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterAppExpenseState();
  }
}

class RegisterAppExpenseState extends State<RegisterAppExpenseScreen>{

  TextEditingController fullNameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  bool hidePassword = true;

  List<dynamic> users = [];
  String? fullNameError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;


  @override
  void initState(){
    super.initState();

    loadUser();
  }

  Future loadUser() async{
    users = await ApiHelpers.getUser();

    print(users);

    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Quản lý tài chính cá nhân',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 50),
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
                      buildTextField(
                        label: 'Họ và tên',
                        hint: 'Nguyễn Văn An',
                        icon: Icons.person_outline,
                        controller: fullNameController,
                        errorText: fullNameError,
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        label: 'Số điện thoại',
                        hint: '',
                        icon: Icons.phone_outlined,
                        controller: phoneController,
                        errorText: phoneError,
                      ),
                      const SizedBox(height: 20),
                      buildPasswordField(),
                      const SizedBox(height: 20),
                      buildTextField(
                        label: 'Xác nhận mật khẩu',
                        hint: '',
                        icon: Icons.lock_reset,
                        controller: confirmPasswordController,
                        errorText: confirmPasswordError,
                        exam: true,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0077B6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              fullNameError = null;
                              phoneError = null;
                              passwordError = null;
                              confirmPasswordError = null;
                            });

                            bool isValid = true;

                            if (fullNameController.text.trim().isEmpty) {
                              fullNameError = 'Vui lòng nhập họ tên';
                              isValid = false;
                            }

                            if (phoneController.text.trim().isEmpty) {
                              phoneError = 'Vui lòng nhập số điện thoại';
                              isValid = false;
                            } else if (phoneController.text.length != 10) {
                              phoneError = 'Số điện thoại phải đủ 10 số';
                              isValid = false;
                            }

                            if (passwordController.text.isEmpty) {
                              passwordError = 'Vui lòng nhập mật khẩu';
                              isValid = false;
                            }

                            if (confirmPasswordController.text.isEmpty) {
                              confirmPasswordError = 'Vui lòng xác nhận mật khẩu';
                              isValid = false;
                            } else if (passwordController.text != confirmPasswordController.text) {
                              confirmPasswordError = 'Mật khẩu không khớp';
                              isValid = false;
                            }

                            setState(() {});
                            if (!isValid) return;

                            if (fullNameController.text.isEmpty ||
                                phoneController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                confirmPasswordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
                              );
                              return;
                            }

                            if (passwordController.text != confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Mật khẩu không khớp')),
                              );
                              return;
                            }

                            bool success = await ApiHelpers.registerUser(
                              fullName: fullNameController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                            );

                            if (success) {
                              var user = await ApiHelpers.loginUser(
                                phone: phoneController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Đăng ký thành công')),
                              );
                              if(user != null){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MainAppScreen(
                                      user: user,
                                    ),
                                  ),
                                      (route) => false,
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Đăng ký thất bại')),
                              );
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Đăng ký',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Đã có tài khoản? ',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => LoginAppExpenseScreen()),
                              );
                            },
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff0077B6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Bằng cách đăng ký, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của chúng tôi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({

    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,

    String? errorText,

    bool exam = false,

  }) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(
          label,

          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff475569),
          ),
        ),

        const SizedBox(height: 10),

        TextFormField(

          controller: controller,

          obscureText: exam,

          keyboardType:
          label.contains('điện thoại')
              ? TextInputType.phone
              : TextInputType.text,

          decoration: InputDecoration(

            filled: true,
            fillColor: Colors.white,

            hintText: hint,

            errorText: errorText,

            prefixIcon: Icon(icon),

            border: OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(20),

              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(20),

              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(20),

              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),

            errorBorder: OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(20),

              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),

            focusedErrorBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(20),

              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField() {

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const Text(
          'Mật khẩu',

          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff475569),
          ),
        ),

        const SizedBox(height: 10),

        TextFormField(

          controller: passwordController,

          obscureText: hidePassword,

          decoration: InputDecoration(

            filled: true,
            fillColor: Colors.white,

            hintText: '',

            errorText: passwordError,

            prefixIcon:
            const Icon(Icons.lock_outline),

            suffixIcon: IconButton(

              onPressed: () {

                setState(() {

                  hidePassword =
                  !hidePassword;
                });
              },

              icon: Icon(

                hidePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),

            border: OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(20),

              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
