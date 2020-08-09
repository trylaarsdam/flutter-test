import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_data.dart' as typed;
import './main.dart' as mainDart;
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(child: new Settings());
  }
}

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with AutomaticKeepAliveClientMixin<Settings> {
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
              MaterialPageRoute(builder: (context) => BluetoothConnect()),
            );
          },
        ),
        body: new Semantics(
            container: true,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Switch(onChanged: switchChanged, value: isSwitched)
                ])));
  }

  void switchChanged(bool value) {
    if (mounted) {
      setState(() {
        isSwitched = value;
        if (isSwitched == true) {
          var topic = mainDart.uuid + '/settings';
          final buff = typed.Uint8Buffer(2);
          buff[0] = 'o'.codeUnitAt(0);
          buff[1] = 'n'.codeUnitAt(0);
          mainDart.client.publishMessage(topic, MqttQos.atLeastOnce, buff);
        } else {
          var topic = mainDart.uuid + '/settings';
          final buff = typed.Uint8Buffer(3);
          buff[0] = 'o'.codeUnitAt(0);
          buff[1] = 'f'.codeUnitAt(0);
          buff[2] = 'f'.codeUnitAt(0);
          mainDart.client.publishMessage(topic, MqttQos.atLeastOnce, buff);
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class BluetoothConnect extends StatefulWidget {
  BluetoothConnect({Key key, this.title}) : super(key: key);

  final String title;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  @override
  _BluetoothConnectState createState() => _BluetoothConnectState();
}

class _BluetoothConnectState extends State<BluetoothConnect> {
  final _writeController = TextEditingController();
  BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      if (mounted) {
        setState(() {
          widget.devicesList.add(device);
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });

      widget.flutterBlue.startScan().catchError( (error) {
        // set up the buttons
        Widget cancelButton = FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("CPU Connect"),
          content: Text(
              "This device doesn't appear to have bluetooth capabilities. Please switch to a device that has bluetooth and try again."),
          actions: [
            cancelButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    );
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              FlatButton(
                color: Colors.red,
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  widget.flutterBlue.stopScan();
                  try {
                    await device.connect();
                  } catch (e) {
                    if (e.code != 'already_connected') {
                      throw e;
                    }
                  } finally {
                    _services = await device.discoverServices();
                  }
                  if (mounted) {
                    setState(() {
                      print(device);
                      _connectedDevice = device;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = new List<ButtonTheme>();

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              color: Colors.blue,
              child: Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  if (mounted) {
                    setState(() {
                      widget.readValues[characteristic.uuid] = value;
                    });
                  }
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Send"),
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  widget.readValues[characteristic.uuid] = value;
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = new List<Container>();

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = new List<Widget>();

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ' +
                        widget.readValues[characteristic.uuid].toString()),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Bluetooth"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.flutterBlue.stopScan();
            Navigator.pop(context);
          },
          child: Icon(Icons.cancel),
          backgroundColor: Colors.red,
        ),
        body: _buildView(),
      );
}
