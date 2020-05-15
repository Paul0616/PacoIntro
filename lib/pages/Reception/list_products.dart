import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/balance_item.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class ListProductsPage extends StatefulWidget {
  static String route = '/ListProductsPage';

  @override
  _ListProductsPageState createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
  MainBloc _bloc;

  @override
  Widget build(BuildContext context) {
    final bool isReceivedOnly = ModalRoute.of(context).settings.arguments;

    isReceivedOnly
        ? _bloc.getScannedProducts()
        : _bloc.getAndSaveOrderProducts();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TopBar(
            withBackNavigation: true,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    //margin: EdgeInsets.symmetric(horizontal: 16),
                    // padding: EdgeInsets.symmetric(horizontal: 8),
                    child: StreamBuilder<ApiResponse<List<BalanceItemModel>>>(
                        stream: isReceivedOnly
                            ? _bloc.receivedItems
                            : _bloc.balancedItems,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              //======================
                              case Status.LOADING:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                                break;
                              //======================
                              case Status.COMPLETED:
                                if (snapshot.data.data.isEmpty)
                                  return _noProducts();
                                return _buildProductsList(
                                    snapshot.data.data, isReceivedOnly);
                                break;
                              //======================
                              case Status.ERROR:
//                            StreamSubscription<String> subscription;
//                            subscription = _bloc.errorController.listen((message) {
//                              Scaffold.of(context).showSnackBar(SnackBar(
//                                content: Text(message),
//                              ));
//                              _bloc.errorController.sink.add('');
//                              subscription.cancel();
//                            });
                                return Center(
                                  child: Text(
                                    snapshot.data.message,
                                    style: textStyle,
                                  ),
                                );
                                break;
                            }
                          }

                          return Container();
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(
      List<BalanceItemModel> _products, bool isReceivedItems) {
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
                  '${(product.barcode ?? '')}',
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
                      onPressed: () {},
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
    );
  }

  Widget _noProducts() {
    return Center(
      child: Text(
        'Nu am gasit nici un produs in comanda',
        style: textStyle,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<MainBloc>(context);
    super.didChangeDependencies();
  }
}