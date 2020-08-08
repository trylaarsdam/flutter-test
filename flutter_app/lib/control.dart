import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_data.dart' as typed;
import './main.dart' as mainDart;

class ControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Control()
    );
  }
}

class Control extends StatefulWidget {
  Control({Key key}) : super(key: key);
  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> with AutomaticKeepAliveClientMixin<Control> {
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
        var topic = mainDart.uuid + '/control';
        final buff = typed.Uint8Buffer(2);
        buff[0] = 'o'.codeUnitAt(0);
        buff[1] = 'n'.codeUnitAt(0);
        mainDart.client.publishMessage(topic, MqttQos.atLeastOnce, buff);
      }
      else{
        var topic = mainDart.uuid + '/control';
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