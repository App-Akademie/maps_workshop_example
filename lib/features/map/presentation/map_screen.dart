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
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("wtf???");
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          // Should never fire, as we are using a Future, not a stream.
          case ConnectionState.active:
            return const Text("Should never be visible");
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    const Text("An Error has occurred!"),
                    Text(snapshot.error.toString()),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              return const Text(
                  "Should not happen, our snapshot doesn't have data.");
            } else {
              return const Stack(children: [
                MapsExampleOSMFlutter(),
                MapsExampleControlButtons(),
              ]);
            }
        }
      },
    );
  }
}

class MapsExampleOSMFlutter extends StatelessWidget {
  const MapsExampleOSMFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    final MapNotifier mapNotifier = Provider.of<MapNotifier>(context);

    return OSMFlutter(
      onGeoPointClicked: (p0) =>
          mapNotifier.generateRouteFromCurrentLocation(p0),
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
}

class MapsExampleControlButtons extends StatelessWidget {
  const MapsExampleControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final MapNotifier mapNotifier = Provider.of<MapNotifier>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MapsExampleIconButton(
                  onPressed: () async {
                    await mapNotifier.startPositionPicker();
                  },
                  iconData: Icons.add_location,
                  color: const Color.fromARGB(255, 30, 101, 35)),
              MapsExampleIconButton(
                  onPressed: () {
                    mapNotifier.addDestinationMarker();
                  },
                  iconData: Icons.location_on,
                  color: const Color.fromARGB(255, 86, 76, 175)),
              MapsExampleIconButton(
                  onPressed: () {
                    mapNotifier.addCurrentLocationMarkerAndZoom();
                  },
                  iconData: Icons.search,
                  color: const Color.fromARGB(255, 244, 162, 54)),
              MapsExampleIconButton(
                  onPressed: () {
                    mapNotifier.deleteAllLocationsInFirebase();
                  },
                  iconData: Icons.restore,
                  color: const Color.fromARGB(255, 244, 79, 54)),
            ],
          ),
        ),
      ],
    );
  }
}

class MapsExampleIconButton extends StatelessWidget {
  const MapsExampleIconButton({
    super.key,
    required this.onPressed,
    required this.iconData,
    required this.color,
  });

  final VoidCallback onPressed;
  final IconData iconData;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
