import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; // Add this import
import 'database/database_helper.dart'; // Import DatabaseHelper
import 'database/vendor_data_manager.dart';
import 'signup_page.dart'; // Import SignupPage

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

    // Initialize database and add sample vendors and phones
    final vendorManager = VendorDataManager();
    await vendorManager.addSampleVendors();
    await vendorManager.addSamplePhones(); // Add this line to insert sample phones
    await vendorManager.addSampleTransactions();

    // Check user authentication status
    User? user = FirebaseAuth.instance.currentUser;
    String initialRoute = user == null ? '/login' : '/home';

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => DatabaseHelper(), // Provide DatabaseHelper
          ),
        ],
        child: MyApp(initialRoute: initialRoute),
      ),
    );
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
        '/signup': (context) => SignupPage(),
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
          // Extract UPI ID from route arguments
          final upiId = ModalRoute.of(context)?.settings.arguments as String?;
          if (upiId == null) {
            // Handle invalid or missing UPI ID
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Invalid UPI ID'),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }
          return PaymentScreen(qrData: upiId); // Pass UPI ID to PaymentScreen
        },
      },
    );
  }
}