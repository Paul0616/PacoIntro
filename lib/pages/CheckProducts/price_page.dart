import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mccounting_text/mccounting_text.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/api_call_state.dart';
import 'package:pacointro/blocs/api_call_event.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/pages/CheckProducts/details_page.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/top_bar.dart';

class PricePage extends StatefulWidget {
  static String route = "/PricePage";

  @override
  _PricePageState createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  ProductModel _currentProduct;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _currentProduct = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: BlocProvider(
        create: (_) => ApiCallBloc(),
        child: BlocListener<ApiCallBloc, ApiCallState>(
          listener: _onApiListener,
          child:
              BlocBuilder<ApiCallBloc, ApiCallState>(builder: (context, state) {
            if (state is ApiCallLoadingState) {
              return Center(
                child: Container(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TopBar(
                    withBackNavigation: true,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'DENUMIRE PRODUS',
                                style: textStyle,
                              ),
                              // StreamBuilder<ApiResponse1<ProductModel>>(
                              //     stream: _bloc.currentProductStream,
                              //     builder: (context, snapshot) {
                              //       return snapshot.hasData && snapshot.data != null
                              _currentProduct != null
                                  ? Text('${_currentProduct.name}',
                                      textAlign: TextAlign.center,
                                      style: textStyle.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 30,
                                          color: pacoAppBarColor))
                                  : Container(),
                              //     }),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'PREȚ',
                                style: textStyle,
                              ),
                              // StreamBuilder<ApiResponse1<ProductModel>>(
                              //     stream: _bloc.currentProductStream,
                              //     builder: (context, snapshot) {
                              //       return snapshot.hasData && snapshot.data != null
                              _currentProduct != null
                                  ? Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: pacoAppBarColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: McCountingText(
                                        begin: 0,
                                        end: _currentProduct.price,
                                        precision: 2,
                                        style: textStyle.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 42,
                                            color: pacoLightGray),
                                        duration: Duration(seconds: 1),
                                        curve: Curves.decelerate,
                                      ),
                                    )
                                  : Container(),
                              //     }),
                              // StreamBuilder<ApiResponse1<ProductModel>>(
                              //     stream: _bloc.currentProductStream,
                              //     builder: (context, snapshot) {
                              //       return snapshot.hasData && snapshot.data != null
                              _currentProduct != null
                                  ? Text('/${_currentProduct.measureUnit}')
                                  : Container(),
                              //     }),
                            ],
                          ),
                          RawMaterialButton(
                            onPressed: () {
                              dialogAlert(
                                  context,
                                  'Confirmare',
                                  Text(
                                      'Produsul va fi trimis la coș cu eticheta \"PREȚ INCORECT\". Vrei să faci asta?'),
                                  onPressedPositive: () {
                                BlocProvider.of<ApiCallBloc>(context).add(
                                    PutProductWithIssueEvent(
                                        _currentProduct.id,
                                        productStatus(
                                            ProductStatus.WRONG_PRICE)));
                                Navigator.of(context).pop();
                              }, onPressedNegative: () {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text(
                              'Adaugă\nla coș',
                              textAlign: TextAlign.center,
                              style: textStyleBold,
                            ),
                            shape: new CircleBorder(
                                side: BorderSide(
                                    color: pacoAppBarColor, width: 2)),
                            elevation: 4.0,
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(30.0),
                          ),
                          OutlineButton(
                            onPressed: () {
                              final navKey = NavKey.navKey;
                              navKey.currentState.pushNamed(DetailsPage.route,
                                  arguments: _currentProduct);
                            },
                            child: Text('Alte detalii'),
                            borderSide: BorderSide(
                                color: pacoAppBarColor.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _onApiListener(BuildContext context, ApiCallState state) {
    if (state is ApiCallErrorState) {
      if (state.message.isNotEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(state.message),
        ));
      }
    }
    if (state is ApiCallLoadedState) {
      if (state.response['message'] == 'Produs adaugat cu succes') {
        dialogAlert(
          context,
          'SUCCES',
          Text("Solicitarea a fost trimisa pe server.",
              style: TextStyle(color: Colors.green)),
          onPressedPositive: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
    // final navKey = NavKey.navKey;
    // navKey.currentState.pushNamed(PricePage.route,
    //     arguments: (state.response as PaginatedModel).products.first);
  }
}
