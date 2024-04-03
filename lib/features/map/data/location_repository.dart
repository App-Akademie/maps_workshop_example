import 'package:maps_workshop_example/features/map/domain/location_model.dart';

abstract class LocationRepository {
  /// [lukas_comment] -> I think the other two methods to read out are a bit useless, I only have one user
  /// Current User
  void uploadLocation(LocationModel locationModel);

  /// Destination
  void setNewDestionation(LocationModel locationModel);

  void deleteAllFirebaseDokuments();
}
