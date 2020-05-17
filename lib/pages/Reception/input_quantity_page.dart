import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/pages/Reception/order_summary_page.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class InputQuantityPage extends StatefulWidget {
  static String route = '/InputQuantityPage';

  @override
  _InputQuantityPageState createState() => _InputQuantityPageState();
}

class _InputQuantityPageState extends State<InputQuantityPage> {
  MainBloc _bloc;
  TextEditingController _quantityController = TextEditingController();
  @override
  void didChangeDependencies() {
    _bloc = Provider.of<MainBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ProductModel productModel = ModalRoute.of(context).settings.arguments;
    if(productModel.productType == ProductType.RECEPTION) {
      _bloc.quantityChanged(productModel.quantity.toString());
      _quantityController.text = productModel.quantity.toString();
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TopBar(
            withBackNavigation: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildQuantityWidget(productModel),
                ),
              ),
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildQuantityWidget(ProductModel product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(product.name != null ? product.name + " (" + product.measureUnit + ")" : "", style: textStyleBold,),
        TextFormField(
          controller: _quantityController,
          autofocus: true,
          onChanged: _bloc.quantityChanged,
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
            hintText: "Catitatea recepționată:",
            hintStyle: textStyle,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: StreamBuilder<bool>(
              stream: _bloc.quantityValidation,
              builder: (context, snapshot) {
                return FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    // side: BorderSide(color: pacoAppBarColor),
                  ),
                  onPressed: snapshot.hasData && snapshot.data
                      ? () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    _bloc.saveReception(product);
                    _bloc.setCurrentProduct(null);
                    final navKey = NavKey.navKey;
                    navKey.currentState.pop();
                  }
                      : null,
                  disabledColor: pacoAppBarColor.withOpacity(0.5),
                  disabledTextColor: pacoRedDisabledColor,
                  color: pacoAppBarColor,
                  textColor: Colors.white,
                  child: Text('Salveaza'),
                );
              }),
        ),
      ],
    );
  }

  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 10)),
      //  DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }
}
