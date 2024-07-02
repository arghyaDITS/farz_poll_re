import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  var country = [].obs;
  var countrySearchResult = [].obs;
  var state = [].obs;
  var stateSearchResult = [].obs;
  var city = [].obs;
  var citySearchResult = [].obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var token = ''.obs;
  var userId = 0.obs;
  List<String> data = ['country-list', 'state-list', 'city-list'];

  setValue(int eventId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("eventId", eventId);
  }

  emptyValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("eventId", 0987654321);
  }

  getValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value = preferences.getInt("eventId") ?? 0987654321;
    return value;
  }

  countryPoulate() async {
    var response = await http.get(
      // Uri.parse('https://devanthosting.com/poll/api/country-list'),
      Uri.parse('https://farzacademy.com/farz-poll/api/country-list'),
      headers: {"Content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      for (int i = 0; i < parse['all_country'].length; i++) {
        country.add(parse['all_country'][i]);
      }
      return true;
    } else {
      return false;
    }
  }

  searchCountry(String query) {
    if (query == '') {
      countrySearchResult.value = country;
    } else {
      countrySearchResult.value = [];
      for (int i = 0; i < country.length; i++) {
        if (country[i]['name'].contains(query) ||
            country[i]['name'].toLowerCase().contains(query)) {
          countrySearchResult.add(country[i]);
        }
      }
    }
  }

  statePoulate(var data) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/state-list'),
        Uri.parse('https://farzacademy.com/farz-poll/api/state-list'),
        headers: {"Content-type": "application/json"},
        body: data);
    if (response.statusCode == 200) {
      state.value = [];
      var parse = jsonDecode(response.body);
      for (int i = 0; i < parse['all_state'].length; i++) {
        state.add(parse['all_state'][i]);
      }
      return true;
    } else {
      print("Error");
      return false;
    }
  }

  searchState(String query) {
    if (query == '') {
      stateSearchResult.value = state;
    } else {
      stateSearchResult.value = [];
      for (int i = 0; i < state.length; i++) {
        if (state[i]['name'].contains(query) ||
            state[i]['name'].toLowerCase().contains(query)) {
          stateSearchResult.add(state[i]);
        }
      }
    }
  }

  cityPoulate(var data) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/city-list'),
        Uri.parse('https://farzacademy.com/farz-poll/api/city-list'),
        headers: {"Content-type": "application/json"},
        body: data);
    if (response.statusCode == 200) {
      city.value = [];
      var parse = jsonDecode(response.body);
      for (int i = 0; i < parse['all_city'].length; i++) {
        city.add(parse['all_city'][i]);
      }
      return true;
    } else {
      print("Error");
      return false;
    }
  }

  searchCity(String query) {
    if (query == '') {
      citySearchResult.value = city;
    } else {
      citySearchResult.value = [];
      for (int i = 0; i < city.length; i++) {
        if (city[i]['name'].contains(query) ||
            city[i]['name'].toLowerCase().contains(query)) {
          citySearchResult.add(city[i]);
        }
      }
    }
  }

  loginHandler(var data) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/login'),
        Uri.parse('https://farzacademy.com/farz-poll/api/login'),
        headers: {"Content-type": "application/json"},
        body: data);
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      userName.value = parse['success']['name'];
      userEmail.value = parse['success']['email'];
      token.value = parse['success']['token'];
      userId.value = parse['success']['user_id'];
      setValue(parse['success']['user_id']);
      return {"result": "success", "data": parse};
    } else {
      var parse = jsonDecode(response.body);
      return {"result": "failed", "data": parse};
    }
  }

  signupHandler(var data) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/register'),
        Uri.parse('https://farzacademy.com/farz-poll/api/register'),
        headers: {"Content-type": "application/json"},
        body: data);
    print(response.body);
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      userName.value = parse['success']['name'];
      userEmail.value = parse['success']['email'];
      token.value = parse['success']['token'];
      userId.value = parse['success']['user_id'];
      setValue(parse['success']['user_id']);
      return {"result": "success", "data": parse};
    } else {
      var parse = jsonDecode(response.body);
      return {"result": "failed", "data": parse};
    }
  }

  forgotPasswordHandler(var data) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/forgot-password'),
        Uri.parse('https://farzacademy.com/farz-poll/api/forgot-password'),
        headers: {"Content-type": "application/json"},
        body: data);
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      return {"result": "success", "data": parse};
    } else {
      var parse = jsonDecode(response.body);
      return {"result": "failed", "data": parse};
    }
  }
}
