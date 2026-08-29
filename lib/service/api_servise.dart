import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/note_model.dart';

class ApiService {
  static const String baseUrl = "https://todopage.pythonanywhere.com"; // O'zingizning API manzilingiz

  // Bazaga yangi note qo'shish (POST)
  static Future<bool> addNote(NoteModel note) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/todo/add/"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(note.toJson()),
      );

      // Agar server 200 yoki 201 (Created) qaytarsa muvaffaqiyatli saqlandi
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Xatolik kodi: ${response.statusCode}");
        print("Javob: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Ulanishda xatolik: $e");
      return false;
    }
  }

  static Future<bool> deleteNote(String id)async{
    try{
      final response = await http.delete(Uri.parse("$baseUrl/todos/$id"));
      return response.statusCode == 200 || response.statusCode == 204 ;
    } catch(e){
      print("O'chirishda Xatolik: $e");
      return false;
    }

  }


  static Future<bool> editNote(String id, String newTitle) async {
    try {
            final response = await http.patch(
        Uri.parse("$baseUrl/todos/$id/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "title": newTitle,
        }),
      );

      // 3. Qisqa shaklda status kodini tekshirib qaytaramiz
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Xatolik: $e");
      print("Hello4----------------UpdateStatus");
      return false; // Xatolik bo'lsa false qaytaradi
    }
  }



  static Future<bool> updateStatus(String id, String newStatus) async {
    try {
      // 1. await qo'shildi
      // 2. $id o'zgaruvchi sifatida to'g'rilandi
      final response = await http.patch(
        Uri.parse("$baseUrl/todos/$id/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "status": newStatus,
        }),
      );

      // 3. Qisqa shaklda status kodini tekshirib qaytaramiz
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Xatolik: $e");
      print("Hello4----------------UpdateStatus");
      return false; // Xatolik bo'lsa false qaytaradi
    }
  }

  // Bazadan barcha note'larni o'qib olish (GET)
  static Future<List<NoteModel>> fetchNotes() async {
    try {
      // API endpointingiz (masalan: /todo/ yoki /todo/list/)
      final response = await http.get(
        Uri.parse('$baseUrl/todos/'),
      );

      if (response.statusCode == 200) {
        // Serverdan kelgan JSON ro'yxatini parse qilamiz
        List<dynamic> jsonList = jsonDecode(response.body);

        // Har bir JSON obyektini NoteModel'ga o'giramiz
        return jsonList.map((json) => NoteModel.fromJson(json)).toList();
      } else {
        throw Exception("Ma'lumotlarni yuklashda xatolik: ${response.statusCode}");
      }
    } catch (e) {
      print("O'qishda xatolik: $e");
      return []; // Xatolik bo'lsa bo'sh ro'yxat qaytaradi
    }
  }
}