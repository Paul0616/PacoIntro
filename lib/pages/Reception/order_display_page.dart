import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/pages/Reception/order_summary_page.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
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
    final OrderModel orderModel = ModalRoute.of(context).settings.arguments;
    print('Order ID: ${orderModel.id}');
    return Scaffold(
      body: Column(
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
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildOrderWidget(orderModel),
                ),
              ),
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildOrderWidget(OrderModel order) {
    return Column(
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
                  order != null
                      ? '${order.orderNumber}/${order.orderDateString}'
                      : '',
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
                child: StreamBuilder<ApiResponse<int>>(
                    stream: _bloc.ordersCount,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return Center(
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(pacoLightGray),
                                  )),
                            );
                            break;
                          case Status.COMPLETED:
                          case Status.ERROR:
                            StreamSubscription<String> subscriptionError;
                            subscriptionError =
                                _bloc.errorOccur.listen((message) {
                              if (message.isNotEmpty) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(message),
                                ));
                                _bloc.deleteError();
                              }
                              subscriptionError.cancel();
                            });
                        }
                      }
                      return Column(
                        children: <Widget>[
                          Text(
                            snapshot.hasData &&
                                    snapshot.data.status == Status.COMPLETED
                                ? snapshot.data.data.toString()
                                : '0',
                            style: textStyleBold.copyWith(
                                fontSize: 16, color: pacoLightGray),
                          ),
                          Text(
                            'produse',
                            style: textStyle.copyWith(
                                fontSize: 10, color: pacoLightGray),
                          ),
                        ],
                      );
                    }),
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
                order != null ? order.supplierName : '',
                style: textStyleBold.copyWith(
                  fontSize: 16,
                ),
              ),
              Text(
                order != null ? 'Cod fiscal: ${order.supplierFiscalCode}' : '',
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
          //autofocus: true,
          onChanged: _bloc.invoiceNumberChanged,
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
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<String>(
                        stream: _bloc.invoiceDate,
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.hasData ? snapshot.data : 'Data facturii:',
                            style: textStyle.copyWith(
                              fontSize: 16,
                            ),
                          );
                        }),
                  ),
                  GestureDetector(
                    onTap: () async {
                      print('tap');
                      _bloc.sinkInvoiceDate(await getDate());
                    },
                    child: CircleAvatar(
                      radius: 12,
                      child: Icon(
                        Icons.calendar_view_day,
                        size: 20,
                      ),
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
              stream: _bloc.submitInvoiceInfo,
              builder: (context, snapshot) {
                return FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    // side: BorderSide(color: pacoAppBarColor),
                  ),
                  onPressed: snapshot.hasData && snapshot.data
                      ? () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final navKey = NavKey.navKey;
                          navKey.currentState.pushNamed(OrderSummaryPage.route);
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
