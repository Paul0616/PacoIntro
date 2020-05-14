import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/pages/Reception/order_display_page.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class OrderInputPage extends StatefulWidget {
  static String route = '/OrderInputPage';

  @override
  _OrderInputPageState createState() => _OrderInputPageState();
}

class _OrderInputPageState extends State<OrderInputPage> {
  MainBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<MainBloc>(context);
    _bloc.getCurrentLocation();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TopBar(
                withBackNavigation: true,
              ),
              StreamBuilder<LocationModel>(
                  stream: _bloc.currentLocationStream,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data != null
                        ? Text('Magazin: ${snapshot.data.name}',
                            style: textStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: pacoAppBarColor))
                        : Container();
                  }),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(64),
                  child: _inputOrderStreamBuilder(),
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _inputOrderStreamBuilder(){
    return StreamBuilder<ApiResponse<OrderModel>>(
      stream: _bloc.order,
      builder: (context, snapshot){
        if(snapshot.hasData) {
          switch (snapshot.data.status){

            case Status.LOADING:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case Status.COMPLETED:
            case Status.ERROR:
              StreamSubscription<String> subscriptionError;
              subscriptionError = _bloc.errorOccur.listen((message) {
                if (message.isNotEmpty)
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                  ));
                _bloc.deleteError();
                subscriptionError.cancel();
              });
          }
          return _inputOrderWidget();
        }
        return _inputOrderWidget();
      });
  }


  Widget _inputOrderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          //controller: _controller,
          autofocus: true,
          onChanged: _bloc.orderNumberValidation,
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
          child: StreamBuilder<bool>(
              stream: _bloc.loadOrderValidation,
              builder: (context, snapshot) {
                return FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    // side: BorderSide(color: pacoAppBarColor),
                  ),
                  onPressed: snapshot.hasData && snapshot.data
                      ? () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _bloc.getOrder();
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
