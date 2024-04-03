// Importiert das Firebase Firestore Paket
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maps_workshop_example/features/map/data/location_repository.dart';
import 'package:maps_workshop_example/features/map/domain/location_model.dart';

class FirebaseLocationRepository implements LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Uploads the current location
  /// [locationModel] is the current location point
  @override
  void uploadLocation(LocationModel locationModel) {
    _firestore.collection('currentLocation').doc('APP_USER').set(
          locationModel.toMap(),
        );
  }

  /// Sets the destination point
  /// [locationModel] is the destination point
  @override
  void setNewDestionation(LocationModel locationModel) {
    _firestore.collection('destination').add(
          locationModel.toMap(),
        );
  }

  @override
  void deleteAllFirebaseDokuments() {
    _firestore.collection('destination').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    _firestore.collection('currentLocation').doc('APP_USER').delete();
  }

  // /// Gets the destination points
  // @override
  // Stream<List<LocationModel>> get getDestinations =>
  //     _firestore.collection('destination').snapshots().map((snapshot) =>
  //         snapshot.docs.map((doc) => LocationModel.fromDokument(doc)).toList());

  // /// Gets the current location from Firebase
  // /// [returns] the current location
  // @override
  // Future<void> getLocationFromCurrentUser() async {
  //
  // }
}
