import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_flutter/View/pages/get_startedpage.dart';
import 'package:study_flutter/View/widgets/home_widget/nav_bar.dart';
import 'Controller/bloc/auth/auth_bloc.dart';
import 'View/pages/home_page.dart';
import 'View/pages/now_playing.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(create: (_) => AuthBloc()),
      // BlocProvider(create: (_) => AudioPlayerBloc()),

    ], child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return NowPlayingScreen(); // Already logged in
                }
                return StartedPage(); // Not logged in
              },
            ),
          );

  }
}
