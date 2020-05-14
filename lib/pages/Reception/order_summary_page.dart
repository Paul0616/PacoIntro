import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/progress_model.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class OrderSummaryPage extends StatefulWidget {
  static String route = '/OrderSummaryPage';

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  MainBloc _bloc;
  int currentScan = 0;

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<MainBloc>(context);
    _bloc.getCurrentLocation();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildBody(),
                ),
              ),
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: OutlineButton(
                  onPressed: () {},
                  child: Text(
                    'Vezi produsele de pe comandă',
                    style: textStyleBold,
                    textAlign: TextAlign.center,
                  ),
                  borderSide: BorderSide(color: pacoAppBarColor),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: OutlineButton(
                  onPressed: () {},
                  child: Text(
                    'Vezi produsele deja scanate',
                    style: textStyleBold,
                    textAlign: TextAlign.center,
                  ),
                  borderSide: BorderSide(color: pacoAppBarColor),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        StreamBuilder<ProgressModel>(
            stream: _bloc.scanningProgress,
            builder: (context, snapshot) {
              return CircularPercentIndicator(
                radius: 130.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 15.0,
                percent: snapshot.hasData
                    ? snapshot.data.ratio > 1 ? 1.0 : snapshot.data.ratio
                    : 0.0,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      snapshot.hasData
                          ? "${snapshot.data.current}/${snapshot.data.max}"
                          : "",
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
                progressColor: snapshot.data.ratio > 1 ? Colors.green : Colors.red,
              );
            }),
        SizedBox(
          height: 50,
        ),
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
                "Scaneaza cod produs",
                style: textStyleBold.copyWith(color: pacoLightGray),
              ),
            ],
          ),
          color: pacoAppBarColor,
          elevation: 4,
          onPressed: () {
            currentScan++;
            _bloc.updateScanningProgress(currentScan);
          },
        )
      ],
    );
  }
}
