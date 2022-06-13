import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/api_call_event.dart';
import 'package:pacointro/blocs/api_call_state.dart';
import 'package:pacointro/blocs/home_bloc.dart';
import 'package:pacointro/blocs/home_event.dart';
import 'package:pacointro/blocs/home_state.dart';
import 'package:pacointro/blocs/invoice_bloc.dart';
import 'package:pacointro/blocs/invoice_event.dart';
import 'package:pacointro/blocs/invoice_state.dart';
import 'package:pacointro/blocs/order_summary_bloc.dart';
import 'package:pacointro/blocs/order_summary_event.dart';
import 'package:pacointro/blocs/order_summary_state.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/invoice_model.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/models/paginated_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/progress_model.dart';
import 'package:pacointro/pages/Reception/input_quantity_page.dart';
import 'package:pacointro/pages/Reception/list_products.dart';
import 'package:pacointro/pages/home_page.dart';
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
  HomeBloc _homeBloc = HomeBloc();
  InvoiceBloc _invoiceBloc = InvoiceBloc();
  ApiCallBloc _apiCallBloc = ApiCallBloc();
  OrderSummaryBloc _orderSummaryBloc = OrderSummaryBloc();
  String _manualBarcode = "";
  int _currentInvoiceId;
  bool _searchIsNotDone = true;

  @override
  Widget build(BuildContext context) {
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
          BlocProvider(
            create: (_) => _invoiceBloc,
          ),
        ],
        child: SingleChildScrollView(
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
              Container(
                //height: MediaQuery.of(context).size.height-150,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildBody(context),
                ),
              ),
            ],
          ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BlocListener<HomeBloc, HomeState>(
              listener: _onScannerListener,
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
                  builder: (context, state) {
                if (state is ValidationInvoiceState) {
                  return SizedBox(
                    height: 110,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildInvoiceInput(),
                        _buildAddInvoiceButton(
                            isValid: state.invoice?.isValid ?? false,
                            needSaveInvoice: true),
                      ],
                    ),
                  );
                }
                if (state is GetOrderState) {
                  var order = state.order;
                  if (order == null) {
                    _invoiceBloc.add(EmptyInvoiceEvent());
                  }
                  return order != null
                      ? SizedBox(
                          height: 110,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInvoicesList(context, order),
                              _buildAddInvoiceButton(needSaveInvoice: false),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 80,
                        );
                } else {
                  return SizedBox(
                    height: 80,
                  );
                }
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(10),
                        side: BorderSide(color: pacoAppBarColor),
                      ),
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
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(10),
                        side: BorderSide(color: pacoAppBarColor),
                      ),
                      onPressed: () {
                        final navKey = NavKey.navKey;
                        navKey.currentState
                            .pushNamed(ListProductsPage.route, arguments: true)
                            .then((value) {
                          _orderSummaryBloc.add(ProgressRefreshEvent());
                        });
                      },
                      child: Text(
                        'Vezi produsele deja recepționate',
                        style: textStyleBold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<ApiCallBloc, ApiCallState>(builder: (context, state) {
              if (state is ApiCallLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(
                  builder: (context, state) {
                ProgressModel progress = ProgressModel(0, 0);
                if (state is UpdateProgressState) {
                  progress = state.progressModel;
                }
                return CircularPercentIndicator(
                  radius: 130.0,
                  animation: true,
                  animationDuration: 1200,
                  lineWidth: 15.0,
                  percent: progress.ratio > 1 ? 1.0 : progress.ratio,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        progress.max != 0
                            ? "${progress.current}/${progress.max}"
                            : "0/0",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      Text(
                        "produse",
                        style: textStyle,
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.yellow,
                  progressColor: progress.ratio > 1 ? Colors.green : Colors.red,
                );
              });
            }),
            BlocBuilder<InvoiceBloc, InvoiceState>(builder: (context, state) {
              bool isValid = false;
              if (state is GetOrderState) {
                isValid = state.order?.invoices?.isNotEmpty ?? false;
                if (isValid) {
                  _currentInvoiceId = state.order.currentInvoiceId;
                } else {
                  _currentInvoiceId = null;
                }
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(8),
                          elevation: 4,
                          primary: pacoAppGreen,
                        ),
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
                              "Scaneaza barcod",
                              style:
                                  textStyleBold.copyWith(color: pacoLightGray),
                            ),
                          ],
                        ),
                        onPressed: isValid
                            ? () {
                                _homeBloc.add(ScanBarcodeEvent());
                              }
                            : null,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 14),
                          elevation: 4,
                          primary: pacoAppGreen,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 60,
                              child: Image(
                                image: AssetImage('images/barcode_manual.png'),
                                color: pacoLightGray,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              "Introdu barcod",
                              style:
                                  textStyleBold.copyWith(color: pacoLightGray),
                            ),
                          ],
                        ),
                        onPressed: isValid
                            ? () {
                                _dialogManualInputBarcode(context);
                              }
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) =>
                                      states.contains(MaterialState.disabled)
                                          ? pacoRedDisabledColor
                                          : Colors.white),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) =>
                                      states.contains(MaterialState.disabled)
                                          ? pacoAppGreen.withOpacity(0.5)
                                          : pacoAppGreen),
                        ),
                        onPressed: isValid
                            ? () {
                                _apiCallBloc.add(PostReceptionEvent());
                              }
                            : null,
                        child: Text('Finalizează recepție'),
                      ),
                      Expanded(
                        child: Align(
                          child: _buildCancelReceptionButton(context,
                              isDisabled: !isValid),
                          alignment: Alignment.centerRight,
                        ),
                      )
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  _buildInvoicesList(BuildContext context, OrderModel order) {
    return Expanded(
      child: order.invoices.isEmpty
          ? Text(
              'Trebuie sa adaugi cel putin o factura pentru a putea scana produse.',
              style: textStyle.copyWith(fontSize: 12, color: Colors.black87),
              textAlign: TextAlign.center,
            )
          : MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: order.invoices.length,
                shrinkWrap: true,
                itemExtent: 35,
                // separatorBuilder: (context, index) {
                //   return Divider();
                // },
                itemBuilder: (context, index) =>
                    _buildInvoiceTile(context, order.invoices[index]),
              ),
            ),
    );
  }

  _buildAddInvoiceButton({bool isValid = true, bool needSaveInvoice}) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.only(left: 16),
      child: RawMaterialButton(
        onPressed: isValid
            ? needSaveInvoice
                ? () {
                    _invoiceBloc.add(SaveInvoiceEvent());
                  }
                : () {
                    _invoiceBloc.add(AddNewInvoiceEvent());
                  }
            : () {
                _invoiceBloc.add(EmptyInvoiceEvent());
              },
        elevation: 4,
        fillColor: isValid ? pacoAppBarColor : Colors.grey,
        child: Icon(
          needSaveInvoice
              ? isValid
                  ? Icons.check
                  : Icons.close
              : Icons.add,
          size: 20.0,
          color: Colors.white,
        ),
        padding: EdgeInsets.zero,
        shape: CircleBorder(),
      ),
    );
  }

  _buildCancelReceptionButton(BuildContext context, {bool isDisabled}) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.only(left: 16),
      child: RawMaterialButton(
        onPressed: isDisabled
            ? null
            : () {
                _dialogCancelReception(context);
              },
        elevation: 4,
        fillColor: !isDisabled ? pacoAppBarColor : Colors.grey,
        child: Icon(
          Icons.delete,
          size: 20.0,
          color: Colors.white54,
        ),
        padding: EdgeInsets.zero,
        shape: CircleBorder(),
      ),
    );
  }

  _buildInvoiceInput() {
    return Expanded(
      child: Column(
        children: [
          TextField(
            //autofocus: true,
            //controller: _invoiceNumberController,
            onChanged: (text) {
              _invoiceBloc.add(InvoiceNumberChangeEvent(text));
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
                      child: BlocBuilder<InvoiceBloc, InvoiceState>(
                          builder: (context, state) {
                        String invoiceDateString = 'Data facturii:';
                        if (state is ValidationInvoiceState) {
                          if (state.invoice?.invoiceDate != null)
                            invoiceDateString = state.invoice.invoiceDateString;
                        }
                        return Text(
                          invoiceDateString,
                          style: textStyle.copyWith(
                            fontSize: 16,
                          ),
                        );
                      }),
                    ),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        var date = await getDate();
                        _invoiceBloc.add(InvoiceDateChangeEvent(date));
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
        ],
      ),
    );
  }

  _dialogManualInputBarcode(BuildContext context) {
    return dialogAlert(
        context,
        'Codul de bare',
        TextField(
          onChanged: (code) {
            // _loginBloc.add(UserNameChangeEvent(newUser));
            _manualBarcode = code;
          },
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          obscureText: false,
          //focusNode: _userFocusNode,

          style: textStyle.copyWith(decoration: TextDecoration.none),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.input),
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(25.0),
            ),
            filled: true,
            fillColor: pacoLightGray,
            hintText: "Introduceți codul",
            hintStyle: textStyle,
          ),
        ), onPressedPositive: () {
      Navigator.pop(context);
      int barcode = int.tryParse(_manualBarcode);
      if (barcode != null) {
        10_orderSummaryBloc.add(FindProductInOrderEvent(barcode));
      }
    });
  }

  _dialogCancelReception(BuildContext context) {
    return dialogAlert(
      context,
      'Anulare recepție',
      Text("Dorești să anulezi această recepție? Atenție: Recepția NU va fi trimisă pe server și toate datele legate de ea se vor șterge!"),
      onPressedPositive: () {
        Navigator.pop(context);
        _orderSummaryBloc.add(DeleteOrderAndNavigateEvent());
      },
      onPressedNegative: () {
        Navigator.pop(context);
      },
    );
  }

  _onScannerListener(BuildContext context, HomeState state) {
    if (state is ScanningErrorState) {
      if (state.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.message),
        ));
      }
    }
    if (state is ScanningSuccessfullyState && _searchIsNotDone) {
      _searchIsNotDone = false;
      _orderSummaryBloc
          .add(FindProductInOrderEvent(int.tryParse(state.barcode) ?? 0));
    }
  }

  _onApiCallListener(BuildContext context, ApiCallState state) async {
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
            print("InvoiceId: $_currentInvoiceId");
            var product = ProductModel(
              code: int.tryParse(barCode) ?? 0,
              name: "Produs inexistent în Contliv",
              quantity: 0,
              belongsToOrder: false,
              invoiceId: _currentInvoiceId ?? 0,
              productType: ProductType.ORDER,
            );
            final navKey = NavKey.navKey;
            navKey.currentState
                .pushNamed(InputQuantityPage.route, arguments: product);
          }, onPressedNegative: () {
            Navigator.of(context).pop();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      }
    }
    if (state is ApiCallLoadedState) {
      if (state.callId == CallId.GET_PRODUCTS_CALL) {
        print("InvoiceId: $_currentInvoiceId");
        var product = (state.response as PaginatedModel).products.first;
        product.belongsToOrder = false;
        product.productType = ProductType.ORDER;
        product.invoiceId = _currentInvoiceId ?? 0;
        final navKey = NavKey.navKey;
        await navKey.currentState
            .pushNamed(InputQuantityPage.route, arguments: product);
        _orderSummaryBloc.add(ProgressRefreshEvent());
      }
      if (state.callId == CallId.POST_RECEPTION) {
        dialogAlert(context, 'Succes',
            Text('Recepția a fost trimisă cu succes pe server.'),
            onPressedPositive: () {
          Navigator.of(context).pop();
          _orderSummaryBloc.add(DeleteOrderAndNavigateEvent());
        });
      }
    }
  }

  _onListener(BuildContext context, OrderSummaryState state) async {
    if (state is ProductBelongOrderState) {
      _searchIsNotDone = true;
      if (!state.product.belongsToOrder) {
        dialogAlert(
            context,
            'Confirmare',
            Text('Produsul scanat nu se regăsește pe comandă. '
                'Vrei să-l caut totuși în ContLiv?'), onPressedPositive: () {
          Navigator.of(context).pop();
          _apiCallBloc.add(GetProductsEvent(
              SearchType.BY_CODE, state.product.code.toString(), 1));
        }, onPressedNegative: () {
          Navigator.of(context).pop();
        });
      } else {
        print("InvoiceId: $_currentInvoiceId");
        state.product.invoiceId = _currentInvoiceId ?? 0;
        final navKey = NavKey.navKey;
        var prod =
            await DBProvider.db.getProductIfAlreadyScanned(state.product);
        if (prod != null) {
          prod.productType = ProductType.RECEPTION;
          navKey.currentState
              .pushNamed(InputQuantityPage.route, arguments: prod)
              .then((value) {
            _orderSummaryBloc.add(ProgressRefreshEvent());
          });
        } else {
          navKey.currentState
              .pushNamed(InputQuantityPage.route, arguments: state.product)
              .then((value) {
            _orderSummaryBloc.add(ProgressRefreshEvent());
          });
        }
      }
    }

    if (state is NavigateToHomeState) {
      final navKey = NavKey.navKey;
      navKey.currentState.popUntil(ModalRoute.withName(HomePage.route));
    }
  }

  _buildInvoiceTile(BuildContext context, InvoiceModel invoice) {
    return GestureDetector(
      onTap: () {
        _invoiceBloc.add(SelectInvoiceEvent(invoice));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          color: (invoice.isCurrent ?? false) ? Colors.yellow : Colors.white,
        ),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Factura: ${invoice.invoiceNumber ?? "- "}/${invoice.invoiceDateString}",
              ),
            ),
            GestureDetector(
                onTap: () {
                  _invoiceBloc.add(RemoveInvoiceEvent(invoice));
                },
                child: Icon(Icons.remove_circle, color: Colors.grey)),
          ],
        ),
      ),
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
