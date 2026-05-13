import 'package:doan_quanlychitieu/helpers/api_helpers.dart';
import 'package:doan_quanlychitieu/screens/forget_password_screen.dart';
import 'package:doan_quanlychitieu/screens/main_app_screen.dart';
import 'package:doan_quanlychitieu/screens/register_app_expense_screen.dart';
import 'package:flutter/material.dart';

class LoginAppExpenseScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginAppExpenseState();
  }
}
class LoginAppExpenseState extends State<LoginAppExpenseScreen>{

  TextEditingController phoneController =
  TextEditingController();

  TextEditingController passwordController =
  TextEditingController();

  bool hidePassword = true;

  String? phoneError; //thong bao loi
  String? passwordError;
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
              Navigator.pop(context); // quay lại màn hình trước
            },
          ),
        ),
          body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(24),
              child: Column(
                children: [

                  const SizedBox(height: 40,),
                  //icon
                  Container(

                    width: 100,
                    height: 100,

                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius:
                      BorderRadius.circular(30),

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
                  // dang nhap
                  const Text(
                    'Đăng nhập',

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

                  //form đăng nhập
                  const SizedBox(height: 40,),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(30),

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
                        /// PHONE
                        buildTextField(
                          label: 'Số điện thoại',
                          hint: '',
                          icon:
                          Icons.phone_android_outlined,
                          controller: phoneController,

                          errorText: phoneError,
                        ),

                        const SizedBox(height: 30),

                        /// PASSWORD
                        buildPasswordField(),

                        const SizedBox(height: 40),

                        /// BUTTON LOGIN
                        SizedBox(

                          width: double.infinity,
                          height: 65,

                          child: ElevatedButton(

                            style:
                            ElevatedButton.styleFrom(

                              backgroundColor:
                              const Color(0xff0077B6),

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                            ),

                            onPressed: () async {

                              setState(() {

                                phoneError = null;
                                passwordError = null;
                              });

                              bool isValid = true;

                              /// CHECK PHONE
                              if(phoneController.text
                                  .trim()
                                  .isEmpty){

                                phoneError =
                                'Vui lòng nhập số điện thoại';

                                isValid = false;

                              } else if(
                              phoneController.text.length != 10){

                                phoneError =
                                'Số điện thoại phải đủ 10 số';

                                isValid = false;
                              }

                              /// CHECK PASSWORD
                              if(passwordController.text
                                  .isEmpty){

                                passwordError =
                                'Vui lòng nhập mật khẩu';

                                isValid = false;
                              }

                              setState(() {});

                              if(!isValid) return;

                              /// LOGIN API
                              var user =
                              await ApiHelpers.loginUser(

                                phone: phoneController.text,

                                password: passwordController.text,
                              );

                              if(user != null){

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(

                                  const SnackBar(
                                    content: Text('Đăng nhập thành công'),
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MainAppScreen(
                                      user: user,
                                    ),
                                  ),
                                );

                              } else {

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(

                                  const SnackBar(
                                    content:
                                    Text('Sai tài khoản hoặc mật khẩu'),
                                  ),
                                );
                              }
                            },

                            child: const Row(

                              mainAxisAlignment:
                              MainAxisAlignment.center,

                              children: [

                                Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                SizedBox(width: 10),

                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// REGISTER
                        Row(

                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [

                            const Text(

                              'Chưa có tài khoản? ',

                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),

                            GestureDetector(

                              onTap: () {

                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RegisterAppExpenseScreen(),
                                  ),
                                );
                              },

                              child: const Text(

                                'Đăng ký ngay',

                                style: TextStyle(

                                  fontSize: 18,

                                  color:
                                  Color(0xff0077B6),

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),





                ],
              ),
            ),
          )
      ),
    );
  }

  Widget buildTextField({

    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,

    String? errorText,

  }) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(

          label,

          style: const TextStyle(

            fontSize: 16,

            fontWeight: FontWeight.bold,

            color: Color(0xff5B6770),
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(

          controller: controller,

          keyboardType: TextInputType.phone,

          decoration: InputDecoration(

            filled: true,

            fillColor:
            const Color(0xffF1F5F9),

            hintText: hint,

            errorText: errorText,

            prefixIcon: Icon(icon),

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

  Widget buildPasswordField() {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Row(

          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: [

            const Text(

              'Mật khẩu',

              style: TextStyle(

                fontSize: 16,

                fontWeight: FontWeight.bold,

                color: Color(0xff5B6770),
              ),
            ),

            GestureDetector(

              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ForgetPasswordScreen(),
                    )
                );
              },

              child: const Text(

                'Quên mật khẩu?',

                style: TextStyle(

                  fontSize: 16,

                  color: Color(0xff0077B6),

                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 12),

        TextFormField(

          controller: passwordController,

          obscureText: hidePassword,

          decoration: InputDecoration(

            filled: true,

            fillColor:
            const Color(0xffF1F5F9),

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