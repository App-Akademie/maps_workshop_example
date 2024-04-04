import 'package:cloud_firestore/cloud_firestore.dart' hide GeoPoint;
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:maps_workshop_example/features/map/data/firebase_location_repository.dart';
import 'package:maps_workshop_example/features/map/data/location_picker.dart';
import 'package:maps_workshop_example/features/map/data/location_repository.dart';
import 'package:maps_workshop_example/features/map/domain/location_model.dart';

class MapNotifier extends ChangeNotifier {
  late MapController controller;
  late Future initControllerFuture;
  GeoPoint? currentLocation;

  final LocationRepository _locationRepository = FirebaseLocationRepository();

  MapNotifier() {
    initControllerFuture = _initController();
  }

  /// Adds a destination marker to the map
  void addDestinationMarker() async {
    GeoPoint selectedLocation = await controller.selectAdvancedPositionPicker();
    _locationRepository.setNewDestionation(LocationModel(
        latitude: selectedLocation.latitude,
        longitude: selectedLocation.longitude,
        timestamp: Timestamp.now()));
    notifyListeners();
  }

  /// Removes a marker from the map
  /// [location] is the location of the marker as GeoPoint
  void removeMarker(GeoPoint location) {
    controller.removeMarker(location);
    notifyListeners();
  }

  /// Selects a position on the map
  Future<void> startPositionPicker() async {
    await controller.advancedPositionPicker();
    notifyListeners();
  }

  /// Draws a route from the current location to the destination
  /// [destination] is the destination as GeoPoint
  void generateRouteFromCurrentLocation(GeoPoint destination) {
    controller.clearAllRoads();
    controller.drawRoad(currentLocation!, destination);
  }

  /// Adds the current location marker and zooms in
  Future<void> addCurrentLocationMarkerAndZoom() async {
    await _addMarker(currentLocation!);
    controller.goToLocation(currentLocation!);
    controller.zoomIn();
  }

  /// Updates the current location
  /// [newLocation] is the new location as GeoPoint
  void updateCurrentLocation(GeoPoint newLocation) {
    controller.changeLocation(newLocation);
    currentLocation = newLocation;
    _setOrUpdatelocation(newLocation);
    notifyListeners();
  }

  void deleteAllLocationsInFirebase() {
    _locationRepository.deleteAllFirebaseDokuments();
    notifyListeners();
  }

  //////////////// --- Private functions --- ////////////////

  /// Initializes the controller with the current location
  Future<void> _initController() async {
    final position = await LocationPicker().determinePosition();
    controller = MapController.withPosition(
      initPosition: GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
    currentLocation = GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    _setOrUpdatelocation(currentLocation!);

    notifyListeners();
  }

  /// Adds a marker to the map
  /// [location] is the location of the marker as GeoPoint
  Future<void> _addMarker(GeoPoint location) async {
    await controller.addMarker(
      location,
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.location_history),
      ),
      angle: 0,
    );
    notifyListeners();
  }

  /// Sets or updates the location in the database
  /// [location] is the location as GeoPoint
  void _setOrUpdatelocation(GeoPoint location) {
    _locationRepository.uploadLocation(LocationModel(
        latitude: location.latitude,
        longitude: location.longitude,
        timestamp: Timestamp.now()));
  }
}
