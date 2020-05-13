import 'package:flutter/material.dart';
import 'package:pacointro/blocs/login_bloc.dart';
import 'package:pacointro/pages/CheckProducts/check_products_page.dart';
import 'package:pacointro/pages/CheckProducts/details_page.dart';
import 'package:pacointro/pages/Reception/order_display_page.dart';
import 'package:pacointro/pages/Reception/order_input_page.dart';
import 'package:pacointro/pages/home_page.dart';
import 'package:pacointro/pages/locations_page.dart';
import 'package:pacointro/pages/login_page.dart';
import 'package:pacointro/pages/CheckProducts/manual_search_page.dart';
import 'package:pacointro/pages/CheckProducts/price_page.dart';
import 'package:pacointro/repository/fake_repository.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:provider/provider.dart';

import 'blocs/main_bloc.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          Provider<LoginBloc>(
            create: (context) => LoginBloc.withRepository(
              FakeRepository(),
            ),
            dispose: (context, bloc) => bloc.dispose(),
          ),
          Provider<MainBloc>(
            create: (context) => MainBloc.withRepository(
              FakeRepository(),
            ),
            dispose: (context, bloc) => bloc.dispose(),
          ),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paco',
      theme: ThemeData(
        primarySwatch: pacoRedMaterialColor,
      ),
      home: LoginPage(),
      navigatorKey: NavKey.navKey,
      routes: <String, WidgetBuilder>{
        LocationsPage.route: (BuildContext context) => LocationsPage(),
        HomePage.route: (BuildContext context) => HomePage(),
        PricePage.route: (BuildContext context) => PricePage(),
        DetailsPage.route: (BuildContext context) => DetailsPage(),
        ManualSearchingPage.route: (BuildContext context) =>
            ManualSearchingPage(),
        CheckProductsPage.route: (BuildContext context) => CheckProductsPage(),
        OrderInputPage.route: (BuildContext context) => OrderInputPage(),
        OrderDisplayPage.route: (BuildContext context) => OrderDisplayPage(),
      },
    );
  }
}
