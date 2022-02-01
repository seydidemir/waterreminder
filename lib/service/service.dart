import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:waterreminder/utils/helper.dart';

class Service {
  static String apiURL = 'http://wr.albasoftmar.com/api/';
  static String token;

  static dynamic login(String email, String password) async {
    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse(apiURL + 'login'),
        body: {
          "email": email,
          "password": password,
        },
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      var jresponse = json.decode(response.body);

      if (jresponse != null && jresponse['status'] == 1) {
        Service.token = jresponse['result']['Token'];
        Helper.user = jresponse['result'];
        Helper.setShared('token', Service.token);
      }

      return jresponse;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  static dynamic register(
    String name,
    String surname,
    String email,
    String password,
    DateTime birthDate,
    String gender,
    String phone,
  ) async {
    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse(apiURL + 'register'),
        body: {
          "name": name + surname,
          "email": email,
          "password": password,
          "phone": phone,
          "gender": gender,
          "birthday": '$birthDate'
        },
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      var jresponse = json.decode(response.body);

      if (jresponse != null && jresponse['status'] == 1) {
        Service.token = jresponse['result']['Token'];
        Helper.user = jresponse['result'];
        Helper.setShared('token', Service.token);
        Helper.setShared('user', Helper.user);
      }

      return jresponse;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  static dynamic updateProfile(
    String name,
    String surname,
    String email,
    String phone,
  ) async {
    var client = http.Client();

    try {
      var response = await client.post(
        Uri.parse('https://erandevu.gaziantepbilisim.com.tr/api/customer'),
        body: {
          "name": name,
          "surname": surname,
          "email": email,
          "phone": phone,
          "token": Service.token,
        },
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      var jresponse = json.decode(response.body);

      return jresponse;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  static dynamic profile() async {
    var client = http.Client();
    try {
      var response = await client.post(
        Uri.parse('https://erandevu.gaziantepbilisim.com.tr/api/login'),
        body: {
          "token": Service.token,
        },
        headers: {
          'Accept': 'application/json',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }
}
