import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_data.dart' as typed;

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
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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

      }
    });
  }

}