import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pacointro/blocs/invoice_bloc.dart';
import 'package:pacointro/blocs/invoice_event.dart';
import 'package:pacointro/blocs/invoice_state.dart';
import 'package:pacointro/blocs/list_products_bloc.dart';
import 'package:pacointro/blocs/list_products_event.dart';
import 'package:pacointro/blocs/list_products_state.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/balance_item.dart';
import 'package:pacointro/models/invoice_model.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/pages/Reception/input_quantity_page.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/top_bar.dart';

class ListProductsPage extends StatefulWidget {
  static String route = '/ListProductsPage';

  @override
  _ListProductsPageState createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
  InvoiceBloc _invoiceBloc = InvoiceBloc();

  //int _currentInvoiceId;
  @override
  Widget build(BuildContext context) {
    final bool isReceivedOnly = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ListProductsBloc(),
          ),
          BlocProvider(
            create: (_) => _invoiceBloc,
          ),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TopBar(
              withBackNavigation: true,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  isReceivedOnly
                      ? SizedBox(
                          height: 16,
                        )
                      : Container(),
                  isReceivedOnly
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                    "Selectează factura pentru care vrei să vezi produsele recepționate",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                      )
                      : Container(),
                  isReceivedOnly
                      ? BlocBuilder<InvoiceBloc, InvoiceState>(
                          builder: (context, state) {
                          if (state is GetOrderState) {
                            var order = state.order;
                            if (order == null) {
                              _invoiceBloc.add(EmptyInvoiceEvent());
                            }
                            return order != null
                                ? SizedBox(
                                    height: 80,
                                    child: _buildInvoicesList(context, order),
                                  )
                                : SizedBox(
                                    height: 80,
                                  );
                          }
                          return Container();
                        })
                      : Container(),
                  Expanded(
                    child: Container(
                      //margin: EdgeInsets.symmetric(horizontal: 16),
                      // padding: EdgeInsets.symmetric(horizontal: 8),

                      child: BlocListener<InvoiceBloc, InvoiceState>(
                        listener: (context, state) {
                          if (state is GetOrderState) {
                            BlocProvider.of<ListProductsBloc>(context).add(
                                GetScannedProductsEvent(
                                    state.order.currentInvoiceId));
                          }
                        },
                        child: BlocBuilder<ListProductsBloc, ListProductsState>(
                            builder: (context, state) {
                          if (state is EmptyListState) {
                            if (!isReceivedOnly)
                              // BlocProvider.of<ListProductsBloc>(context)
                              //     .add(GetScannedProductsEvent(_currentInvoiceId));
                              // else
                              BlocProvider.of<ListProductsBloc>(context)
                                  .add(MakeBalanceEvent());
                          }
                          if (state is LoadingBalanceState) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is BalanceLoadedState) {
                            if (state.items.isEmpty)
                              return _noProducts(isReceivedOnly);
                            return _buildProductsList(
                                state.items, isReceivedOnly);
                          }
                          return Container();
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildInvoicesList(BuildContext context, OrderModel order) {
    return Container(
      child: order.invoices.isEmpty
          ? Container()
          : MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            ),
    );
  }

  _buildInvoiceTile(BuildContext context, InvoiceModel invoice) {
    return GestureDetector(
      onTap: () {
        _invoiceBloc.add(SelectInvoiceEvent(invoice));
        //print("${invoice.id}");
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
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(
      List<BalanceItemModel> _products, bool isReceivedItems) {
    if (!isReceivedItems) {
      List<BalanceItemModel> _finalProducts = [];
      for (var product in _products) {
        if (!_finalProducts
            .any((element) => element.barcode == product.barcode)) {
          _finalProducts.add(product);
        } else {
          var _p = _finalProducts.firstWhere(
              (element) => element.barcode == product.barcode,
              orElse: () => null);
          _p.receivedQuantity += product.receivedQuantity;
        }
      }
      _products = _finalProducts;
    }
    return ListView.separated(
      itemCount: _products.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemBuilder: (context, index) =>
          _buildListTile(context, _products[index], isReceivedItems),
    );
  }

  Widget _buildListTile(
      BuildContext context, BalanceItemModel product, bool isReceivedItems) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: isReceivedItems
          ? Colors.transparent
          : product.type == BalanceType.BALANCED
              ? Colors.green.withAlpha(20)
              : product.type == BalanceType.INSUFFICIENT
                  ? pacoAppBarColor.withAlpha(20)
                  : Colors.blue.withAlpha(20),
      child: MaterialButton(
        onPressed: () async {
          if (isReceivedItems) {
            final navKey = NavKey.navKey;
            await navKey.currentState
                .pushNamed(InputQuantityPage.route,
                    arguments: ProductModel(
                      id: product.receivedItemId,
                      code: product.barcode,
                      name: product.name,
                      measureUnit: product.measureUnit,
                      productType: ProductType.RECEPTION,
                      quantity: product.receivedQuantity,
                      invoiceId: product.invoiceId,
                      belongsToOrder: product.orderedQuantity != 0,
                    ));
            _invoiceBloc.add(EmptyInvoiceEvent());
            //BlocProvider.of<ListProductsBloc>(context).add(RefreshEvent());
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${product.name} (${product.measureUnit})',
                    style: textStyleBold,
                  ),
                  Text(
                    '${(product.barcode ?? '')} ${product.invoiceInfo != null && isReceivedItems ? '(f.' + product.invoiceInfo + ')' : ''}',
                    style: textStyle,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                !isReceivedItems
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.cartArrowDown,
                              color: Colors.black45),
                          Container(
                            width: 60,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${NumberFormat('##0.00').format(product.orderedQuantity)}',
                              style: textStyleBold.copyWith(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.truck, color: Colors.black45),
                    Container(
                      width: 60,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${NumberFormat('##0.00').format(product.receivedQuantity)}',
                        style: textStyleBold.copyWith(
                            color: product.type == BalanceType.BALANCED
                                ? Colors.green
                                : product.type == BalanceType.INSUFFICIENT
                                    ? pacoAppBarColor
                                    : Colors.black,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
                isReceivedItems
                    ? MaterialButton(
                        onPressed: () {
                          //_bloc.deleteProduct(product);
                          print('delete');

                          BlocProvider.of<ListProductsBloc>(context)
                              .add(DeleteItemEvent(product.receivedItemId));
                        },
                        padding: EdgeInsets.all(8),
                        minWidth: 0,
                        child: Icon(
                          Icons.delete,
                          color: Colors.black45,
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _noProducts(bool isReceivedOnly) {
    return Center(
      child: Text(
        isReceivedOnly
            ? 'Nu a fost scanat nici un produs din factura curenta'
            : 'Nu am găsit nici un produs în comandă',
        style: textStyle,
      ),
    );
  }
}
