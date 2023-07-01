import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import './screens/home.dart';

void main() async {
  // Chargement du fichier de config
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset('settings');
  print(GlobalConfiguration().appConfig.toString());
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Occasions du Club St Hil\'Air',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => Home()},
    );
  }
}
