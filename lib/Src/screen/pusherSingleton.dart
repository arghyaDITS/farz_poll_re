// import 'package:pusher_client/pusher_client.dart' as pusher;

// class PusherSingleton {
//   static final PusherSingleton _instance = PusherSingleton._internal();
//   late pusher.PusherClient _pusherClient;

//   factory PusherSingleton() {
//     return _instance;
//   }

//   PusherSingleton._internal() {
//     _initializePusher();
//   }

//   pusher.PusherClient get pusherClient => _pusherClient;

//   Future<void> _initializePusher() async {
//     pusher.PusherOptions options = pusher.PusherOptions(
//       cluster: 'ap2', //YOUR_APP_CLUSTER
//     );

//     _pusherClient = pusher.PusherClient(
//       '5aad5e593ee98e9a3581', //YOUR_APP_KEY
//       options,
//     );

//     await _pusherClient.connect();
//   }

//   void disposePusher() {
//     _pusherClient.disconnect();
//   }
// }
