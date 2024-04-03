import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:maps_workshop_example/common/controller/map_controller.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MapNotifier mapNotifier = Provider.of<MapNotifier>(context);

    return FutureBuilder(
      future: mapNotifier.initControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(children: [
            buildOSMFlutter(mapNotifier),
            buildControlButtons(mapNotifier),
          ]);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  OSMFlutter buildOSMFlutter(MapNotifier mapNotifier) {
    return OSMFlutter(
      onGeoPointClicked: (p0) => mapNotifier.gernerRouteFromCurrentLocation(p0),
      // onLocationChanged: (p0) => mapNotifier.updateCurrentLocation(p0),
      controller: mapNotifier.controller,
      osmOption: OSMOption(
        isPicker: true,
        userTrackingOption: const UserTrackingOption(
          enableTracking: true,
          unFollowUser: false,
        ),
        zoomOption: const ZoomOption(
          initZoom: 8,
          minZoomLevel: 6,
          maxZoomLevel: 16,
          stepZoom: 1.0,
        ),
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
              Icons.location_history_rounded,
              color: Colors.red,
              size: 48,
            ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              size: 48,
            ),
          ),
        ),
        roadConfiguration: const RoadOption(
          roadColor: Color.fromARGB(255, 0, 51, 255),
        ),
        markerOption: MarkerOption(
          defaultMarker: const MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildControlButtons(MapNotifier mapNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconButton(
                onPressed: () async {
                  await mapNotifier.startPositionPicker();
                },
                iconData: Icons.add_location,
                color: const Color.fromARGB(255, 30, 101, 35),
              ),
              buildIconButton(
                onPressed: () {
                  mapNotifier.addDestinationMarker();
                },
                iconData: Icons.location_on,
                color: const Color.fromARGB(255, 86, 76, 175),
              ),
              buildIconButton(
                onPressed: () {
                  mapNotifier.addCurrentLocationMarkerAndZoom();
                },
                iconData: Icons.search,
                color: const Color.fromARGB(255, 244, 162, 54),
              ),
              buildIconButton(
                onPressed: () {
                  mapNotifier.deleteAllLocationsInFirebase();
                },
                iconData: Icons.restore,
                color: const Color.fromARGB(255, 244, 79, 54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconButton buildIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
    required Color color,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: color,
        size: 30.0,
      ),
    );
  }
}
