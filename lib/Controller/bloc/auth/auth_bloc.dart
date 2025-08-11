import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';


class AuthBloc extends Bloc<LoginStatusEvent,AuthInitialState>{
  AuthBloc():super(AuthLoggedOut()){
    on<LoginStatusEvent>((event,emit)async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      emit(AuthLoggedOut());
    });

    on<LoginEvent>((event, emit)async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      emit(AuthLoggedIn());
    });

    on<LogoutEvent>((event, emit)async{
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedOut', false);
      emit(AuthLoggedOut());
    });
  }
}