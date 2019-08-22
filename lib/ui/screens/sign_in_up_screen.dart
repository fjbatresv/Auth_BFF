import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:speak_bff/blocs/auth_bloc.dart';

class SignInUpScreen extends StatefulWidget {
  @override
  _SignInUpScreen createState() {
    return _SignInUpScreen();
  }
}

class _SignInUpScreen extends State<SignInUpScreen> {
  AuthBloc _bloc;
  TextEditingController _email = TextEditingController();
  FocusNode _emailFocus = FocusNode();
  bool _emailError = false;
  TextEditingController _password = TextEditingController();
  FocusNode _passwordFocus = FocusNode();
  bool _passwordError = false;

  void _login() async {
    print('LOGIN!');
    _emailError = false;
    _passwordError = false;
    if (_email.text == null || _email.text.isEmpty) {
      _emailError = true;
    }
    if (_password.text == null || _password.text.isEmpty) {
      _passwordError = true;
    }
    if (_emailError || _passwordError) {
      setState(() {});
      return;
    }
    try {
      await _bloc.emailSignin(_email.text, _password.text);
    } catch (Exception) {
      await _bloc.emailSignup(_email.text, _password.text);
    }
  }

  void _googleLogin() {
    _bloc.googleSignin();
  }

  void _recoverPassword() async {
    _bloc.recoverPassword(_email.text);
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: StreamBuilder(
            stream: _bloc.authStatus,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return FutureBuilder(
                  future: _bloc.currentUser(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snapshot.data.email,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: FlatButton.icon(
                                  label: Text("Cerrar sesión"),
                                  icon: Icon(Icons.exit_to_app),
                                  textColor: Colors.white,
                                  onPressed: () => _bloc.signOut(),
                                ),
                              )
                            ],
                          ),
                        );
                        break;
                    }
                  },
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.verified_user,
                      color: Colors.white,
                      size: 80,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Auth BFF",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocus,
                        style: TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
                        onSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "example@example.com",
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white60),
                          suffixIcon: Icon(
                            Icons.alternate_email,
                            color: Colors.white,
                          ),
                          errorText: _emailError
                              ? "Este no parece ser un email valido"
                              : null,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _password,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (String value) {
                          _login();
                        },
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          suffixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                          ),
                          errorText: _passwordError
                              ? "Esta no parece ser una contraseña valido"
                              : null,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: RaisedButton(
                        child: Text("Iniciar Sesión"),
                        color: Colors.white,
                        textColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: _login,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: FlatButton(
                        child: Text("Recuperar contraseña"),
                        textColor: Colors.white,
                        onPressed: _login,
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: RaisedButton(
                        child: Text("Usar Google"),
                        color: Colors.white,
                        textColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: _googleLogin,
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
