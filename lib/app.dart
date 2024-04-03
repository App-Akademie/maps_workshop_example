import 'package:flutter/material.dart';
import 'package:maps_workshop_example/features/map/presentation/map_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}
