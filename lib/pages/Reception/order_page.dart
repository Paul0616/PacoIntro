import 'package:flutter/material.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/location_model.dart';

import 'package:pacointro/pages/CheckProducts/check_products_page.dart';

import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/menu_button_widget.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  static String route = '/OrderPage';

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
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
                  child: _inputOrderWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _inputOrderWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          //controller: _controller,
          autofocus: true,
          onChanged:  _bloc.orderNumberValidation,
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
