import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class QuizController extends GetxController {
  var pastQuestions = [].obs;
  var liveQuestions = [].obs;
  var results = [].obs;
  var userWiseAnswer = [].obs;
  var result = [].obs;
  var pieChartData = {};
  var eventId = 0.obs;

  fetchPastQuestionAndResult(String id) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/get_result'),
        Uri.parse('https://farzacademy.com/farz-poll/api/get_result'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({"event_id": id}));
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      if (parse['question_result'].length == 0) {
        return {"result": "Questions are Empty"};
      } else {
        pastQuestions.value = parse['question_result'];
        return {"result": "success"};
      }
    } else {
      return {"result": "Error"};
    }
  }

  fetchTodaysQuiz(var id) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/todays_question'),
        Uri.parse('https://farzacademy.com/farz-poll/api/todays_question'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "event_id": id,
        }));
    if (response.statusCode == 200) {
      print(response.body);
      var parse = jsonDecode(response.body);
      liveQuestions.value = parse['todays_question'];
      if (parse['todays_question'].length == 0) {
        return {"result": "success"};
      } else {
        liveQuestions.value = parse['todays_question'];
        return {"result": "success"};
      }
    } else {
      return {"result": "Error"};
    }
  }

  fetchLiveQuizNew({required String event_id, required String episodeID}) async {
    var response = await http.post(
      // Uri.parse('https://devanthosting.com/poll/api/todays_question'),
        Uri.parse('https://farzacademy.com/farz-poll/api/todays_question'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "event_id": eventId,
          "episodId": episodeID,
        }));
    if (response.statusCode == 200) {
      print(response.body);
      var parse = jsonDecode(response.body);
      liveQuestions.value = parse['todays_question'];
      if (parse['todays_question'].length == 0) {
        return {"result": "success"};
      } else {
        liveQuestions.value = parse['todays_question'];
        return {"result": "success"};
      }
    } else {
      return {"result": "Error"};
    }
  }

  fetchResults(String id) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/get_result'),
        Uri.parse('https://farzacademy.com/farz-poll/api/get_result'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({"event_id": id}));
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);

      if (parse['question_result'].length == 0) {
        return {"result": "Questions are Empty"};
      } else {
        results.value = parse['question_result'];
        print(pastQuestions);
        return {"result": "success"};
      }
    } else {
      return {"result": "Error"};
    }
  }

  fetchAnswerWiseQuestion(Map data) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/user_wise_answer'),
        Uri.parse('https://farzacademy.com/farz-poll/api/user_wise_answer'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      userWiseAnswer.value = parse['user_wise_answer'];
      return {'result': "success"};
    } else {
      return {"result": "error"};
    }
  }

  fetchPieChartData(Map data) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/answer_pi_chart'),
        Uri.parse('https://farzacademy.com/farz-poll/api/answer_pi_chart'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      pieChartData = {
        "correct": parse['total_right_aswer_percentage'],
        "wrong": parse['total_wrong_aswer_percentage']
      };
      return {'result': "success"};
    } else {
      return {"result": "error"};
    }
  }

  submitAnswer(Map data) async {
    var response = await http.post(
        // Uri.parse('https://devanthosting.com/poll/api/answer_submit'),
        Uri.parse('https://farzacademy.com/farz-poll/api/answer_submit'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      return {"result": "success", "data": parse};
    } else {
      return {"result": "error"};
    }
  }
}
