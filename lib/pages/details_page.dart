import 'package:flutter/material.dart';
import 'package:mccounting_text/mccounting_text.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/last_input_product_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/sales_product_model.dart';
import 'package:pacointro/models/stock_product_model.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  static String route = "/DetailsPage";

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  MainBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<MainBloc>(context);
    super.didChangeDependencies();
  }

//  Future<void> showAlert(
//      BuildContext context, String title, String content, Function onPressed) {
//    return showDialog<void>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text(title ?? ''),
//          content: Text(content ?? ''),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('OK'),
//              onPressed: onPressed,
//            ),
//            FlatButton(
//              child: Text('Renunță'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TopBar(
              withBackNavigation: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'DENUMIRE PRODUS',
                                    style: textStyle,
                                  ),
                                  StreamBuilder<ApiResponse<ProductModel>>(
                                      stream: _bloc.currentProductStream,
                                      builder: (context, snapshot) {
                                        return snapshot.hasData &&
                                                snapshot.data != null
                                            ? Text('${snapshot.data.data.name}',
                                                textAlign: TextAlign.start,
                                                style: textStyle.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 24,
                                                    color: pacoAppBarColor))
                                            : Container();
                                      }),
                                ],
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              color: Colors.white,
                              elevation: 4,
                              child: Text('LA COS'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    StreamBuilder<ApiResponse<StockProductModel>>(
                        stream: _bloc.currentStockStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                );
                                break;
                              case Status.COMPLETED:
                                return _buildStockProduct(snapshot.data.data);
                                break;
                              case Status.ERROR:
                                return Text(snapshot.data.message,
                                    style: textStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: pacoRedDisabledColor,
                                    ));
                                break;
                            }
                          }
                          return Container();
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    StreamBuilder<ApiResponse<LastInputProductModel>>(
                        stream: _bloc.currentLastInputStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                );
                                break;
                              case Status.COMPLETED:
                                return Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'ULTIMA INTRARE',
                                            style: textStyle,
                                          ),
                                          Text(
                                            DateFormat('dd.MM.yyyy').format(
                                                snapshot
                                                    .data.data.lastInputDate),
                                            style: textStyle.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 28,
                                                color: pacoAppBarColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {},
                                      color: Colors.white,
                                      elevation: 4,
                                      child: Text('LA COS'),
                                    ),
                                  ],
                                );
                                break;
                              case Status.ERROR:
                                return Text(snapshot.data.message,
                                    style: textStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: pacoRedDisabledColor,
                                    ));
                                break;
                            }
                          }
                          return Container();
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    StreamBuilder<ApiResponse<SalesProductModel>>(
                        stream: _bloc.currentSalesStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                );
                                break;
                              case Status.COMPLETED:
                                return Column(
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          StreamBuilder<DateTime>(
                                            stream: _bloc.startDate,
                                            builder: (context, snapshotStartDate) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  _bloc.sinkStartDate(await getDate(initialDate: snapshotStartDate.data??DateTime.now()));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(border: Border.all(color: pacoRedDisabledColor, width: 1.0)),
                                                  child: Text(
                                                    DateFormat('dd.MM.yyyy').format(
                                                        snapshotStartDate.data??DateTime.now()),
                                                    style: textStyle.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 18,
                                                        color: pacoAppBarColor),
                                                  ),
                                                ),
                                              );
                                            }
                                          ),

                                          StreamBuilder<DateTime>(
                                            stream: _bloc.endDate,
                                            builder: (context, snapshotEndDate) {
                                              return GestureDetector(
                                                onTap:() async{
                                                  _bloc.sinkEndDate(await getDate(initialDate: snapshotEndDate.data??DateTime.now()));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(border: Border.all(color: pacoRedDisabledColor, width: 1.0)),
                                                  child: Text(
                                                    DateFormat('dd.MM.yyyy').format(
                                                        snapshotEndDate.data??DateTime.now()),
                                                    style: textStyle.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 18,
                                                        color: pacoAppBarColor),
                                                  ),
                                                ),
                                              );
                                            }
                                          ),

                                          MaterialButton(
                                            onPressed: (){
                                              print('refresh');
                                              _bloc.refreshSales();
                                            },
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: pacoAppBarColor,
                                              child: Icon(Icons.refresh, color: pacoLightGray,),
                                            ),
                                          ),
                                        ]),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'VÂNZĂRI ÎN PERIOADĂ',
                                                style: textStyle,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  McCountingText(
                                                    begin: 0,
                                                    end: snapshot
                                                            .data.data.sales ??
                                                        0,
                                                    //snapshot.data.data.price,
                                                    precision: 2,
                                                    style: textStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 28,
                                                        color: pacoAppBarColor),
                                                    duration:
                                                        Duration(seconds: 1),
                                                    curve: Curves.decelerate,
                                                  ),
                                                  Text(
                                                    " ${snapshot.data.data.measureUnit}",
                                                    style: textStyle,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () {},
                                          color: Colors.white,
                                          elevation: 4,
                                          child: Text('LA COS'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                                break;
                              case Status.ERROR:
                                return Text(snapshot.data.message,
                                    style: textStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: pacoRedDisabledColor,
                                    ));
                                break;
                            }
                          }
                          return Container();
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildStockProduct(StockProductModel stockProduct) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'STOC la data: ${DateFormat('dd.MM.yyyy').format(stockProduct.stockDate)}',
                style: textStyle,
              ),
              Row(
                children: <Widget>[
                  stockProduct.stock != null
                      ? McCountingText(
                          begin: 0,
                          end: stockProduct.stock ?? 0,
                          precision: 2,
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              color: pacoAppBarColor),
                          duration: Duration(seconds: 1),
                          curve: Curves.decelerate,
                        )
                      : Text(
                          '-',
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              color: pacoAppBarColor),
                        ),
                  Text(
                    " ${stockProduct.measureUnit}",
                    style: textStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
        MaterialButton(
          onPressed: () {},
          color: Colors.white,
          elevation: 4,
          child: Text('LA COS'),
        ),
      ],
    );
  }

  Future<DateTime> getDate({DateTime initialDate}) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 90)),
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
