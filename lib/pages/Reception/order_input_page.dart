import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/api_call_event.dart';
import 'package:pacointro/blocs/api_call_state.dart';
import 'package:pacointro/blocs/home_bloc.dart';
import 'package:pacointro/blocs/home_event.dart';
import 'package:pacointro/blocs/home_state.dart';

import 'package:pacointro/blocs/order_input_bloc.dart';
import 'package:pacointro/blocs/order_input_event.dart';
import 'package:pacointro/blocs/order_input_state.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/pages/Reception/order_display_page.dart';

import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/top_bar.dart';

class OrderInputPage extends StatefulWidget {
  static String route = '/OrderInputPage';

  @override
  _OrderInputPageState createState() => _OrderInputPageState();
}

class _OrderInputPageState extends State<OrderInputPage> {


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc(),
        ),
        BlocProvider(
          create: (_) => ApiCallBloc(),
        ),
        BlocProvider(
          create: (_) => OrderInputBloc(),
        )
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TopBar(
                  withBackNavigation: true,
                ),
                BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                  var currentLocationName = '';
                  if (state is EmptyState) {
                    BlocProvider.of<HomeBloc>(context)
                        .add(InitCurrentLocationEvent());
                  }
                  if (state is LocationInitiatedState) {
                    currentLocationName = state.location.name;
                  }
                  return Text('Magazin: $currentLocationName',
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: pacoAppBarColor));
                }),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(64),
                    child: _inputOrderBlocBuilder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget _inputOrderBlocBuilder() {
    return BlocListener<ApiCallBloc, ApiCallState>(
      listener: _onApiListener,
      child: BlocBuilder<ApiCallBloc, ApiCallState>(builder: (context, state) {
        if (state is ApiCallLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ApiCallLoadedState) {}
        return _inputOrderWidget(context);
      }),
    );
  }

  _onApiListener(BuildContext context, ApiCallState state) {
    if (state is ApiCallErrorState) {
      if (state.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.message),
        ));
      }
    }
    if (state is ApiCallLoadedState) {
      final navKey = NavKey.navKey;
      navKey.currentState.pushReplacementNamed(OrderDisplayPage.route,
          arguments: (state.response as OrderModel));
    }
  }

  Widget _inputOrderWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          //controller: _controller,
          autofocus: true,
          onChanged: (text) {
            BlocProvider.of<OrderInputBloc>(context)
                .add(OrderNumberChangeEvent(text));
          },
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          obscureText: false,
          style: textStyle.copyWith(decoration: TextDecoration.none),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(25.0),
            ),
            filled: true,
            fillColor: pacoLightGray,
            hintText: "Numărul comenzii:",
            hintStyle: textStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: BlocBuilder<OrderInputBloc, OrderInputState>(
              builder: (context, state) {
            bool isValid = false;
            String orderNumber = '';
            if (state is ValidationSendRequestState) {
              isValid = state.isValid;
              orderNumber = state.orderNumber;
            }
            return FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                // side: BorderSide(color: pacoAppBarColor),
              ),
              onPressed: isValid
                  ? () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      BlocProvider.of<ApiCallBloc>(context)
                          .add(OrderByNumberEvent(orderNumber));
                    }
                  : null,
              disabledColor: pacoAppBarColor.withOpacity(0.5),
              disabledTextColor: pacoRedDisabledColor,
              color: pacoAppBarColor,
              textColor: Colors.white,
              child: Text('Încarcă comanda'),
            );
          }),
        ),
      ],
    );
  }
}
