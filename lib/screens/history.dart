import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_state/screen_state.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_device_name/flutter_device_name.dart';

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
  final plugin = DeviceName();

  final Screen _screen = Screen();
  StreamSubscription<ScreenStateEvent>? _subscription;
  bool started = false;
  final List<ScreenStateEventEntry> _log = [];
  var isUnlocked = 0;

  @override
  void initState() {
    requestLocationPermission();
    startListening();
    super.initState();
  }

  void requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isDenied) {
      SystemNavigator.pop();
      if (kDebugMode) {
        print('Permiso de ubicación denegado');
      }
    }
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
    final deviceName = await plugin.getName();
    setState(() {
      _log.add(ScreenStateEventEntry(event));
    });
    if (event == ScreenStateEvent.SCREEN_ON) {
      isUnlocked = 0;

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var newDataRef = ref.push();
      List dateTime = _log.last.time.toString().substring(0, 19).split(' ');
      await newDataRef.set({
        "user": deviceName,
        "action": "PANTALLA ENCENDIDA",
        "date": dateTime[0],
        "time": dateTime[1],
        "latitude": position.latitude,
        "longitud": position.longitude
      });
    } else if (event == ScreenStateEvent.SCREEN_OFF) {
      if (isUnlocked == 1) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        var newDataRef = ref.push();
        List dateTime = _log.last.time.toString().substring(0, 19).split(' ');
        await newDataRef.set({
          "user": deviceName,
          "action": "PANTALLA BLOQUEADA",
          "date": dateTime[0],
          "time": dateTime[1],
          "latitude": position.latitude,
          "longitud": position.longitude
        });

        isUnlocked = 0;
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        var newDataRef = ref.push();
        List dateTime = _log.last.time.toString().substring(0, 19).split(' ');
        await newDataRef.set({
          "user": deviceName,
          "action": "PANTALLA APAGADA(SIN DESBLOQUEAR)",
          "date": dateTime[0],
          "time": dateTime[1],
          "latitude": position.latitude,
          "longitud": position.longitude
        });

        isUnlocked = 0;
      }
    } else if (event == ScreenStateEvent.SCREEN_UNLOCKED) {
      isUnlocked = 1;

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var newDataRef = ref.push();
      List dateTime = _log.last.time.toString().substring(0, 19).split(' ');
      await newDataRef.set({
        "user": deviceName,
        "action": "PANTALLA DESBLOQUEADA",
        "date": dateTime[0],
        "time": dateTime[1],
        "latitude": position.latitude,
        "longitud": position.longitude
      });
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
      body: Container(
        color: Colors.black,
        child: Center(
            child: ListView.builder(
                itemCount: _log.length,
                reverse: true,
                itemBuilder: (BuildContext context, int idx) {
                  final entry = _log[idx];
                  return ListTile(
                      leading: Text(
                        entry.time.toString().substring(0, 19),
                        style: const TextStyle(color: Colors.green),
                      ),
                      trailing: Text(entry.event.toString().split('.').last,
                          style: const TextStyle(color: Colors.green)));
                })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: started ? stopListening : startListening,
        tooltip: 'Start/Stop Listening',
        child: started ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
      ),
    );
  }
}
