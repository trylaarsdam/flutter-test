import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_data.dart' as typed;
import './main.dart' as mainDart;


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Settings()
    );
  }
}

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with AutomaticKeepAliveClientMixin<Settings> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
  return new Scaffold(
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondRoute()),
        );
      },
    ),
  body:
  new Semantics(
  container: true,
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: <Widget>[Switch(onChanged: switchChanged, value:isSwitched)]))

  );
  }
  void switchChanged(bool value) {
  setState(() {
  isSwitched=value;
  if(isSwitched == true){
  var topic = mainDart.uuid + '/settings';
  final buff = typed.Uint8Buffer(2);
  buff[0] = 'o'.codeUnitAt(0);
  buff[1] = 'n'.codeUnitAt(0);
  mainDart.client.publishMessage(topic, MqttQos.atLeastOnce, buff);
  }
  else{
  var topic = mainDart.uuid + '/settings';
  final buff = typed.Uint8Buffer(3);
  buff[0] = 'o'.codeUnitAt(0);
  buff[1] = 'f'.codeUnitAt(0);
  buff[2] = 'f'.codeUnitAt(0);
  mainDart.client.publishMessage(topic, MqttQos.atLeastOnce, buff);
  }
  });
  }
  @override
  bool get wantKeepAlive => true;
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Connect"),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check_circle),
        label: Text('Connect'),
        tooltip: 'Connect to Bluetooth Device',
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pop(
            context
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
      ),
      floatingActionButtonLocation:
        FloatingActionButtonLocation.endFloat,
      );
  }
}