import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'database/database_helper.dart';
import 'database/vendor_data_manager.dart';

// Screen imports
import 'package:ursapp/home_page.dart';
import 'package:ursapp/login_page.dart';
import 'package:ursapp/screens/settings_screen.dart';
import 'package:ursapp/screens/help_screen.dart';
import 'package:ursapp/screens/profile_screen.dart';
import 'package:ursapp/screens/contacts.dart';
import 'package:ursapp/screens/personal_qr.dart';
import 'package:ursapp/screens/transaction_history.dart';
import 'package:ursapp/screens/current_points.dart';
import 'package:ursapp/screens/create_bill.dart';
import 'package:ursapp/screens/drafts.dart';
import 'package:ursapp/screens/upload_bill.dart';
import 'package:ursapp/screens/my_bills.dart';
import 'package:ursapp/screens/qr_scanner_screen.dart';
import 'package:ursapp/screens/payment_screen.dart';

Future<void> main() async {
  try {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize Firebase
    await Firebase.initializeApp();

    // Initialize database and add sample vendors
    final vendorManager = VendorDataManager();
    await vendorManager.addSampleVendors();

    // Check user authentication status
    User? user = FirebaseAuth.instance.currentUser;
    String initialRoute = user == null ? '/login' : '/home';

    runApp(MyApp(initialRoute: initialRoute));
  } catch (e) {
    print('Initialization Error: $e');
    // Handle initialization errors appropriately
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize app: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/help': (context) => HelpScreen(),
        '/contacts': (context) => ContactsScreen(),
        '/personal_qr': (context) => PersonalQrScreen(),
        '/transaction_history': (context) => TransactionHistoryScreen(),
        '/current_points': (context) => CurrentPointsScreen(),
        '/create_bill': (context) => CreateBillScreen(),
        '/drafts': (context) => DraftsScreen(),
        '/upload_bill': (context) => UploadBillScreen(),
        '/my_bills': (context) => MyBillsScreen(),
        '/qr_scanner': (context) => QrScannerScreen(),
        '/payment': (context) {
          // Extract and validate QR data from route arguments
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is! String) {
            // Handle invalid or missing QR data
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Invalid QR Data'),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }
          return PaymentScreen(qrData: args);
        },
      },
      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Page Not Found'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'The requested page was not found.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                      );
                    },
                    child: const Text('Go to Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      // Handle errors during navigation
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: Center(
                child: Text('Error loading ${settings.name}'),
              ),
            );
          },
        );
      },
    );
  }
}