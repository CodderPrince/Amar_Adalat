import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

const String appScheme = 'myapp';
const String appHost = 'verify';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://thneabplfbyoawwnyarg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRobmVhYnBsZmJ5b2F3d255YXJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY2NDk5MTMsImV4cCI6MjA3MjIyNTkxM30.pzSBNVAcMHm9_xrZLAkqJLg40fH_bKlkMR3DSpIqVmM',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _initDeepLinkHandling();
  }

  Future<void> _initDeepLinkHandling() async {
    // Check initial link if app was launched with a link
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    // Handle incoming links
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print('Error receiving URI: $err');
    });
  }

  Future<void> _handleDeepLink(Uri uri) async {
    // Only handle links with the specified scheme and host
    if (uri.scheme == appScheme && uri.host == appHost) {
      final token = uri.queryParameters['token'];

      if (token != null) {
        // Call Supabase to confirm the email
        try {
          final res = await supabase.auth.verifyOTP(type: OtpType.email, token: token);
          // Navigate to success screen
          print('Email verification successful!');
        } catch (e) {
          // Handle errors
          print('Email verification failed: $e');
        }
      }
    }
  }

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