import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maps_workshop_example/app.dart';
import 'package:maps_workshop_example/common/controller/map_controller.dart';
import 'package:maps_workshop_example/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MapNotifier(),
        ),
      ],
      child: const App(),
    ),
  );
}
