import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  // initialising firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
// onbgmsg is used to handle message for background msg
  FirebaseMessaging.onBackgroundMessage(_handleMessage);

  runApp(MyApp());
}

Future<void> _handleMessage(RemoteMessage message) async {  
  print('background msg is ${message.notification!.body}');
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

// initialise
    messaging = FirebaseMessaging.instance;

// get token from the initialisation
    messaging.getToken().then((value) => print('token is: $value'));
// use event to read the message. can be anything
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print('message received');
      print('message is: ${event.notification!.body}');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Notification from firebase.'),
                content: Text(event.notification!.body!),
                actions: [
                  TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcom',
            ),
            Text('',
            ),
          ],
        ),
      ),
    );
  }
}
