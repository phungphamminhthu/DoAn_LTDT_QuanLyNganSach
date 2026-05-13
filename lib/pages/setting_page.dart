import 'dart:io';

import 'package:doan_quanlychitieu/helpers/api_helpers.dart';
import 'package:doan_quanlychitieu/pages/budget_management_page.dart';
import 'package:doan_quanlychitieu/pages/notification_page.dart';
import 'package:doan_quanlychitieu/pages/password_page.dart';
import 'package:doan_quanlychitieu/pages/profile_page.dart';
import 'package:doan_quanlychitieu/screens/login_app_expense_screen.dart';
import 'package:doan_quanlychitieu/screens/welcom_app_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/reuse_helpers.dart';

class SettingPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const SettingPage({
    super.key,
    required this.user,
  });

  @override
  State<StatefulWidget> createState() {
    return SettingState();
  }
}

class SettingState extends State<SettingPage> {

  bool isDarkMode = false;
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Chụp ảnh"),
              onTap: () {
                Navigator.pop(context);
                pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Chọn từ thư viện"),
              onTap: () {
                Navigator.pop(context);
                pickFromGallery();
              },
            ),
          ],
        );
      },
    );
  }
  //chọn ảnh từ camera
  Future pickFromCamera() async {
    var allow = await ApiHelpers.requestCameraPermission();
    if (!allow) return;

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;
    File file = File(image.path);

    String? url = await ApiHelpers.uploadImage(file); // hàm uploadImage trả về link ảnh

    if (url != null) {
      await ApiHelpers.updateAvatarApi(widget.user['id'], url);
      await ApiHelpers.updateAvatarLocal(widget.user['id'], url);
      setState(() {
        selectedImage = file;
        widget.user['avatar'] = url;
      });

      Navigator.pop(context, url);
    }
  }

  Future pickFromGallery() async {
    var allow = await ApiHelpers.requestMediaPermission();
    if (!allow) return;

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: isDarkMode
              ? const Color(0xff0F172A)
              : const Color(0xffF6F8FB),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xff1E293B)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [

                      /// avatar
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: showImageOptions,

                            child: CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.blue.shade100,

                              backgroundImage: selectedImage != null
                                  ? FileImage(selectedImage!)
                                  : (widget.user['avatar'] != null &&
                                  widget.user['avatar'].toString().isNotEmpty)
                                  ? NetworkImage(widget.user['avatar'])
                                  : null,

                              child: (selectedImage == null &&
                                  (widget.user['avatar'] == null ||
                                      widget.user['avatar'].toString().isEmpty))
                                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                                  : null,
                            ),
                          ),

                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: showImageOptions,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      /// username
                      Text(
                        widget.user['full_name']
                            ?? 'Người dùng',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xff0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      /// sdt
                      Text(
                        widget.user['phone'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // tai khoan
                sectionTitle('Tài khoản'),
                const SizedBox(height: 12),
                buildMenuCard(
                  children: [
                    buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Cá nhân',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_)=> ProfilePage(user: widget.user))
                        );
                      },
                    ),
                    buildDivider(),
                    buildMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Mật khẩu',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_)=> PasswordPage(userId: widget.user['id']))
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                /// quan ly
                sectionTitle('Quản lý'),
                const SizedBox(height: 12),
                buildMenuCard(

                  children: [
                    buildMenuItem(
                      icon:
                      Icons.account_balance_wallet_outlined,
                      title: 'Ngân sách',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => BudgetManagementPage(userId: widget.user['id']))
                        );
                      },
                    ),

                    buildDivider(),
                    buildMenuItem(
                      icon: Icons.notifications_none,
                      title: 'Thông báo',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>ReuseHelpers(
                              title: "Thông báo",
                              description: "Quản lý tài chính quản lý túi tiền",
                              icon: Icons.notifications,
                              color: Colors.blue,
                              nextPage: NotificationPage(userId: widget.user['id']),
                            ),)
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                /// ung dung
                sectionTitle('Ứng dụng'),
                const SizedBox(height: 12),
                buildMenuCard(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),

                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.dark_mode_outlined,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              'Chế độ tối',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff0F172A),
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ),

                          Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              setState(() {
                                isDarkMode = value;
                              });
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),

                /// dang xuat
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.red.shade100,
                      elevation: 0,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    ),

                    onPressed: () async {
                      bool? confirm = await showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text('Đăng xuất'),

                              content: Text('Bạn có chắc muốn đăng xuất không?',),

                              actions: [
                                //nút hủy
                                TextButton(
                                    onPressed: (){
                                      Navigator.pop(context, false);
                                    },
                                    child: Text('Hủy', style: TextStyle(color: Colors.grey),)
                                ),

                                //nút đăng xuất
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child:Text('Đăng xuất',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                      if(confirm == true){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WelcomAppExpenseScreen(),
                          ),
                              (route) => false,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    label: Text(
                      'Đăng xuất',
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
  }

  /// tieu de
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        title,
        style: GoogleFonts.inter(

          fontSize: 13,

          color: isDarkMode
              ? Colors.white70
              : Colors.grey.shade700,

          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  /// card
  Widget buildMenuCard({
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xff1E293B)
            : Colors.white,
        borderRadius:
        BorderRadius.circular(25),
      ),
      child: Column(children: children),
    );
  }

  /// item
  Widget buildMenuItem({

    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding:EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 18,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius:
                BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: isDarkMode
                      ? Colors.white
                      : const Color(0xff0F172A),
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 20,
      endIndent: 20,
    );
  }
}