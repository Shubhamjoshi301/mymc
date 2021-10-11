// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  // bool _isListenLocation = false;
  bool _isGetLocation = false;
  // bool _isListenLocation = false, _isGetLocation = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled!) {
                _serviceEnabled = await location.requestService();
                if (_serviceEnabled!) return;
              }
              _locationData = await location.getLocation();
              setState(() {
                _isGetLocation = true;
              });
            },
            child: const Text('Get Location'),
          ),
          _isGetLocation
              ? Text(
                  "lat: ${_locationData?.latitude} long: ${_locationData?.longitude}", style: const TextStyle(color: Colors.white),)
              : Container(),
          ElevatedButton(
            onPressed: () async {
              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.denied) return;
              }
            },
            child: const Text('Listen Location'),
          ),
        ],
      ),
    );
  }
}

Location location = Location();

// bool? _serviceEnabled;
// PermissionStatus? _permissionGranted;
// LocationData? _locationData;

