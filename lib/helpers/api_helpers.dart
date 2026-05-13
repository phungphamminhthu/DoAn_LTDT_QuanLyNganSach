import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class ApiHelpers {
  static const String baseUrl = 'https://expense-api-i4so.onrender.com';
  //địa chỉ gốc để chạy database
  // khởi tạo database
  Future<Database> initDB() async{
    var dbPath = (await getApplicationDocumentsDirectory()).path + '/expense_manager.db';

    return openDatabase(
        dbPath,
        version: 2, //tăng version lên nếu có thay dổi database và đã chạy csdl rồi
        onCreate: (db, _) async {
          // USERS
          await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY,
          username TEXT,
          email TEXT,
          phone TEXT,
          password TEXT,
          full_name TEXT,
          avatar TEXT
        )
        ''');

          // WALLETS
          await db.execute('''
        CREATE TABLE wallets(
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          name TEXT,
          type TEXT,
          balance REAL,
          currency TEXT,
          color TEXT,
          icon TEXT,
          is_default INTEGER
        )
        ''');

          // CATEGORIES
          await db.execute('''
        CREATE TABLE categories(
          id INTEGER PRIMARY KEY,
          name TEXT,
          type TEXT,
          icon TEXT,
          color TEXT
        )
        ''');

          // TRANSACTIONS
          await db.execute('''
        CREATE TABLE transactions(
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          wallet_id INTEGER,
          category_id INTEGER,
          amount REAL,
          type TEXT,
          note TEXT,
          transaction_date TEXT
        )
        ''');

          // BUDGETS
          await db.execute('''
        CREATE TABLE budgets(
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          category_id INTEGER,
          wallet_id INTEGER,
          amount REAL,
          spent_amount REAL,
          period_type TEXT,
          period_start TEXT,
          period_end TEXT
        )
        ''');

          // GOALS
          await db.execute('''
        CREATE TABLE goals(
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          name TEXT,
          target_amount REAL,
          current_amount REAL,
          deadline TEXT,
          status TEXT
        )
        ''');

          // RECEIPTS
          await db.execute('''
        CREATE TABLE receipts(
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          image_path TEXT,
          ocr_text TEXT,
          merchant_name TEXT,
          detected_amount REAL,
          receipt_date TEXT
        )
        ''');

          // NOTIFICATIONS
          await db.execute('''
        CREATE TABLE notifications(
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          title TEXT,
          message TEXT,
          time TEXT,
          is_read INTEGER
        )
        ''');

          // OTP
          await db.execute('''
        CREATE TABLE otps(
          id INTEGER PRIMARY KEY,
          user_id INTEGER,
          code TEXT,
          expires_at TEXT,
          is_used INTEGER
        )
        ''');

        }
    );
  }


//lấy api users
  static Future<List<dynamic>> getUser() async{
    try{
      var res = await http.get(Uri.parse('$baseUrl/users'),
      );
      return jsonDecode(res.body);
    } catch(e){
      return [];
    }
  }

  // đăng ký
  static Future<bool> registerUser({

    required String fullName,
    required String phone,
    required String password,

  }) async {

    try {

      var res = await http.post(

        Uri.parse('$baseUrl/users'),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({

          "full_name": fullName.trim(),

          "phone": phone.trim(),

          "password": password.trim(),

          // avatar mặc định
          "avatar":
          "https://i.pravatar.cc/300",

        }),
      );

      return res.statusCode == 201;

    } catch(e) {

      print(e);

      return false;
    }
  }

  //đăng  nhập
  static Future<Map<String, dynamic>?> loginUser({
    required String phone,
    required String password,
  }) async {
    try {

      var res = await http.get(
        Uri.parse(
          '$baseUrl/users?phone=$phone&password=$password',
        ),
      );

      List data = jsonDecode(res.body);

      if(data.isNotEmpty){

        return data.first;

      }

      return null;

    } catch(e){

      return null;
    }
  }
  // cập nhật thông tin user
  static Future<bool> updateProfile({

    required int userId,
    required String fullName,
    required String phone,
    required String email,

  }) async {

    try {

      var res = await http.patch(

        Uri.parse('$baseUrl/users/$userId'),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({

          "full_name": fullName,
          "phone": phone,
          "email": email,

        }),
      );

      return res.statusCode == 200;

    } catch(e) {

      return false;
    }
  }

  // Kiểm tra số điện thoại có tồn tại
  static Future<Map<String, dynamic>?> checkPhoneExists(String phone) async {
    try {
      var res = await http.get(Uri.parse('$baseUrl/users?phone=$phone'));
      List data = jsonDecode(res.body);
      if (data.isNotEmpty) {
        return data.first; // trả về user object
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Sinh OTP ngẫu nhiên 4 số
  static String generateOtp() {
    var rng = Random();
    return (rng.nextInt(9000) + 1000).toString();

  }

  // Gửi OTP lên API
  static Future<String?> sendOtp(int userId) async {
    String code = generateOtp();
    try {
      var res = await http.post(
        Uri.parse('$baseUrl/otps'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "code": code,
          "expires_at": DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
          "is_used": 0
        }),
      );
      if(res.statusCode == 201){
        return code; // trả OTP về
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Xác thực OTP
  static Future<bool> verifyOtp(int userId, String code) async {
    try {
      var res = await http.get(
        Uri.parse('$baseUrl/otps?user_id=$userId&code=$code&is_used=0'),
      );
      List data = jsonDecode(res.body);
      return data.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Cập nhật mật khẩu mới
  static Future<bool> updatePassword(int userId, String newPassword) async {
    try {
      var res = await http.patch(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"password": newPassword}),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updatePassword_v2(
      int userId,
      String oldPassword,
      String newPassword,
      ) async {
    try {
      var res = await http.put(
        Uri.parse('$baseUrl/users/$userId/password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  /// lấy thông báo theo user
  static Future<List<dynamic>> getNotifications(int userId,) async {
    try {
      var res = await http.get(
        Uri.parse(
          '$baseUrl/notifications?user_id=$userId',
        ),
      );
      return jsonDecode(res.body);
    } catch(e) {
      return [];
    }
  }
  //thêm thông báo khi giao dịch
  static Future<void> addNotification({
    required int userId,
    required String title,
    required String message,
  }) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "user_id": userId,
          "title": title,
          "message": message,
          "time": DateTime.now().toString(),
        }),
      );
    } catch(e) {
      print(e);
    }
  }







}