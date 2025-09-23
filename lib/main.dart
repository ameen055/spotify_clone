import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_flutter/View/pages/signup_signin_page.dart';
import 'Controller/bloc/auth/auth_bloc.dart';
import 'Controller/bloc/player/player_bloc.dart';
import 'Data/model/audios_model.dart';
import 'Data/services/authgate.dart';
import 'View/pages/home_page.dart';
import 'View/pages/nowplaying_page.dart';
import 'View/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => AudioBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Start with a splash/auth wrapper
      initialRoute: '/authTest',

      // Define all routes here
      routes: {
        '/authTest': (context) => AuthGate(),
        '/home': (context) => HomePage(),
        '/start': (context) => StartedPage(),
        '/startedPage': (context) => SignUpOrSIgnIn(),
        '/signIn': (context) => HomePage(),
        '/signUp': (context) => HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/nowPlaying') {
          final audio = settings.arguments as Audios; // Pass Audios object
          return MaterialPageRoute(
            builder: (context) => NowPlayingScreen(audio: audio),
          );
        }
        return null;
      },
    );
  }
}
