import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:softrack/JsonModels/note_model.dart';
import 'package:softrack/JsonModels/users.dart';

import '../JsonModels/comp_details.dart';
import '../JsonModels/create_comp.dart';
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class SupaBaseDatabaseHelper {

  final supabaseUrl = 'YOUR_SUPABASE_URL'; // Replace with your Supabase URL
  final supabaseKey = 'YOUR_SUPABASE_KEY'; // Replace with your Supabase Key
  final authkey = 'YOUR_AUTH_KEY'; // Replace with your Auth Key same as YOUR_SUPABASE_KEY

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'apikey': supabaseKey,
    'Authorization': authkey,
  };

  // Login Method
  Future<bool> login(Users user) async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/login?username=eq.${user.usrUserName}&password=eq.${user.usrPassword}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final updateResponse = await http.patch(
          Uri.parse('$supabaseUrl/rest/v1/login?username=eq.${user.usrUserName}&password=eq.${user.usrPassword}'),
          headers: headers,
          body: jsonEncode({'active_status': user.usrActive}), // Use usrActive field for 'Remember Me'
        );

        if (updateResponse.statusCode == 204) { // 204 means the update was successful
          return true;
        } else {
          print('Failed to update active_status: ${updateResponse.body}');
          return false;
        }
      } else {
        return false;
      }
    } else {
      print(response.body);
      return false;
    }
  }
  // checking User's Existing by username
  Future<String?> checkUserExists(String email, String phone, String username) async {
    final emailResponse = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/login?email=eq.$email'),
      headers: headers,
    );
    final phoneResponse = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/login?phone=eq.$phone'),
      headers: headers,
    );
    final usernameResponse = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/login?username=eq.$username'),
      headers: headers,
    );
    if (emailResponse.statusCode == 200 && jsonDecode(emailResponse.body).isNotEmpty) {
      return 'Email already exists';
    }
    if (phoneResponse.statusCode == 200 && jsonDecode(phoneResponse.body).isNotEmpty) {
      return 'Phone number already registered';
    }
    if (usernameResponse.statusCode == 200 && jsonDecode(usernameResponse.body).isNotEmpty) {
      return 'Username already taken';
    }
    return null; // No matches found
  }
  // Checking for Login status and returning the user if found
  Future<Users?> checkLogin(String uid) async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/login?id=eq.$uid'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        Users user = Users.fromMap(data.first);
        // print('Database UUID: ${user.usrId}');
        return user;
      }
      return null;
    } else {
      print(response.body);
      return null;
    }
  }

  Future<int> updateStatus(String uid) async {
    try {
      final response = await http.get(
        Uri.parse('$supabaseUrl/rest/v1/login?id=eq.$uid'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          Users user = Users.fromMap(data.first);
          String status = user.usrActive.split("/")[0] == "1"
              ? "0/${user.usrActive.split("/")[1]}"
              : user.usrActive;

          print('usrActive: ${user.usrActive}');
          print('status: $status');

          final patchResponse = await http.patch(
            Uri.parse('$supabaseUrl/rest/v1/login?id=eq.$uid'),
            headers: headers,
            body: jsonEncode({'active_status': status}),
          );

          if (patchResponse.statusCode == 204) {
            return 1; // Indicate success
          } else {
            print('Error updating status: ${patchResponse.statusCode} - ${patchResponse.body}');
            return -1; // Indicate error
          }
        } else {
          print('User not found for uid: $uid');
          return -1; // Indicate user not found
        }
      } else {
        print('Error fetching user: ${response.statusCode} - ${response.body}');
        return -1; // Indicate error fetching user
      }
    } catch (e) {
      print('Exception occurred: $e');
      return -1; // Indicate exception error
    }
  }
  // checking and pushing
  Future<bool> checked(String uid) async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/login?id=eq.$uid'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data.isNotEmpty;
    } else {
      print(response.body);
      return false;
    }
  }
  // Sign up
  Future<int> signup(Users user) async {
    final response = await http.post(
      Uri.parse('$supabaseUrl/rest/v1/login'),
      headers: headers,
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode == 201) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  // CRUD Methods---------------------------------------------------------------------------------------------------------
  // Get User Method
  Future<Users?> getUser(String usrName) async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/login?username=eq.$usrName'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return Users.fromMap(data.first);
      }
      return null;
    } else {
      print(response.body);
      return null;
    }
  }
  // Search Method
  Future<List<NoteModel>> searchNotes(String keyword, String username) async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/inv?or=(noteTitle.ilike.%25$keyword%25,to.ilike.%25$keyword%25)&username=eq.$username'), // Filter by keyword and username
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => NoteModel.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }
  // Create Note
  Future<int> createNote(NoteModel note) async {
    final response = await http.post(
      Uri.parse('$supabaseUrl/rest/v1/inv'),
      headers: headers,
      body: jsonEncode(note.toMap()),
    );

    if (response.statusCode == 201) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  // Get notes
  Future<List<NoteModel>> getNotes() async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/inv'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => NoteModel.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }
  // getting notes by username
  Future<List<NoteModel>> getNotesByUsername(String username) async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/inv?username=eq.$username'), // Update the query to filter by username
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => NoteModel.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }
  // Delete Notes
  Future<int> deleteNote(String id, String username) async {
    final response = await http.delete(
      // Uri.parse('$supabaseUrl/rest/v1/inv?noteId=eq.$id'),
      Uri.parse('$supabaseUrl/rest/v1/inv?noteId=eq.$id&username=eq.$username'), // Ensure the username matches
      headers: headers,
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  // Update Notes
  Future<int> updateNote(String title, String content, String Id, String username) async {
    final response = await http.patch(
      // Uri.parse('$supabaseUrl/rest/v1/inv?noteId=eq.$Id'),
      Uri.parse('$supabaseUrl/rest/v1/inv?noteId=eq.$Id&username=eq.$username'), // Ensure the username matches
      headers: headers,
      body: jsonEncode({'noteTitle': title, 'noteContent': content}),
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  // create companyKey
  Future<int> createComp(CreateComp comp) async {
    final response = await http.post(
      Uri.parse('$supabaseUrl/rest/v1/devices'),
      headers: headers,
      body: jsonEncode(comp.toMap()),
    );

    if (response.statusCode == 201) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  // getting company key by username
  Future<List<CreateComp>> getCompKeyByUsername(String username, String usrType) async {
    final http.Response response;
    if(usrType.split("/")[1] == "administrator"){
      response = await http.get(
        Uri.parse('$supabaseUrl/rest/v1/devices'), // Update the query to filter by username
        headers: headers,
      );
    }else{
      response = await http.get(
        Uri.parse('$supabaseUrl/rest/v1/devices?username=eq.$username'), // Update the query to filter by username
        headers: headers,
      );
    }

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CreateComp.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }
  // getting company key by username
  Future<List<CreateComp>> getCompData(String name, String phone) async {
    final http.Response response;
    // if(usrType.split("/")[1] == "administrator"){
    //   response = await http.get(
    //     Uri.parse('$supabaseUrl/rest/v1/devices'), // Update the query to filter by username
    //     headers: headers,
    //   );
    // }else{
      response = await http.get(
        Uri.parse('$supabaseUrl/rest/v1/devices?name=eq.$name&phone=eq.$phone'), // Update the query to filter by username
        headers: headers,
      );
    // }

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CreateComp.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }
  // getting recent company data
  Future<List<CreateComp>> getRecentCompKeys() async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/devices?order=createdAt.desc&limit=10'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => CreateComp.fromMap(json)).toList();
    } else {
      print(response.body);
      return [];
    }
  }
  // Delete companyKey
  Future<int> deleteCompKey(String id, String username) async {
    final response = await http.delete(
      Uri.parse('$supabaseUrl/rest/v1/devices?id=eq.$id&username=eq.$username'), // Ensure the username matches
      headers: headers,
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  // generating company key
  String _generateCompanyKey(String shopName) {
    const length = 10;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final buffer = StringBuffer();
    final shopNameChars = shopName.codeUnits.map((e) => chars[e % chars.length]).take(5).toList();
    buffer.writeAll(shopNameChars);

    while (buffer.length < length) {
      buffer.write(chars[random.nextInt(chars.length)]);
    }
    return buffer.toString();
  }
  // Update companyKey
  Future<int> updateCompKey(String name, String shop, String email, String phone, String aadhaar,String Id, String username) async {
    String compKey = _generateCompanyKey(shop);
    final response = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/devices?id=eq.$Id&username=eq.$username'), // Ensure the username matches
      headers: headers,
      body: jsonEncode({'name': name, 'shop_name': shop, 'email': email, 'phone': phone, 'aadhar_no': aadhaar, 'comp_key':compKey}),
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  // Search Method
  Future<List<CreateComp>> searchCompKey(String keyword, String username, String usrType) async {
    final http.Response response;
    if(usrType.split("/")[1] == "administrator"){
      response = await http.get(
        Uri.parse('$supabaseUrl/rest/v1/devices?name=ilike.%$keyword%'), // Filter by keyword and username
        headers: headers,
      );
    }else{
      response = await http.get(
        Uri.parse('$supabaseUrl/rest/v1/devices?name=ilike.%$keyword%&username=eq.$username'), // Filter by keyword and username
        headers: headers,
      );
    }

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CreateComp.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }
  // Update companyKey
  Future<int> resetPasswordCompKey(String username, String password) async {
    final response = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/login?username=eq.$username'), // Ensure the username matches
      headers: headers,
      body: jsonEncode({'password': password}),
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  //updating User
  Future<int> updateUser(String name, String email, String password, String phone, String username) async {
    final response = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/login?username=eq.$username'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  //updating phone number
  Future<int> updateUserPhone(String email, String phone, String username) async {
    final response = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/login?username=eq.$username&email=eq.$email'),
      headers: headers,
      body: jsonEncode({
        'phone': phone,
      }),
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  //updating password
  Future<int> updateUserPassword(String email, String password, String username) async {
    final response = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/login?username=eq.$username&email=eq.$email'),
      headers: headers,
      body: jsonEncode({
        'password': password,
      }),
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
  // get company details
  Future<List<CompDetails>> getCompDetails(String username, String name, String shop, String phone) async {
    final response = await http.get(
      Uri.parse('$supabaseUrl/rest/v1/registration?username=eq.$username&name=eq.$name&shop_name=eq.$shop&contact=eq.$phone'), // Update the query to filter by username
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CompDetails.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }
  // getting usernames
  Future<List<CompDetails>> getUsernames(String username, String userType) async {
    final uri = (userType.split("/")[1] == "administrator")
        ? Uri.parse('$supabaseUrl/rest/v1/devices')
        : Uri.parse('$supabaseUrl/rest/v1/devices?username=eq.$username');

    final response = await http.get(uri, headers: headers);
    // final response = await http.get(
    //   Uri.parse('$supabaseUrl/rest/v1/devices?username=eq.$username'),
    //   headers: headers,
    // );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CompDetails.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }
  // updating services
  Future<int> updateService(String Id, String value, String date) async {
    final response = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/devices?id=eq.${Uri.encodeComponent(Id)}'),
      headers: headers,
      body: jsonEncode({
        'NoOfDays': value,
        'createdAt': date
      }),
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print("Failed to update. Error: ${response.body}");
      return -1; // Indicate error
    }
  }
  //Upgrading services
  Future<int> upGradeService(String Id, String days, String status, String paidAmt, CreateComp compData) async {

    List<String> noOfDaysParts = compData.usrNoOfDays.split("/");
    int currentDays = int.tryParse(noOfDaysParts[0]) ?? 0; // "365/active/0"
    int additionalDays = int.tryParse(days.split("/")[1]) ?? 0; // 95/90
    int spent = int.tryParse(days.split("/")[0]) ?? 0;
    int totalDays = currentDays + (additionalDays + 5); // 460
    int amount = (int.tryParse(paidAmt) ?? 0) + (int.tryParse(compData.usrPaidAmt) ?? 0);
    String value= "$spent/$totalDays/${noOfDaysParts[1]}/${noOfDaysParts[2]}"; // "95/460/active/5"

    final response = await http.patch(
      Uri.parse('$supabaseUrl/rest/v1/devices?id=eq.${Uri.encodeComponent(Id)}'),
      headers: headers,
      body: jsonEncode({
        'service_type': compData.usrServiceType,
        'users_count': compData.usrUsersCount,
        'NoOfDays': value,
        'paid_amt': amount,
        // 'createdAt': date
      }),
    );

    if (response.statusCode == 204) {
      return 1; // Success
    } else {
      print('Error: ${response.body}');
      return -1; // Error
    }
  }

  Future<List<Users>> getUsers(String username, String userType) async {
    final uri = (userType.split("/")[1] == "administrator")
        ? Uri.parse('$supabaseUrl/rest/v1/login?username=neq.$username')
        : Uri.parse('$supabaseUrl/rest/v1/login?username=eq.$username');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Users.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }

  Future<List<CreateComp>> getDistributorsData(String username, String userType) async {
    final uri = (userType.split("/")[1] == "administrator")
        ? Uri.parse('$supabaseUrl/rest/v1/devices?username=neq.$username')
        : Uri.parse('$supabaseUrl/rest/v1/devices?username=eq.$username');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CreateComp.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }

  Future<List<Users>> searchUsers(String keyword, String username, String userType) async {
    final uri = (userType.split("/")[1] == "administrator")
        ? Uri.parse('$supabaseUrl/rest/v1/login?name=ilike.%$keyword%&username=neq.$username')
        : Uri.parse('$supabaseUrl/rest/v1/login?name=ilike.%$keyword%&username=eq.$username');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Users.fromMap(e)).toList();
    } else {
      print(response.body);
      return [];
    }
  }

  Future<int> deleteDistributor(String id, String username) async {
    final response = await http.delete(
      Uri.parse('$supabaseUrl/rest/v1/login?id=eq.$id&username=eq.$username'), // Ensure the username matches
      headers: headers,
    );

    if (response.statusCode == 204) {
      return 1; // Indicate success
    } else {
      print(response.body);
      return -1; // Indicate error
    }
  }
}
