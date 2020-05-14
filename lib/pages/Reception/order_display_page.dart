import 'package:flutter/material.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/order_model.dart';

import 'package:pacointro/pages/CheckProducts/check_products_page.dart';
import 'package:pacointro/repository/api_response.dart';

import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/menu_button_widget.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class OrderDisplayPage extends StatefulWidget {
  static String route = '/OrderDisplayPage';

  @override
  _OrderDisplayPageState createState() => _OrderDisplayPageState();
}

class _OrderDisplayPageState extends State<OrderDisplayPage> {
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
                  padding: const EdgeInsets.all(16),
                  child: _displayOrderWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _displayOrderWidget() {
    return StreamBuilder<ApiResponse<OrderModel>>(
        stream: _bloc.order,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case Status.COMPLETED:
                return _buildOrderWidget(snapshot.data.data);
                break;
              case Status.ERROR:
                // TODO: Handle this case.
                break;
            }
          }
          return Container();
        });
  }

  Widget _buildOrderWidget(OrderModel order) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Comanda numărul din data:',
              style: textStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: pacoRedDisabledColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(25.0) //         <--- border radius here
                  ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${order.orderNumber}/${order.orderDateString}',
                    style: textStyleBold.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: pacoAppBarColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '19',
                        style: textStyleBold.copyWith(
                            fontSize: 16, color: pacoLightGray),
                      ),
                      Text(
                        'produse',
                        style: textStyle.copyWith(
                            fontSize: 10, color: pacoLightGray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Furnizor:',
              style: textStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: pacoRedDisabledColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(25.0) //         <--- border radius here
                  ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.supplierName,
                  style: textStyleBold.copyWith(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Cod fiscal: ${order.supplierFiscalCode}',
                  style: textStyle.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
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
              hintText: "Numărul facturii:",
              hintStyle: textStyle,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: pacoLightGray,
              borderRadius: BorderRadius.all(
                  Radius.circular(25.0) //         <--- border radius here
                  ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Data facturii:',
                        style: textStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 12,
                      child: Icon(
                        Icons.calendar_view_day,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
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
                          }
                        : null,
                    disabledColor: pacoAppBarColor.withOpacity(0.5),
                    disabledTextColor: pacoRedDisabledColor,
                    color: pacoAppBarColor,
                    textColor: Colors.white,
                    child: Text('Începe recepție'),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
