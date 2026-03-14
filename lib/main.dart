import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Entry point for the Flutter application.
/// Initializes Supabase and wraps the app in a [ProviderScope].
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase with the project URL and anonymous key.
  await Supabase.initialize(
    url: 'https://aagltpdlrbsjonpqkfgm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFhZ2x0cGRscmJzam9ucHFrZmdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0ODgwNDgsImV4cCI6MjA4OTA2NDA0OH0.OvwbaHY9AQM23YsiqcXs_A0PODTRj8CddjJ36f5Y4T0',
  );

  runApp(const ProviderScope(child: MyApp()));
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text('it works'),
        ),
      ),
    );
  }
}
