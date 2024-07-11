import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sistem_managemen_tiket_bus/pages/main/map.dart';
import 'package:sistem_managemen_tiket_bus/pages/user/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sistem_managemen_tiket_bus/providers/auth_provider.dart';
import 'package:sistem_managemen_tiket_bus/providers/map_provider.dart';
import 'package:sistem_managemen_tiket_bus/providers/theme_provider.dart';
import 'package:sistem_managemen_tiket_bus/providers/wallet_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserAuthProvider()),
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final _fireauth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CupertinoApp(
      title: 'SAGATRANS',
      home: _fireauth.currentUser != null
          ? const MapPage()
          : const RegisterPage(),
      theme: CupertinoThemeData(
        brightness:
            themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const MapPage(),
        '/welcome': (context) => const RegisterPage(),
      },
    );
  }
}
