import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _location;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late Position _currentPosition;
  final double _proximityThreshold = 1000.0;

  @override
  void initState() {
    super.initState();
    _location = LatLng(widget.latitude, widget.longitude);
    _initializeNotifications();
    _getCurrentLocation();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const android = AndroidInitializationSettings('app_icon');
    const initializationSettings = InitializationSettings(android: android);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    _checkProximity();
  }

  void _checkProximity() {
    double distance = Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      widget.latitude,
      widget.longitude,
    );

    if (distance <= _proximityThreshold) {
      _showNotification();
    }
  }

  Future<void> _showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'location_channel',
      'Location Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'You are near the exam location!',
      'Please be ready for your exam.',
      notificationDetails,
    );
  }
  void _onMapCreated(GoogleMapController controller) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Location on Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _location,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('exam_location'),
            position: _location,
            infoWindow: const InfoWindow(title: 'Exam Location'),
          ),
        },
      ),
    );
  }
}
