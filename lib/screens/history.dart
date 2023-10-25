import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_state/screen_state.dart';
import 'dart:async';

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

  void _onData(ScreenStateEvent event) {
    setState(() {
      _log.add(ScreenStateEventEntry(event));
    });
    if (event == ScreenStateEvent.SCREEN_ON) {
      isUnlocked = 0;
      if (kDebugMode) {
        print("PANTALLA ENCENDIDA");
      }
    } else if (event == ScreenStateEvent.SCREEN_OFF) {
      if (isUnlocked == 1) {
        if (kDebugMode) {
          print("PANTALLA BLOQUEADA");
        }
        isUnlocked = 0;
      } else {
        if (kDebugMode) {
          print("PANTALLA APAGADA(SIN DESBLOQUEAR)");
        }
        isUnlocked = 0;
      }
    } else if (event == ScreenStateEvent.SCREEN_UNLOCKED) {
      isUnlocked = 1;
      if (kDebugMode) {
        print("PANTALLA DESBLOQUEADA");
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
