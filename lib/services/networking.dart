import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkHelper{
  final String url;
  NetworkHelper(this.url);

  Future getData() async{
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode==200){
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw '😦';
      }
    } catch (e) {
      throw '😦';
    }
  }

  Future postData(Object body, {Map<String, String>? headers}) async{
    try {
      http.Response response = await http.post(Uri.parse(url), body: body, headers: headers);
      if (response.statusCode == 201 || response.statusCode == 200){
        // response.statusCode => 201 => Created
        // response.statusCode => 200 => Get -> Already exist.

        return jsonDecode(response.body);
      } else {
        // response.statusCode => 400 Bad Request

        return 'Bad Request';
      }

    } catch (e) {
      throw '😦'+e.toString();
    }
  }

  Future patchData(Map<String, String>? headers, Object body) async{
    try {
      http.Response response = await http.patch(Uri.parse(url), headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 201){
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        // response.statusCode => 401 Unauthorized
        // response.statusCode => 400 Bad Request
        return 'Bad Request or Unauthorized';
      }
    } catch (e) {
      throw '😦';
    }
  }
}