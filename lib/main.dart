import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://thneabplfbyoawwnyarg.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRobmVhYnBsZmJ5b2F3d255YXJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY2NDk5MTMsImV4cCI6MjA3MjIyNTkxM30.pzSBNVAcMHm9_xrZLAkqJLg40fH_bKlkMR3DSpIqVmM',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amar Adalat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

final supabase = Supabase.instance.client;
