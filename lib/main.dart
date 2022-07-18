import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:telpo_latest/repositories/telpo_platform_repositories.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = PlatformRepository();
  String colorResult = "0xFFCA2C92";
  String deviceStatus = '';
  bool fingerPrintService = false;

  getDeviceStatus() async {
    int status = await _repository.getDeviceStatus();
    setState(() {
      deviceStatus = status == 0 ? 'off' : 'on';
    });
    print(status);
  }

  getIsCapturing() async {
    var data = await _repository.getIsCapturing();
    log(data.toString());      getDeviceStatus();

  }

  turnOnFingerPrintServices() async {
    int status = await _repository.turnOnFingerPrintService();
    log(status.toString());
    if (status == 1) {
      setState(() {
        fingerPrintService = true;
      });
      getDeviceStatus();
    }
  }

  turnOffFingerPrintServices() async {
    int status = await _repository.turnOffFingerPrintService();
    log(status.toString());
    if (status == 0) {
      setState(() {
        fingerPrintService = false;
      });
      getDeviceStatus();
    }
  }

  @override
  void initState() {
    turnOnFingerPrintServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('FingerPrint Service is : ' + deviceStatus),
              const Divider(color: Colors.transparent),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(fingerPrintService == true ? 'Turn Off' : 'Turn On',
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold))
                            ]),
                        onPressed: () async {
                          fingerPrintService == true
                              ? turnOffFingerPrintServices()
                              : turnOnFingerPrintServices();
                        }),
                    ElevatedButton(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Capture',
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold))
                            ]),
                        onPressed: () async {
                          getIsCapturing();
                        })
                  ])
            ])));
  }
}
