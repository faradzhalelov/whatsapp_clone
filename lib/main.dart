import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/colors.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/loader.dart';
import 'package:whatsup/features/auth/controller/auth_controller.dart';
import 'package:whatsup/features/landing/screens/landing_screen.dart';
import 'package:whatsup/firebase_options.dart';
import 'package:whatsup/router.dart';
import 'package:whatsup/screens/mobile_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp UI',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor,
          ),
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              } else {
                return const MobileLayoutScreen();
              }
            },
            error: ((error, stackTrace) {
              return ErrorScreen(error: error.toString());
            }),
            loading: () => const Loader()));
  }
}
