import 'package:flutter/material.dart';
import './bus.dart' as busPage;
import './control.dart' as controlPage;
import './settings.dart' as settingsPage;
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_data.dart' as typed;

Future<int> main() async {
    const url = 'lab.thewcl.com';
    const port = 1883;
    const clientId = 'flutterTestApp';
    const username = '';
    const password = '';
    final client = MqttServerClient(url, clientId);
    client.port = port;
    client.secure = false;
    client.setProtocolV311();
    await client.connect(username, password);
    if (client.connectionStatus.state == MqttConnectionState.connected) {
    }
    else {
      client.disconnect();
    }
    const topic = 'cpu-android/testing';
    final buff = typed.Uint8Buffer(4);
    buff[0] = 'a'.codeUnitAt(0);
    buff[1] = 'b'.codeUnitAt(0);
    buff[2] = 'c'.codeUnitAt(0);
    buff[3] = 'd'.codeUnitAt(0);
    client.publishMessage(topic, MqttQos.atLeastOnce, buff);
  runApp(new MaterialApp(
    home: new MyTabs()
  ));
}

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("CPU Connect"), backgroundColor: Colors.deepOrange, bottom: new TabBar(
          controller: controller,
          tabs: <Tab>[
          new Tab(icon: Icon(Icons.border_vertical)), new Tab(icon: Icon(Icons.apps)), new Tab(icon: Icon(Icons.settings))
        ]
      )
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new busPage.BusPage(),
          new controlPage.ControlPage(),
          new settingsPage.SettingsPage()
        ]
      )
    );
  }
}