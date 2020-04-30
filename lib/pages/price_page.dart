import 'package:flutter/material.dart';
import 'package:mccounting_text/mccounting_text.dart';
import 'package:pacointro/blocs/main_bloc.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class PricePage extends StatefulWidget {
  static String route = "/PricePage";

  @override
  _PricePageState createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  MainBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<MainBloc>(context);
    super.didChangeDependencies();
  }

  Future<void> showAlert(
      BuildContext context, String title, String content, Function onPressed) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? ''),
          content: Text(content ?? ''),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: onPressed,
            ),
            FlatButton(
              child: Text('Renunță'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'DENUMIRE PRODUS',
                          style: textStyle,
                        ),
                        StreamBuilder<ApiResponse<ProductModel>>(
                            stream: _bloc.currentProductStream,
                            builder: (context, snapshot) {
                              return snapshot.hasData && snapshot.data != null
                                  ? Text('${snapshot.data.data.name}',
                                      textAlign: TextAlign.center,
                                      style: textStyle.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 30,
                                          color: pacoAppBarColor))
                                  : Container();
                            }),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'PREȚ',
                          style: textStyle,
                        ),
                        StreamBuilder<ApiResponse<ProductModel>>(
                            stream: _bloc.currentProductStream,
                            builder: (context, snapshot) {
                              return snapshot.hasData && snapshot.data != null
                                  ? Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: pacoAppBarColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: McCountingText(
                                        begin: 0,
                                        end: snapshot.data.data.price,
                                        precision: 2,
                                        style: textStyle.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 42,
                                            color: pacoLightGray),
                                        duration: Duration(seconds: 1),
                                        curve: Curves.decelerate,
                                      ),
                                    )
                                  : Container();
                            }),
                        StreamBuilder<ApiResponse<ProductModel>>(
                            stream: _bloc.currentProductStream,
                            builder: (context, snapshot) {
                              return snapshot.hasData && snapshot.data != null
                                  ? Text('/${snapshot.data.data.measureUnit}')
                                  : Container();
                            }),
                      ],
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        showAlert(context, 'Confirmare',
                            'Produsul va fi trimis la coș cu eticheta \"PREȚ INCORECT\". Vrei să faci asta?',
                            () {
                          print('TAP');
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        'Adaugă\nla coș',
                        textAlign: TextAlign.center,
                        style: textStyleBold,
                      ),
                      shape: new CircleBorder(
                          side: BorderSide(color: pacoAppBarColor, width: 2)),
                      elevation: 4.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(30.0),
                    ),
                    OutlineButton(
                      onPressed: () {
                        _bloc.navigateToDetails();
                      },
                      child: Text('Alte detalii'),
                      borderSide:
                          BorderSide(color: pacoAppBarColor.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
