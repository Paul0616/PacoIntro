import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/api_call_event.dart';
import 'package:pacointro/blocs/api_call_state.dart';
import 'package:pacointro/blocs/login_bloc.dart';

import 'package:pacointro/blocs/login_event.dart';
import 'package:pacointro/blocs/login_state.dart';
import 'package:pacointro/models/credentials_model.dart';
import 'package:pacointro/pages/locations_page.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/top_bar.dart';

class LoginPage extends StatefulWidget {
  static String route = '/LoginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final Repository _repository = Repository(httpClient: http.Client());
  final FocusNode _userFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final LoginBloc _loginBloc = LoginBloc();
  CredentialModel credentials;
  // String errorMessage;

  //final ApiCallBloc _apiCallBloc = ApiCallBloc(repository: FakeRepository());

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  var _controller = TextEditingController();

  //LoginBloc1 _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => _loginBloc,
        ),
        BlocProvider(
          create: (_) => ApiCallBloc(),
        ),
      ],
      child: Scaffold(
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
                      child: buildColumnBody(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColumnBody() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state is LoginEmptyState) {
        _loginBloc.add(InitTextFieldsEvent());
      }
      if (state is TextFieldsInitializedState) {
        _controller.text = state.userName;
      }
      if (state is LoginRefreshState) {
        credentials = state.credentials;
      }
      return BlocListener<ApiCallBloc, ApiCallState>(
        listener: (context, apiListenerState) {
          if (apiListenerState is ApiCallErrorState) {
            //;
            dialogAlert(
                context,
                apiListenerState.message.contains('timeout')
                    ? 'Error'
                    : "User incorect",
                Text(apiListenerState.message), onPressedPositive: () {
              Navigator.of(context).pop();
              BlocProvider.of<ApiCallBloc>(context).add(EmptyEvent());
            });
          }
          if (apiListenerState is ApiCallLoadedState) {
            print(apiListenerState.response);
            NavKey.navKey.currentState
                .pushReplacementNamed(LocationsPage.route);
          }
        },
        child: BlocBuilder<ApiCallBloc, ApiCallState>(
            builder: (context, apiState) {
          // if (apiState is ApiCallEmptyState && errorMessage != null) {
          //   BlocProvider.of<ApiCallBloc>(context)
          //       .add(ApiCallErrorEvent(errorMessage));
          //   errorMessage = null;
          // }
          if (apiState is ApiCallLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextFieldUserName(context),
              _buildTextFieldPassword(),
              _buildSubmitButton(context, state),
            ],
          );
        }),
      );
    });
  }

  Widget _buildSubmitButton(BuildContext context, LoginState state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          // side: BorderSide(color: pacoAppBarColor),
        ),
        onPressed: state.isValid
            ? () {
                FocusScope.of(context).requestFocus(FocusNode());
                BlocProvider.of<ApiCallBloc>(context)
                    .add(GetTokenEvent(credentials));
              }
            : null,
        disabledColor: pacoAppBarColor.withOpacity(0.5),
        disabledTextColor: pacoRedDisabledColor,
        color: pacoAppBarColor,
        textColor: Colors.white,
        child: Text('Log in'),
      ),
    );
  }

  Widget _buildTextFieldPassword() {
    return TextFormField(
      onChanged: (newPassword) {
        _loginBloc.add(PasswordChangeEvent(newPassword));
      },
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
    );
  }

  Widget _buildTextFieldUserName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        onChanged: (newUser) {
          _loginBloc.add(UserNameChangeEvent(newUser));
        },
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        obscureText: false,
        focusNode: _userFocusNode,
        onFieldSubmitted: (_) {
          _fieldFocusChange(context, _userFocusNode, _passwordFocusNode);
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
    );
  }
}
