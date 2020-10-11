import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/input_quantity_bloc.dart';
import 'package:pacointro/blocs/input_quantity_event.dart';
import 'package:pacointro/blocs/input_quantity_state.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/top_bar.dart';

class InputQuantityPage extends StatefulWidget {
  static String route = '/InputQuantityPage';

  @override
  _InputQuantityPageState createState() => _InputQuantityPageState();
}

class _InputQuantityPageState extends State<InputQuantityPage> {
  InputQuantityBloc _bloc = InputQuantityBloc();
  TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ProductModel productModel = ModalRoute.of(context).settings.arguments;
    if (productModel.productType == ProductType.RECEPTION) {
      _quantityController.text = productModel.quantity.toString();
      _bloc.add(QuantityChangeEvent(productModel.quantity.toString()));
    }
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _bloc,
          )
        ],
        child: Column(
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
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildQuantityWidget(ProductModel product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          product.name != 'Produs inexistent în Contliv'
              ? product.name + " (" + product.measureUnit + ")"
              : product != null
                  ? product.name + " (" + product.code.toString() + ")"
                  : "",
          style: textStyleBold,
        ),
        TextFormField(
          controller: _quantityController,
          autofocus: true,
          onChanged: (text) {
            _bloc.add(QuantityChangeEvent(text));
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
            hintText: "Catitatea recepționată:",
            hintStyle: textStyle,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: BlocListener<InputQuantityBloc, InputQuantityState>(
            listener: (context, state){
              if(state is QuantityInputDoneState){
                Navigator.of(context).pop();
              }
            },
            child: BlocBuilder<InputQuantityBloc, InputQuantityState>(
                builder: (context, state) {
              double quantity;
              if (state is ValidationQuantityState) {
                quantity = state.quantity;
              }
              return FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  // side: BorderSide(color: pacoAppBarColor),
                ),
                onPressed: quantity != null
                    ? () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        product.quantity = quantity;
                        if(product.productType == ProductType.ORDER) product.id = null;
                        _bloc.add(SaveProductReceptionEvent(product));
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
        ),
      ],
    );
  }
}
