// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ApiClient {
//   final Map<String, String> headers;
//   ApiClient({this.headers = const {}});

//   Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body) async {
//     final response = await http.post(Uri.parse(url), body: body, headers: headers);
//     return json.decode(response.body);
//   }

//   Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers}) async {
//     final response = await http.get(Uri.parse(url), headers: headers);
//     return json.decode(response.body);
//   }
// }
