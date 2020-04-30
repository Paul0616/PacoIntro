import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/pages/manual_search_page.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/menu_button_widget.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class CheckProductsPage extends StatefulWidget {
  static String route = '/CheckProductsPage';

  @override
  _CheckProductsPageState createState() => _CheckProductsPageState();
}

class _CheckProductsPageState extends State<CheckProductsPage> {
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
      body: Center(
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
                        subscriptionError = _bloc.errorOccur.listen((message) {
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
                  return Expanded(
//                    child: MediaQuery.of(context).orientation ==
//                        Orientation.portrait
//                        ?
                      child: buildColumnButtons()
//                        : buildRowButtons(),
                      );
                }),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Padding buildRowButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MenuButtonWidget(
            image: Image(
              color: Colors.white,
              image: AssetImage('images/check.png'),
              fit: BoxFit.cover,
            ),
            text: Text(
              'Verificare Produs',
              style: textStyle.copyWith(color: Colors.black87),
            ),
            onTap: () {},
          ),
          Container(
            child: Center(
              child: RaisedButton.icon(
                onPressed: () {
                  _bloc.isManualSearchForProduct = true;
                  _bloc.resetManualSearchString();
                  _bloc.resetsFoundProducts();
                  final navKey = NavKey.navKey;
                  navKey.currentState.pushNamed(ManualSearchingPage.route);
                },
                icon: Icon(Icons.search),
                label: Text("Cautare manuala produs"),
              ),
            ),
          ),
          SizedBox(
            width: 50,
          ),
          MenuButtonWidget(
            image: Image(
              color: Colors.white,
              image: AssetImage('images/box.png'),
              fit: BoxFit.cover,
            ),
            text: Text(
              'Recepție Marfă',
              style: textStyle.copyWith(color: Colors.black87),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget buildColumnButtons() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 40,
            child: RaisedButton.icon(
              onPressed: () {
                _bloc.scan();
              },
              icon: Icon(Icons.scanner),
              label: Text("Scanare produs",
                  style: textStyle.copyWith(color: Colors.black87)),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 40,
            child: RaisedButton.icon(
              onPressed: () {
                _bloc.isManualSearchForProduct = true;
                _bloc.resetManualSearchString();
                _bloc.resetsFoundProducts();
                final navKey = NavKey.navKey;
                navKey.currentState.pushNamed(ManualSearchingPage.route,
                    arguments: SearchType.BY_CODE);
              },
              icon: Icon(Icons.search),
              label: Text("Cautare manuala produs dupa cod",
                  style: textStyle.copyWith(color: Colors.black87)),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 40,
            child: RaisedButton.icon(
              onPressed: () {
                _bloc.isManualSearchForProduct = true;
                _bloc.resetManualSearchString();
                _bloc.resetsFoundProducts();
                final navKey = NavKey.navKey;
                navKey.currentState.pushNamed(ManualSearchingPage.route,
                    arguments: SearchType.BY_NAME);
              },
              icon: Icon(Icons.search),
              label: Text("Cautare manuala produs dupa nume",
                  style: textStyle.copyWith(color: Colors.black87)),
            ),
          ),
        ],
      ),
    );
  }
}
