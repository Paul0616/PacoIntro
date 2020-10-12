import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/api_call_event.dart';
import 'package:pacointro/blocs/api_call_state.dart';
import 'package:pacointro/blocs/home_bloc.dart';
import 'package:pacointro/blocs/home_event.dart';
import 'package:pacointro/blocs/home_state.dart';
import 'package:pacointro/models/paginated_model.dart';

import 'package:pacointro/pages/CheckProducts/manual_search_page.dart';
import 'package:pacointro/pages/CheckProducts/price_page.dart';

import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/top_bar.dart';

class CheckProductsPage extends StatefulWidget {
  static String route = '/CheckProductsPage';

  @override
  _CheckProductsPageState createState() => _CheckProductsPageState();
}

class _CheckProductsPageState extends State<CheckProductsPage> {
  //final Repository _repository = Repository(httpClient: http.Client());

  @override
  void didChangeDependencies() {
    // _bloc = Provider.of<MainBloc>(context);
    // _bloc.getCurrentLocation();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => HomeBloc(),
            ),
            BlocProvider(
              create: (_) => ApiCallBloc(),
            )
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TopBar(
                withBackNavigation: true,
              ),
              BlocListener<HomeBloc, HomeState>(
                listener: _onErrorScanListener,
                child:
                    BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                  var currentLocationName = '';
                  if (state is EmptyState) {
                    BlocProvider.of<HomeBloc>(context)
                        .add(InitCurrentLocationEvent());
                  }
                  if (state is LocationInitiatedState) {
                    currentLocationName = state.location.name;
                  }
                  return Text('Magazin: $currentLocationName',
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: pacoAppBarColor));
                }),
              ),
              BlocListener<ApiCallBloc, ApiCallState>(
                listener: _onApiListener,
                child: BlocBuilder<ApiCallBloc, ApiCallState>(
                    builder: (context, state) {
                  if (state is ApiCallLoadingState) {
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
                    child: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? buildColumnButtons(context)
                        : buildRowButtons(context),
                  );
                }),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Padding buildRowButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Container(
            height: 60,
            child: RaisedButton.icon(
              onPressed: () {
                BlocProvider.of<HomeBloc>(context).add(ScanBarcodeEvent());
              },
              shape: StadiumBorder(),
              color: pacoAppBarColor,
              icon: Icon(
                Icons.scanner,
                color: pacoLightGray,
              ),
              label: Text("Scanare produs",
                  style: textStyleBold.copyWith(color: pacoLightGray)),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 60,
                child: RaisedButton.icon(
                  onPressed: () {
                    final navKey = NavKey.navKey;
                    navKey.currentState.pushNamed(ManualSearchingPage.route,
                        arguments: SearchType.BY_CODE);
                  },
                  shape: StadiumBorder(),
                  color: Colors.orangeAccent,
                  icon: Icon(
                    Icons.search,
                    color: pacoLightGray,
                  ),
                  label: Text("Cautare manuala produs dupa cod",
                      style: textStyleBold.copyWith(color: pacoLightGray)),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Container(
                height: 60,
                child: RaisedButton.icon(
                  onPressed: () {
                    final navKey = NavKey.navKey;
                    navKey.currentState.pushNamed(ManualSearchingPage.route,
                        arguments: SearchType.BY_NAME);
                  },
                  shape: StadiumBorder(),
                  color: Colors.orangeAccent,
                  icon: Icon(
                    Icons.search,
                    color: pacoLightGray,
                  ),
                  label: Text("Cautare manuala produs dupa nume",
                      style: textStyleBold.copyWith(color: pacoLightGray)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildColumnButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Container(
          //   height: 40,
          //   child: RaisedButton.icon(
          //     onPressed: () {
          //       BlocProvider.of<HomeBloc>(context).add(ScanBarcodeEvent());
          //     },
          //     shape: StadiumBorder(),
          //     color: pacoAppBarColor,
          //     icon: Icon(
          //       Icons.scanner,
          //       color: pacoLightGray,
          //     ),
          //     label: Text("Scanare produs",
          //         style: textStyleBold.copyWith(color: pacoLightGray)),
          //   ),
          // ),
          // SizedBox(
          //   height: 50,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RaisedButton(
                padding: EdgeInsets.all(8),
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
                      style: textStyleBold.copyWith(color: pacoLightGray),
                    ),
                  ],
                ),
                color: pacoAppBarColor,
                elevation: 4,
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(ScanBarcodeEvent());
                },
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
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
                      "Manual barcod",
                      style: textStyleBold.copyWith(color: pacoLightGray),
                    ),
                  ],
                ),
                color: pacoAppBarColor,
                elevation: 4,
                onPressed: () {
                  final navKey = NavKey.navKey;
                  navKey.currentState.pushNamed(ManualSearchingPage.route,
                      arguments: SearchType.BY_CODE);
                },
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 40,
            child: RaisedButton.icon(
              onPressed: () {
                final navKey = NavKey.navKey;
                navKey.currentState.pushNamed(ManualSearchingPage.route,
                    arguments: SearchType.BY_NAME);
              },
              shape: StadiumBorder(),
              color: Colors.orangeAccent,
              icon: Icon(
                Icons.search,
                color: pacoLightGray,
              ),
              label: Text("Cautare produs dupa nume",
                  style: textStyleBold.copyWith(color: pacoLightGray)),
            ),
          ),
        ],
      ),
    );
  }

  _onErrorScanListener(BuildContext context, HomeState state) {
    if (state is ScanningErrorState) {
      if (state.message.isNotEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(state.message),
        ));
      }
    }
    if (state is ScanningSuccessfullyState) {
      BlocProvider.of<ApiCallBloc>(context)
          .add(GetProductsEvent(SearchType.BY_CODE, state.barcode, 1));
    }
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
      final navKey = NavKey.navKey;
      navKey.currentState.pushNamed(PricePage.route,
          arguments: (state.response as PaginatedModel).products.first);
    }
  }
}
