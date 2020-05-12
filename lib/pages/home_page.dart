import 'package:flutter/material.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/location_model.dart';

import 'package:pacointro/pages/CheckProducts/check_products_page.dart';

import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/menu_button_widget.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

import 'Reception/order_page.dart';

class HomePage extends StatefulWidget {
  static String route = '/HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            Expanded(
              child: MediaQuery.of(context).orientation == Orientation.portrait
                  ? buildColumnButtons()
                  : buildRowButtons(),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildRowButtons() {
    return SingleChildScrollView(
      child: Padding(
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
              onTap: () {
                final navKey = NavKey.navKey;
                navKey.currentState.pushNamed(CheckProductsPage.route);
              },
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
              onTap: () {
                print("Reception");
                final navKey = NavKey.navKey;
                navKey.currentState.pushNamed(OrderPage.route);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColumnButtons() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
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
            onTap: () {
              //_bloc.scan();
              final navKey = NavKey.navKey;
              navKey.currentState.pushNamed(CheckProductsPage.route);
            },
          ),
          SizedBox(
            height: 50,
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
            onTap: () {
              print("Reception");
              final navKey = NavKey.navKey;
              navKey.currentState.pushNamed(OrderPage.route);
            },
          ),
        ],
      ),
    );
  }
}
