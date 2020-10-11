import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/api_call_event.dart';
import 'package:pacointro/blocs/api_call_state.dart';
import 'package:pacointro/blocs/home_bloc.dart';
import 'package:pacointro/blocs/home_event.dart';
import 'package:pacointro/blocs/home_state.dart';
import 'package:pacointro/blocs/order_summary_bloc.dart';
import 'package:pacointro/blocs/order_summary_event.dart';
import 'package:pacointro/blocs/order_summary_state.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/paginated_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/progress_model.dart';
import 'package:pacointro/pages/Reception/input_quantity_page.dart';
import 'package:pacointro/pages/Reception/list_products.dart';
import 'package:pacointro/repository/api_response1.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class OrderSummaryPage extends StatefulWidget {
  static String route = '/OrderSummaryPage';

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  // MainBloc _bloc;
  // StreamSubscription<ApiResponse1<ProductModel>> subscription;
  HomeBloc _homeBloc = HomeBloc();
  ApiCallBloc _apiCallBloc = ApiCallBloc();
  OrderSummaryBloc _orderSummaryBloc = OrderSummaryBloc();

  //int currentScan = 0;

  @override
  void didChangeDependencies() {
    // _bloc = Provider.of<MainBloc>(context);
    // _bloc.getCurrentLocation();
    // _bloc.setCurrentProduct(null);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // subscription = _bloc.currentProductStream.listen((result) {
    //   if (result != null && result.status == Status.COMPLETED) {
    //     if (!result.data.belongsToOrder) {
    //       if (result.data.name == 'Produs inexistent în Contliv')
    //         showAlert(context, 'Confirmare',
    //             'Produsul nu există în Contliv. Vrei să-l recepționezi totuși?',
    //             () {
    //           Navigator.of(context).pop();
    //           final navKey = NavKey.navKey;
    //           navKey.currentState
    //               .pushNamed(InputQuantityPage.route, arguments: result.data);
    //         });
    //       else if (result.data.name == null)
    //         showAlert(context, 'Confirmare',
    //             'Produsul scanat nu se regăsește pe comandă. Vrei să-l caut în ContLiv?',
    //             () {
    //           _bloc.getProductFromApi(result.data.id.toString());
    //           Navigator.of(context).pop();
    //         });
    //       else {
    //         final navKey = NavKey.navKey;
    //         navKey.currentState
    //             .pushNamed(InputQuantityPage.route, arguments: result.data);
    //       }
    //     } else {
    //       final navKey = NavKey.navKey;
    //       navKey.currentState
    //           .pushNamed(InputQuantityPage.route, arguments: result.data);
    //     }
    //   }
    // });
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _apiCallBloc,
          ),
          BlocProvider(
            create: (_) => _homeBloc,
          ),
          BlocProvider(
            create: (_) => _orderSummaryBloc,
          ),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TopBar(
              withBackNavigation: true,
            ),
            BlocListener<HomeBloc, HomeState>(
              listener: _onScannerListener,
              child:
                  BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                var currentLocationName = '';
                if (state is EmptyState) {
                  _homeBloc.add(InitCurrentLocationEvent());
                }
                if (state is LocationInitiatedState) {
                  currentLocationName = state.location.name;
                  _orderSummaryBloc.add(ProgressRefreshEvent());
                }

                return Text('Magazin: $currentLocationName',
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: pacoAppBarColor));
              }),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildBody(context),
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

  Widget _buildBody(BuildContext context) {
    return BlocListener<OrderSummaryBloc, OrderSummaryState>(
      listener: _onListener,
      child: BlocListener<ApiCallBloc, ApiCallState>(
        listener: _onApiCallListener,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: OutlineButton(
                      onPressed: () {
                        final navKey = NavKey.navKey;
                        navKey.currentState.pushNamed(ListProductsPage.route,
                            arguments: false);
                      },
                      child: Text(
                        'COMANDĂ vs. RECEPȚIE',
                        style: textStyleBold,
                        textAlign: TextAlign.center,
                      ),
                      borderSide: BorderSide(color: pacoAppBarColor),
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: OutlineButton(
                      onPressed: () {
                        final navKey = NavKey.navKey;
                        navKey.currentState
                            .pushNamed(ListProductsPage.route, arguments: true);
                      },
                      child: Text(
                        'Vezi produsele deja scanate',
                        style: textStyleBold,
                        textAlign: TextAlign.center,
                      ),
                      borderSide: BorderSide(color: pacoAppBarColor),
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            BlocBuilder<ApiCallBloc, ApiCallState>(builder: (context, state) {
              if (state is ApiCallLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
              // return BlocBuilder<ProgressModel>(
              //     stream: _bloc.scanningProgress,
              //     builder: (context, snapshot) {
              //       return CircularPercentIndicator(
              //         radius: 130.0,
              //         animation: true,
              //         animationDuration: 1200,
              //         lineWidth: 15.0,
              //         percent: snapshot.hasData
              //             ? snapshot.data != null && snapshot.data.ratio > 1
              //                 ? 1.0
              //                 : snapshot.data.ratio
              //             : 0.0,
              //         center: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Text(
              //               snapshot.hasData
              //                   ? "${snapshot.data.current}/${snapshot.data.max}"
              //                   : "0/0",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold, fontSize: 20.0),
              //             ),
              //             Text(
              //               "produse",
              //               style: textStyle,
              //             ),
              //           ],
              //         ),
              //         circularStrokeCap: CircularStrokeCap.butt,
              //         backgroundColor: Colors.yellow,
              //         progressColor:
              //             snapshot.data != null && snapshot.data.ratio > 1
              //                 ? Colors.green
              //                 : Colors.red,
              //       );
              //     });
            }),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    child: Image(
                      image: AssetImage('images/barcode_scan.png'),
                      color: pacoLightGray,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "Scaneaza cod produs",
                    style: textStyleBold.copyWith(color: pacoLightGray),
                  ),
                ],
              ),
              color: pacoAppBarColor,
              elevation: 4,
              onPressed: () {
                // _bloc.scan(SearchType.FROM_RECEPTION);
                _homeBloc.add(ScanBarcodeEvent());
              },
            ),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                // side: BorderSide(color: pacoAppBarColor),
              ),
              onPressed: () {},
              disabledColor: pacoAppBarColor.withOpacity(0.5),
              disabledTextColor: pacoRedDisabledColor,
              color: pacoAppBarColor,
              textColor: Colors.white,
              child: Text('Finalizează recepție'),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> showAlert(
  //     BuildContext context, String title, String content, Function onPressed) {
  //   return showDialog<void>(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title ?? ''),
  //         content: Text(content ?? ''),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('OK'),
  //             onPressed: onPressed,
  //           ),
  //           FlatButton(
  //             child: Text('Renunță'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void dispose() {
    //subscription?.cancel();
    super.dispose();
  }

  _onScannerListener(BuildContext context, HomeState state) {
    if (state is ScanningErrorState) {
      if (state.message.isNotEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(state.message),
        ));
      }
    }
    if (state is ScanningSuccessfullyState) {
      _orderSummaryBloc
          .add(FindProductInOrderEvent(int.tryParse(state.barcode) ?? 0));
    }
  }

  _onApiCallListener(BuildContext context, ApiCallState state) {
    if (state is ApiCallErrorState) {
      if (state.message.isNotEmpty) {
        if (state.message.contains('Nu am găsit nume/cod')) {
          dialogAlert(
              context,
              'Confirmare',
              Text('Produsul nu există în Contliv. '
                  'Vrei să-l recepționezi totuși?'), onPressedPositive: () {
            Navigator.of(context).pop();
            var messageList = state.message.split('\'');
            var barCode = messageList
                .firstWhere((element) => int.tryParse(element) != null);
            var product = ProductModel(
              id: int.tryParse(barCode) ?? 0,
              name: "Produs inexistent în Contliv",
              quantity: 0,
              belongsToOrder: false,
              productType: ProductType.RECEPTION,
            );
            final navKey = NavKey.navKey;
            navKey.currentState
                .pushNamed(InputQuantityPage.route, arguments: product);
          }, onPressedNegative: () {
            Navigator.of(context).pop();
          });
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      }
    }
    if (state is ApiCallLoadedState) {
      final navKey = NavKey.navKey;
      navKey.currentState.pushNamed(InputQuantityPage.route,
          arguments: (state.response as PaginatedModel).products.first);
    }
  }

  _onListener(BuildContext context, OrderSummaryState state) {
    if (state is ProductBelongOrderState) {
      if (!state.product.belongsToOrder) {
        dialogAlert(
            context,
            'Confirmare',
            Text('Produsul scanat nu se regăsește pe comandă. '
                'Vrei să-l caut totuși în ContLiv?'), onPressedPositive: () {
          Navigator.of(context).pop();
          _apiCallBloc.add(GetProductsEvent(
              SearchType.BY_CODE, state.product.id.toString(), 1));
        }, onPressedNegative: () {
          Navigator.of(context).pop();
        });
      } else {
        final navKey = NavKey.navKey;
        navKey.currentState
            .pushNamed(InputQuantityPage.route, arguments: state.product);
      }
    }
  }
}
