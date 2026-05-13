import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/api_helpers.dart';
import '../pages/notification_page.dart';
import '../pages/setting_page.dart';

class MainAppScreen extends StatefulWidget{
  final Map<String, dynamic> user;

 MainAppScreen({
    super.key,
    required this.user,
  });
  @override
  State<StatefulWidget> createState() {
    return MainAppState();
  }
}

class MainAppState extends State<MainAppScreen>{
  int notificationCount = 0;
  int currentMenuItemIndex = 0;

  @override
  void initState() {
    super.initState();
    loadNotificationCount();
  }

  Future<void> loadNotificationCount() async {
    List data = await ApiHelpers.getNotifications(
      widget.user['id'],
    );

    setState(() {
      notificationCount = data.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            /// avatar
            GestureDetector(
              onTap: () {
                if(widget.user['avatar'] != null &&
                    widget.user['avatar']
                        .toString()
                        .isNotEmpty){
                  showDialog( // coi full ảnh
                    context: context,
                    builder: (_) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: InteractiveViewer(
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(20),
                            child: Image.network(
                              widget.user['avatar'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              child: CircleAvatar(
                radius: 16, // chỉnh ảnh nhỏ lại
                backgroundColor:
                Colors.grey.shade200,
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
                widget.user['avatar'] == null ||
                    widget.user['avatar']
                        .toString()
                        .isEmpty
                    ? const Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.grey,
                )
                    : null,
              ),
            ),

            const SizedBox(width: 10),
            /// username
            Expanded(
              child: Text(
                widget.user['full_name']
                    ?? 'Người dùng',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        actions: [
          //notification
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationPage(
                    userId: widget.user['id'],
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),

                /// badge số lượng thông báo
                Positioned(
                  right: 0,
                  top: 0,
                  child: notificationCount > 0
                      ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: SafeArea(
          child: buildBody(),
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Thêm danh mục", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) async {
          if (value == 4) { // index của SettingPage
            var newAvatar = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingPage(user: widget.user)),
            );
            if (newAvatar != null) {
              setState(() {
                widget.user['avatar'] = newAvatar;
              });
            }
          } else {
            setState(() {
              currentMenuItemIndex = value;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: currentMenuItemIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Sổ thu chi'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Ví của tôi'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 35), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Báo cáo'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),




    );
  }

  Widget buildBody() {

    if(currentMenuItemIndex == 0){
      return const Center(
        child: Text(
          'Trang Sổ thu chi',
        ),
      );
    }

    if(currentMenuItemIndex == 1){
      return const Center(
        child: Text(
          'Trang Ví của tôi',
        ),
      );
    }

    if(currentMenuItemIndex == 2){
      return const Center(
        child: Text(
          'Trang Thêm',
        ),
      );
    }

    if(currentMenuItemIndex == 3){
      return const Center(
        child: Text(
          'Trang Báo cáo',
        ),
      );
    }

    return SettingPage(user: widget.user);
  }
}