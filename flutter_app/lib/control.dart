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
    return new Container(child: new Control());
  }
}

class Control extends StatefulWidget {
  Control({Key key}) : super(key: key);

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control>
    with AutomaticKeepAliveClientMixin<Control> {
  int component = 0;
  bool ctrlLine0 = false;
  bool ctrlLine1 = false;
  bool ctrlLine2 = false;
  bool ctrlLine3 = false;
  bool ctrlLine4 = false;
  bool ctrlLine5 = false;
  bool ctrlLine6 = false;
  bool ctrlLine7 = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Semantics(
            container: true,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  new Column(children: [
                    Checkbox(onChanged: ctrlLineHandler_7, value: ctrlLine7)
                  ]),
                  new Column(children: [
                    Checkbox(onChanged: ctrlLineHandler_6, value: ctrlLine6)
                  ]),
                  new Column(children: [
                    Checkbox(onChanged: ctrlLineHandler_5, value: ctrlLine5)
                  ]),
                  new Column(children: [
                    Checkbox(onChanged: ctrlLineHandler_4, value: ctrlLine4)
                  ]),
                  new Column(children: [
                    Checkbox(onChanged: ctrlLineHandler_3, value: ctrlLine3)
                  ]),
                  new Column(children: [
                    Checkbox(onChanged: ctrlLineHandler_2, value: ctrlLine2)
                  ]),
                  new Column(children: [
                    Checkbox(onChanged: ctrlLineHandler_1, value: ctrlLine1)
                  ]),
                  new Column(children: [
                    Checkbox(onChanged: ctrlLineHandler_0, value: ctrlLine0)
                  ])
                ])));
  }

  void ctrlLineHandler_0(bool value){
    setState((){
      ctrlLine0 = value;
    });
  }
  void ctrlLineHandler_1(bool value){
    setState((){
      ctrlLine1 = value;
    });
  }
  void ctrlLineHandler_2(bool value){
    setState((){
      ctrlLine2 = value;
    });
  }
  void ctrlLineHandler_3(bool value){
    setState((){
      ctrlLine3 = value;
    });
  }
  void ctrlLineHandler_4(bool value){
    setState((){
      ctrlLine4 = value;
    });
  }
  void ctrlLineHandler_5(bool value){
    setState((){
      ctrlLine5 = value;
    });
  }
  void ctrlLineHandler_6(bool value){
    setState((){
      ctrlLine6 = value;
    });
  }
  void ctrlLineHandler_7(bool value){
    setState((){
      ctrlLine7 = value;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
