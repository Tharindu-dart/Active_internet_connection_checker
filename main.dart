import 'dart:async';
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Data Connection Checker",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*The subscription provides events to the listener,
  and holds the callbacks used to handle the events. 
  The subscription can also be used to unsubscribe from the events, 
  or to temporarily pause the events from the stream.*/

  StreamSubscription<DataConnectionStatus> listener;

  var internetStatus = "Unknown";

  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  @override
  void dispose() {
    listener.cancel(); //listener will cancel, when this widget dispose
    super.dispose();
  }

  checkInternet() async {
    // Simple check to see if we have internet
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // Actively listen for status updates
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          internetStatus = "Connectd to the internet";
          print('Data connection is available.');
          //rebuild widget with new status update
          setState(() {});
          break;

        case DataConnectionStatus.disconnected:
          internetStatus = "No Data Connection";
          print('You are disconnected from the internet.');
          //rebuild widget with new status update
          setState(() {});
          break;
      }
    });

    //Close listener after 30 seconds, But ...,
    //If you want to check internet connection "Continously" until this widget
    //dispose , comment or cut below three lines.

    await Future.delayed(Duration(seconds: 30));
    await listener.cancel();
    return await DataConnectionChecker().connectionStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Connection Checker"),
      ),
      body: Container(
        child: Center(
          child: Text("$internetStatus"),
        ),
      ),
    );
  }
}
