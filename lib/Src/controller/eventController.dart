import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class EventController extends GetxController {
  var pastEvents = [].obs;
  var liveEvents = [].obs;
  var upcomingEvents = [].obs;

  fetchAll() async {
    if (await fetchPastEvents() == true) {
      if (await fetchLiveEvents() == true) {
        if (await fetchUpcomingEvents() == true) {
          return true;
        }
      }
    }
  }

  fetchPastEvents() async {
    var response = await http
        // .get(Uri.parse('https://devanthosting.com/poll/api/past-events'));
        .get(Uri.parse('https://farzacademy.com/farz-poll/api/past-events'));
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      pastEvents.value = parse['past_events'];
      return true;
    }
  }

  fetchLiveEvents() async {
    var response = await http
        // .get(Uri.parse('https://devanthosting.com/poll/api/live-events'));
        .get(Uri.parse('https://farzacademy.com/farz-poll/api/live-events'));
        // .get(Uri.parse('http://192.168.1.44/farz-poll/api/live-events'));
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      liveEvents.value = parse['live_events'];
      return true;
    }
  }

  late WebSocketChannel channel;
  void setupWebSocket() {
    channel = IOWebSocketChannel.connect('wss://farzacademy.com/farz-poll/api/live-events');

    channel.stream.listen((event) {
      // Handle real-time updates
      // setState(() {
      //   liveData.add(json.decode(event));
      // });
      var parse = jsonDecode(event);
      liveEvents.value = parse['live_events'];
      print(event);
    },
      onDone: () {
        // Handle WebSocket connection closed
        print('WebSocket Connection Closed');
      },
      onError: (error) {
        // Handle WebSocket error
        print('WebSocket Error: $error');
      },
    );
  }

  disposeAll(){
    channel.sink.close();
  }

  fetchUpcomingEvents() async {
    var response = await http.get(
        // Uri.parse('https://devanthosting.com/poll/api/upcoming-events'));
        Uri.parse('https://farzacademy.com/farz-poll/api/upcoming-events'));
    if (response.statusCode == 200) {
      var parse = jsonDecode(response.body);
      upcomingEvents.value = parse['upcoming_events'];
      return true;
    }
  }
}
