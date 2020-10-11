import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/pages/CheckProducts/check_products_page.dart';
import 'package:pacointro/pages/CheckProducts/details_page.dart';
import 'package:pacointro/pages/Reception/input_quantity_page.dart';
import 'package:pacointro/pages/Reception/list_products.dart';
import 'package:pacointro/pages/Reception/order_display_page.dart';
import 'package:pacointro/pages/Reception/order_input_page.dart';
import 'package:pacointro/pages/Reception/order_summary_page.dart';
import 'package:pacointro/pages/home_page.dart';
import 'package:pacointro/pages/locations_page.dart';
import 'package:pacointro/pages/login_page.dart';
import 'package:pacointro/pages/CheckProducts/manual_search_page.dart';
import 'package:pacointro/pages/CheckProducts/price_page.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}
//runApp(
//      MultiProvider(
//        providers: [
//          Provider<LoginBloc>(
//            create: (context) => LoginBloc.withRepository(
//              FakeRepository(),
//            ),
//            dispose: (context, bloc) => bloc.dispose(),
//          ),
//          Provider<MainBloc>(
//            create: (context) => MainBloc.withRepository(
//              FakeRepository(),
//            ),
//            dispose: (context, bloc) => bloc.dispose(),
//          ),
//        ],
//        child: MyApp(),
//      ),
//    );

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
        LoginPage.route: (BuildContext context) => LoginPage(),
        LocationsPage.route: (BuildContext context) => LocationsPage(),
        HomePage.route: (BuildContext context) => HomePage(),
        PricePage.route: (BuildContext context) => PricePage(),
        DetailsPage.route: (BuildContext context) => DetailsPage(),
        ManualSearchingPage.route: (BuildContext context) =>
            ManualSearchingPage(),
        CheckProductsPage.route: (BuildContext context) => CheckProductsPage(),
        OrderInputPage.route: (BuildContext context) => OrderInputPage(),
        OrderDisplayPage.route: (BuildContext context) => OrderDisplayPage(),
        OrderSummaryPage.route: (BuildContext context) => OrderSummaryPage(),
        ListProductsPage.route: (BuildContext context) => ListProductsPage(),
        InputQuantityPage.route: (BuildContext context) => InputQuantityPage(),
      },
    );
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
