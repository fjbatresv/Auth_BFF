import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:speak_bff/blocs/auth_bloc.dart';
import 'package:speak_bff/ui/screens/sign_in_up_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: AuthBloc(),
      child: MaterialApp(
        title: "Auth BFF",
        home: SignInUpScreen(),
      ),
    );
  }
}