import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
import 'package:ursapp/screens/qr_scanner_screen.dart'; // Add this import
import 'package:ursapp/screens/payment_screen.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? user = FirebaseAuth.instance.currentUser;
  String initialRoute = user == null ? '/login' : '/home';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URS',
      theme: ThemeData(primarySwatch: Colors.blue),
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
        '/qr_scanner': (context) => QrScannerScreen(), // Add this route
        '/payment': (context) {
          // Extract the QR data from the arguments
          final qrData = ModalRoute.of(context)!.settings.arguments as String;
          return PaymentScreen(qrData: qrData); // Pass the QR data to the PaymentScreen
        },
      },
    );
  }
}