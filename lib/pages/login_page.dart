import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pacointro/blocs/login_bloc.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  var _controller = TextEditingController();
  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<LoginBloc>(context);
    _bloc.getCurrentUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _bloc.getCurrentUser();
    StreamSubscription<String> subscription;
    subscription = _bloc.userName.listen((name) {
      _controller.text = name ?? '';
      subscription.cancel();
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MediaQuery.of(context).orientation == Orientation.portrait
                ? TopBar()
                : Container(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: StreamBuilder<ApiResponse<UserModel>>(
                        stream: _bloc.currentUserStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return Container(
                                  padding: EdgeInsets.all(8),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                break;
                              case Status.COMPLETED:
                                return buildColumnBody();
                                break;
                              case Status.ERROR:
                                StreamSubscription<bool> subscriptionError;
                                subscriptionError =
                                    _bloc.errorOccur.listen((hasError) {
                                  if (hasError)
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(snapshot.data.message),
//                                      action: SnackBarAction(
//                                        label: 'Inchide',
//                                        textColor: pacoLightGray,
//                                        onPressed: () {
//                                        //  _bloc.closeError();
//                                        },
//                                      ),
                                    ));
                                  subscriptionError.cancel();
                                });
                                return buildColumnBody();
                                break;
                            }
                          }
                          return buildColumnBody();
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Column buildColumnBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: _controller,
            onChanged: _bloc.userNameChanged,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            focusNode: _emailFocusNode,
            onFieldSubmitted: (_) {
              _fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
            },
            style: textStyle.copyWith(decoration: TextDecoration.none),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(25.0),
              ),
              filled: true,
              fillColor: pacoLightGray,
              hintText: "Introduceți numele",
              hintStyle: textStyle,
            ),
          ),
        ),
        TextFormField(
          //controller: Te,
          onChanged: _bloc.passwordChanged,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          focusNode: _passwordFocusNode,
          style: textStyle.copyWith(decoration: TextDecoration.none),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(25.0),
            ),
            filled: true,
            fillColor: pacoLightGray,
            hintText: "Introduceți parola",
            hintStyle: textStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: StreamBuilder<bool>(
              stream: _bloc.submitCheck, //_bloc.password,
              builder: (context, snapshot) {
                return FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    // side: BorderSide(color: pacoAppBarColor),
                  ),
                  onPressed: snapshot.hasData && snapshot.data
                      ? () {
                          _bloc.loginPressed();
                        }
                      : null,
                  disabledColor: pacoAppBarColor.withOpacity(0.5),
                  disabledTextColor: pacoRedDisabledColor,
                  color: pacoAppBarColor,
                  textColor: Colors.white,
                  child: Text('Log in'),
                );
              }),
        ),
      ],
    );
  }
}
