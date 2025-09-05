import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/analysis_screen.dart';
import 'screens/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables
  print("API Key Loaded: ${dotenv.env['OPENAI_API_KEY']}"); // Debugging
  runApp(const AigisApp());
}

class AigisApp extends StatelessWidget {
  const AigisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aigis AI',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black,
      ),
      // Remove routes and use onGenerateRoute
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const SplashScreen());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/analysis':
            final args = settings.arguments as String; // Ensure imagePath is passed
            return MaterialPageRoute(builder: (context) => AnalysisScreen(imagePath: args));
          case '/chat':
            final result = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ChatScreen(result: result),
            );
          default:
            return null; // Handle undefined routes
        }
      },
    );
  }
}
