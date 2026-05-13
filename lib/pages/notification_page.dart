import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/api_helpers.dart';

class NotificationPage extends StatefulWidget{
  final int userId;

  NotificationPage({super.key, required this.userId,});
  @override
  State<StatefulWidget> createState() {
    return NotificationPageState();
  }
}

class NotificationPageState extends State<NotificationPage>{
  List notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadNotifications();
  }

  Future loadNotifications() async {
    notifications =
    await ApiHelpers.getNotifications(
      widget.userId,
    );
    setState(() {
      isLoading = false;
    });
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
          'Thông báo',
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


      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : notifications.isEmpty
          ? const Center(
        child: Text(
          'Chưa có thông báo',
        ),
      )

          : ListView.builder(
        padding:
        const EdgeInsets.all(16),
        itemCount:
        notifications.length,
        itemBuilder: (context, index){
          var item =
          notifications[index];
          return Container(
            margin:
            const EdgeInsets.only(
              bottom: 15,
            ),

            padding:
            EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(20),
            ),

            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                  const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                    Colors.blue.shade50,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),

                  child: const Icon(
                    Icons.notifications,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        item['title']?.toString() ?? '',

                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        item['message']?.toString() ?? '',

                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        item['time']?.toString() ?? '',

                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}