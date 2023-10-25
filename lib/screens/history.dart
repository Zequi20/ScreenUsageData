import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_state/screen_state.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class ScreenStateEventEntry {
  ScreenStateEvent event;
  DateTime? time;

  ScreenStateEventEntry(this.event) {
    time = DateTime.now();
  }
}

class _HistoryScreenState extends State<HistoryScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("data");

  final Screen _screen = Screen();
  StreamSubscription<ScreenStateEvent>? _subscription;
  bool started = false;
  final List<ScreenStateEventEntry> _log = [];
  var isUnlocked = 0;

  @override
  void initState() {
    startListening();
    super.initState();
  }

  void startListening() {
    try {
      _subscription = _screen.screenStateStream!.listen(_onData);
      setState(() => started = true);
    } on ScreenStateException catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
    }
  }

  void _onData(ScreenStateEvent event) async {
    setState(() {
      _log.add(ScreenStateEventEntry(event));
    });
    if (event == ScreenStateEvent.SCREEN_ON) {
      isUnlocked = 0;
      if (kDebugMode) {
        print("PANTALLA ENCENDIDA");
        var newDataRef = ref.push();
        List dateTime = _log.last.time.toString().substring(0, 19).split(' ');
        await newDataRef.set({
          "action": "PANTALLA ENCENDIDA",
          "date": dateTime[0],
          "time": dateTime[1],
        });
      }
    } else if (event == ScreenStateEvent.SCREEN_OFF) {
      if (isUnlocked == 1) {
        if (kDebugMode) {
          print("PANTALLA BLOQUEADA");
          var newDataRef = ref.push();
          List dateTime = _log.last.time.toString().substring(0, 19).split(' ');
          await newDataRef.set({
            "action": "PANTALLA BLOQUEADA",
            "date": dateTime[0],
            "time": dateTime[1],
          });
        }
        isUnlocked = 0;
      } else {
        if (kDebugMode) {
          print("PANTALLA APAGADA(SIN DESBLOQUEAR)");
          var newDataRef = ref.push();
          List dateTime = _log.last.time.toString().substring(0, 19).split(' ');
          await newDataRef.set({
            "action": "PANTALLA APAGADA(SIN DESBLOQUEAR)",
            "date": dateTime[0],
            "time": dateTime[1],
          });
        }
        isUnlocked = 0;
      }
    } else if (event == ScreenStateEvent.SCREEN_UNLOCKED) {
      isUnlocked = 1;
      if (kDebugMode) {
        print("PANTALLA DESBLOQUEADA");
        var newDataRef = ref.push();
        List dateTime = _log.last.time.toString().substring(0, 19).split(' ');
        await newDataRef.set({
          "action": "PANTALLA DESBLOQUEADA",
          "date": dateTime[0],
          "time": dateTime[1],
        });
      }
    }
  }

  void stopListening() {
    _subscription?.cancel();
    setState(() => started = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Screen usage data collector',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: _log.length,
              reverse: true,
              itemBuilder: (BuildContext context, int idx) {
                final entry = _log[idx];
                return ListTile(
                    leading: Text(entry.time.toString().substring(0, 19)),
                    trailing: Text(entry.event.toString().split('.').last));
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: started ? stopListening : startListening,
        tooltip: 'Start/Stop Listening',
        child: started ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
      ),
    );
  }
}
