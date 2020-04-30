import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/pages/price_page.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/search_field.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class ManualSearchingPage extends StatefulWidget {
  static String route = "/ManualSearchingPage";

  @override
  _ManualSearchingPageState createState() => _ManualSearchingPageState();
}

class _ManualSearchingPageState extends State<ManualSearchingPage>
    with AutomaticKeepAliveClientMixin<ManualSearchingPage> {
  MainBloc _bloc;
  List<ProductModel> _products = List<ProductModel>();

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<MainBloc>(context);
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final SearchType searchType = ModalRoute.of(context).settings.arguments;
    _products.clear();
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        return true;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TopBar(
              withBackNavigation: true,
              bottomMargin: 16,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      searchType == SearchType.BY_CODE
                          ? 'Codul de bare trebuie să fie exact, fără spații...'
                          : 'Tastati cel putin 3 caractere continute in numele produsului...',
                      style: textStyle.copyWith(fontSize: 12),
                    ),
                    StreamBuilder<bool>(
                        stream: _bloc.enableSearchProduct,
                        builder: (context, snapshot) {
                          return SearchFieldWidget(
                            hint: searchType == SearchType.BY_CODE
                                ? 'Cod de bare'
                                : 'Nume produs',
                            keyboardShouldBeNumeric:
                                searchType == SearchType.BY_CODE,
                            disabled: snapshot.hasData ? !snapshot.data : true,
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _bloc.sendSearchBarcodeForProductString(
                                  searchType);
                            },
                            onChanged: (text) {
                              _bloc.manualSearchByCodeStringValidation(
                                  text, searchType);
                            },
                          );
                        }),
                    StreamBuilder<ApiResponse<List<ProductModel>>>(
                        stream: _bloc.currentProductList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return Container(
                                  padding: EdgeInsets.all(8),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                break;
                              case Status.COMPLETED:
                                break;
                              case Status.ERROR:
                                StreamSubscription<String> subscriptionError;
                                subscriptionError =
                                    _bloc.errorOccur.listen((message) {
                                  if (message.isNotEmpty)
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(message),
                                    ));
                                  _bloc.deleteError();
                                  subscriptionError.cancel();
                                });
                                break;
                            }
                          }
                          return Container();
                        }),
                    SizedBox(
                      height: 4,
                    ),
                    StreamBuilder<ApiResponse<List<ProductModel>>>(
                        stream: _bloc.currentProductList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return Container(
                                  padding: EdgeInsets.all(8),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                break;
                              case Status.COMPLETED:
                                return searchType == SearchType.BY_CODE
                                    ? Container()
                                    : Expanded(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.data.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              onTap: () {
                                                print(snapshot
                                                    .data.data[index].id);
                                                _bloc.setCurrentProduct(
                                                    ApiResponse.completed(
                                                        snapshot
                                                            .data.data[index]));
                                                final navKey = NavKey.navKey;
                                                navKey.currentState
                                                    .popAndPushNamed(
                                                        PricePage.route);
                                              },
                                              title: Text(
                                                '${snapshot.data.data[index].name}',
                                                style: textStyleBold,
                                              ),
                                              subtitle: Text(
                                                '${snapshot.data.data[index].id}',
                                                style: textStyle,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                break;
                              case Status.ERROR:
                                // TODO: Handle this case.
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
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
