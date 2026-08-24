import 'package:flutter/material.dart';

import '../../models/app_settings.dart';
import '../../services/settings_service.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final SettingsService _settingsService = SettingsService();

AppSettings? settings;

bool _loading = true;
bool _entering = false;

@override
void initState() {
super.initState();
_loadSettings();
}

Future<void> _loadSettings() async {
final data = await _settingsService.getSettings();

if (!mounted) return;

setState(() {
settings = data;
_loading = false;
});
}

Future<void> _enterSystem() async {
setState(() {
_entering = true;
});

await Future.delayed(
const Duration(seconds: 1),
);

if (!mounted) return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => const DashboardScreen(),
),
);
}

@override
Widget build(BuildContext context) {
if (_loading) {
return const Scaffold(
body: Center(
child: CircularProgressIndicator(),
),
);
}

return Scaffold(
backgroundColor: Colors.grey.shade100,

body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(
horizontal: 30,
),

child: Column(
mainAxisAlignment: MainAxisAlignment.center,

children: [

//=========================================
// SHOP ICON
//=========================================

Container(
height: 130,
width: 130,

decoration: BoxDecoration(
color: Colors.blue.shade50,
shape: BoxShape.circle,
),

child: const Icon(
Icons.store,
size: 75,
color: Colors.blue,
),
),

const SizedBox(height: 35),

//=========================================
// SHOP NAME
//=========================================

Text(
settings?.shopName ??
"Shop Management System",

textAlign: TextAlign.center,

style: const TextStyle(
fontSize: 30,
fontWeight: FontWeight.bold,
letterSpacing: 1.2,
),
),

const SizedBox(height: 10),

Text(
"Powered by Shop Management System",

style: TextStyle(
fontSize: 15,
color: Colors.grey.shade700,
),
),

const SizedBox(height: 40),

//=========================================
// WELCOME MESSAGE
//=========================================

const Text(
"Welcome!",
style: TextStyle(
fontSize: 26,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

Text(
"Manage your products, sales, customers, suppliers, expenses and reports from one place.",

textAlign: TextAlign.center,

style: TextStyle(
fontSize: 16,
color: Colors.grey.shade700,
height: 1.5,
),
),

const SizedBox(height: 50),
  //=========================================
  // ENTER SYSTEM BUTTON
  //=========================================

  SizedBox(
    width: double.infinity,
    height: 60,

    child: ElevatedButton.icon(

      onPressed: _entering
          ? null
          : _enterSystem,

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(15),
        ),
      ),

      icon: _entering
          ? const SizedBox(
        height: 24,
        width: 24,
        child:
        CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.white,
        ),
      )
          : const Icon(
        Icons.arrow_forward,
        size: 26,
      ),

      label: Text(
        _entering
            ? "Opening..."
            : "ENTER SYSTEM",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    ),
  ),

  const SizedBox(height: 40),

  //=========================================
  // VERSION
  //=========================================

  Text(
    "Version 1.0.0",

    style: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 14,
    ),
  ),

  const SizedBox(height: 8),

  Text(
    "© ${DateTime.now().year} Shop Management System",

    textAlign: TextAlign.center,

    style: TextStyle(
      color: Colors.grey.shade500,
      fontSize: 12,
    ),
  ),
],
),
),
),
),
);
}
}

