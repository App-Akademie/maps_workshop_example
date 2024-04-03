import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final double latitude;
  final double longitude;
  final Timestamp timestamp;

  LocationModel(
      {required this.latitude,
      required this.longitude,
      required this.timestamp});

  factory LocationModel.fromDokument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LocationModel(
      latitude: data['latitude'],
      longitude: data['longitude'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    };
  }
}
