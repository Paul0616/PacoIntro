import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mccounting_text/mccounting_text.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/api_call_event.dart';
import 'package:pacointro/blocs/api_call_state.dart';
import 'package:pacointro/blocs/detail_bloc.dart';
import 'package:pacointro/blocs/detail_event.dart';
import 'package:pacointro/blocs/detail_state.dart';
import 'package:pacointro/models/last_input_product_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/sales_product_model.dart';
import 'package:pacointro/models/stock_product_model.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/top_bar.dart';

class DetailsPage extends StatefulWidget {
  static String route = "/DetailsPage";

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  ProductModel _currentProduct;
  DateTime currentStartDate, currentEndDate;

  //final Repository _repository = Repository(httpClient: http.Client());

  // StockProductModel _stockProductModel;

  // LastInputProductModel _lastInputProductModel;

  @override
  void didChangeDependencies() {
    // _bloc = Provider.of<MainBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _currentProduct = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => DetailBloc(),
          ),
          BlocProvider(
            create: (_) => ApiCallBloc(),
          ),
          BlocProvider(
            create: (_) => ApiCallBloc1(),
          ),
          BlocProvider(
            create: (_) => ApiCallBloc2(),
          ),
          BlocProvider(
            create: (_) => ApiCallBloc3(),
          ),
        ],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TopBar(
                withBackNavigation: true,
              ),
              BlocListener<ApiCallBloc, ApiCallState>(
                listener: (context, state) {
                  _onApiListener(context, state, true);
                },
                child: BlocBuilder<ApiCallBloc, ApiCallState>(
                    builder: (context, apiState) {
                  if (apiState is ApiCallEmptyState) {
                    BlocProvider.of<ApiCallBloc1>(context)
                        .add(GetProductDetailsEvent(_currentProduct.code));
                    BlocProvider.of<ApiCallBloc2>(context)
                        .add(LastInputEvent(_currentProduct.code));
                    BlocProvider.of<ApiCallBloc3>(context).add(
                        GetSalesInPeriodEvent(
                            code: _currentProduct.code,
                            startDate: DateTime.now(),
                            endDate: DateTime.now()));
                  }
                  if (apiState is ApiCallLoadingState) {
                    return Expanded(
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        children: <Widget>[
                          _buildProductName(context),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          _buildStockProduct(context),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          _buildLastInputDate(context),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          _buildSalesInPeriod(context),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildProgress() {
    return Row(
      children: <Widget>[
        Container(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildProductName(BuildContext context) {
    return Column(
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
                  Text('${_currentProduct.name}',
                      textAlign: TextAlign.start,
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: pacoAppBarColor)),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                dialogAlert(
                    context,
                    'Confirmare',
                    Text(
                        'Produsul va fi trimis la coș cu eticheta \"DENUMIRE INCORECTĂ\". Vrei să faci asta?'),
                    onPressedPositive: () {
                  BlocProvider.of<ApiCallBloc>(context).add(
                      PutProductWithIssueEvent(_currentProduct.code,
                          productStatus(ProductStatus.WRONG_NAME)));
                  Navigator.of(context).pop();
                });
              },
              color: Colors.white,
              elevation: 4,
              child: Text('LA COS'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStockProduct(BuildContext context) {
    return BlocListener<ApiCallBloc1, ApiCallState>(
      listener: (context, state) {
        _onApiListener(context, state, false);
      },
      child: BlocBuilder<ApiCallBloc1, ApiCallState>(builder: (context, state) {
        StockProductModel stockProduct;
        if (state is ApiCallLoadingState) {
          return _buildProgress();
        }
        if (state is ApiCallLoadedState) {
          stockProduct = state.response;
        }
        return Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'STOC la data: ${DateFormat('dd.MM.yyyy').format(stockProduct != null ? stockProduct.stockDate : DateTime.now())}',
                    style: textStyle,
                  ),
                  Row(
                    children: <Widget>[
                      stockProduct != null
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
                        " ${stockProduct != null ? stockProduct.measureUnit : ''}",
                        style: textStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                dialogAlert(
                    context,
                    'Confirmare',
                    Text(
                        'Produsul va fi trimis la coș cu eticheta \"STOC INCORECT\". Vrei să faci asta?'),
                    onPressedPositive: () {
                  BlocProvider.of<ApiCallBloc>(context).add(
                      PutProductWithIssueEvent(_currentProduct.code,
                          productStatus(ProductStatus.WRONG_STOCK)));
                  Navigator.of(context).pop();
                });
              },
              color: Colors.white,
              elevation: 4,
              child: Text('LA COS'),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLastInputDate(BuildContext context) {
    return BlocListener<ApiCallBloc2, ApiCallState>(
      listener: (context, state) {
        _onApiListener(context, state, false);
      },
      child: BlocBuilder<ApiCallBloc2, ApiCallState>(builder: (context, state) {
        LastInputProductModel lastInputProductModel;
        if (state is ApiCallLoadingState) {
          return _buildProgress();
        }
        if (state is ApiCallLoadedState) {
          lastInputProductModel = state.response;
        }
        return Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'ULTIMA INTRARE',
                    style: textStyle,
                  ),
                  lastInputProductModel != null
                      ? Text(
                          DateFormat('dd.MM.yyyy')
                              .format(lastInputProductModel.lastInputDate),
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              color: pacoAppBarColor),
                        )
                      : Text(
                          '-',
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              color: pacoAppBarColor),
                        ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                dialogAlert(
                    context,
                    'Confirmare',
                    Text(
                        'Produsul va fi trimis la coș cu eticheta \"DATA ULTIMEI INTRARI INCORECTĂ\". Vrei să faci asta?'),
                    onPressedPositive: () {
                  BlocProvider.of<ApiCallBloc>(context).add(
                      PutProductWithIssueEvent(_currentProduct.code,
                          productStatus(ProductStatus.WRONG_INPUT_DATE)));
                  Navigator.of(context).pop();
                });
              },
              color: Colors.white,
              elevation: 4,
              child: Text('LA COS'),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSalesInPeriod(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
            Widget>[
          BlocBuilder<DetailBloc, DetailState>(builder: (context, state) {
            //DateTime startDate;
            // if (state is EmptyState) {
            //   startDate = currentStartDate;//state.date;
            // }
            if (state is RefreshDateState) {
              currentStartDate = state.startDate;
            }
            return GestureDetector(
              onTap: () async {
                //if(currentStartDate)
                var pickerDate = await getDate(
                  initialDate: currentStartDate ??
                      DateTime.now().subtract(Duration(days: 1)),
                  lastDate: (currentEndDate ?? DateTime.now())
                );
                BlocProvider.of<DetailBloc>(context).add(
                  ChangeDateEvent(
                    startDate: pickerDate,
                    endDate: (currentEndDate ?? DateTime.now()),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: pacoRedDisabledColor, width: 1.0)),
                child: Text(
                  DateFormat('dd.MM.yyyy').format(currentStartDate ??
                      DateTime.now().subtract(Duration(days: 1))),
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: pacoAppBarColor),
                ),
              ),
            );
          }),
          BlocBuilder<DetailBloc, DetailState>(builder: (context, state) {
            // DateTime endDate;
            // if (state is EmptyState) {
            //   endDate = state.date;
            // }
            if (state is RefreshDateState) {
              currentEndDate = state.endDate;
            }
            return GestureDetector(
              onTap: () async {
                var pickerDate = await getDate(
                    initialDate: currentEndDate ??
                        DateTime.now(),
                    lastDate: DateTime.now()
                );
                // if(pickerDate.compareTo(currentEndDate ?? DateTime.now()) > 0){
                //   pickerDate = currentEndDate;
                // }
                if(pickerDate.compareTo(currentStartDate ?? DateTime.now().subtract(Duration(days: 1))) < 0){
                  currentStartDate = pickerDate;
                }
                BlocProvider.of<DetailBloc>(context).add(
                  ChangeDateEvent(
                    startDate: currentStartDate ??
                        DateTime.now().subtract(Duration(days: 1)),
                    endDate: pickerDate,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: pacoRedDisabledColor, width: 1.0)),
                child: Text(
                  DateFormat('dd.MM.yyyy')
                      .format(currentEndDate ?? DateTime.now()),
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: pacoAppBarColor),
                ),
              ),
            );
          }),
          BlocBuilder<ApiCallBloc3, ApiCallState>(builder: (context, state) {
            bool refreshButtonActive;
            print(refreshButtonActive);
            if (state is ApiCallLoadingState) {
              refreshButtonActive = false;
              print(refreshButtonActive);
            }
            if (state is ApiCallLoadedState) {
              refreshButtonActive = true;
              print(refreshButtonActive);
            }
            return MaterialButton(
              onPressed: refreshButtonActive ?? true
                  ? () {
                      print('refresh');
                      BlocProvider.of<ApiCallBloc3>(context).add(
                          GetSalesInPeriodEvent(
                              code: _currentProduct.code,
                              startDate: BlocProvider.of<DetailBloc>(context)
                                  .startDate,
                              endDate: BlocProvider.of<DetailBloc>(context)
                                  .endDate));
                    }
                  : null,
              child: CircleAvatar(
                radius: 20,
                backgroundColor:
                    refreshButtonActive ?? true ? pacoAppBarColor : Colors.grey,
                child: Icon(
                  Icons.refresh,
                  color: pacoLightGray,
                ),
              ),
            );
          }),
        ]),
        SizedBox(
          height: 16,
        ),
        BlocListener<ApiCallBloc3, ApiCallState>(
          listener: (context, state) {
            _onApiListener(context, state, false);
          },
          child: BlocBuilder<ApiCallBloc3, ApiCallState>(
              builder: (context, state) {
            SalesProductModel salesProductModel;
            if (state is ApiCallLoadingState) {
              return _buildProgress();
            }
            if (state is ApiCallLoadedState) {
              salesProductModel = state.response;
            }
            return Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'VÂNZĂRI ÎN PERIOADĂ',
                        style: textStyle,
                      ),
                      Row(
                        children: <Widget>[
                          salesProductModel != null
                              ? McCountingText(
                                  begin: 0,
                                  end: salesProductModel.sales ?? 0,
                                  //snapshot.data.data.price,
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
                            " ${salesProductModel != null ? salesProductModel.measureUnit : ''}",
                            style: textStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    dialogAlert(
                        context,
                        'Confirmare',
                        Text(
                            'Produsul va fi trimis la coș cu eticheta \"VÂNZARE ÎN PERIOADĂ INCORECTĂ\". Vrei să faci asta?'),
                        onPressedPositive: () {
                      BlocProvider.of<ApiCallBloc>(context).add(
                          PutProductWithIssueEvent(
                              _currentProduct.code,
                              productStatus(
                                  ProductStatus.WRONG_SALE_IN_PERIOD)));
                      Navigator.of(context).pop();
                    });
                  },
                  color: Colors.white,
                  elevation: 4,
                  child: Text('LA COS'),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Future<DateTime> getDate({DateTime initialDate, DateTime lastDate}) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      //  DateTime(DateTime.now().year),
      lastDate: lastDate,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  _onApiListener(BuildContext context, ApiCallState state, bool isApiCallBloc) {
    if (state is ApiCallErrorState) {
      if (state.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.message),
        ));
      }
    }
    if (state is ApiCallLoadedState && isApiCallBloc) {
      if (state.response['message'] == 'Produs adaugat cu succes') {
        dialogAlert(
          context,
          'SUCCES',
          Text(
            "Solicitarea a fost trimisa pe server.",
            style: TextStyle(color: Colors.green),
          ),
          onPressedPositive: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }
}
