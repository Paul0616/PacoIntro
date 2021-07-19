import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/home_bloc.dart';
import 'package:pacointro/blocs/home_event.dart';
import 'package:pacointro/blocs/home_state.dart';
import 'package:pacointro/blocs/order_input_bloc.dart';
import 'package:pacointro/blocs/order_input_event.dart';
import 'package:pacointro/blocs/order_input_state.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/pages/Reception/order_summary_page.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:pacointro/widgets/top_bar.dart';

class OrderDisplayPage extends StatefulWidget {
  static String route = '/OrderDisplayPage';

  @override
  _OrderDisplayPageState createState() => _OrderDisplayPageState();
}

class _OrderDisplayPageState extends State<OrderDisplayPage> {
  final OrderInputBloc _bloc = OrderInputBloc();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final OrderModel orderModel = ModalRoute.of(context).settings.arguments;
    print('Order ID: ${orderModel.id}');
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => HomeBloc(),
          ),
          BlocProvider(
            create: (_) => _bloc,
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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildOrderWidget(context, orderModel),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildOrderWidget(BuildContext context, OrderModel order) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Comanda numărul din data:',
            style: textStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: 16,
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: pacoRedDisabledColor),
            borderRadius: BorderRadius.all(
                Radius.circular(25.0) //         <--- border radius here
                ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  order != null
                      ? '${order.orderNumber}/${order.orderDateString}'
                      : '',
                  style: textStyleBold.copyWith(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: pacoAppBarColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      order != null ? order.productsCount.toString() : '0',
                      style: textStyleBold.copyWith(
                          fontSize: 16, color: pacoLightGray),
                    ),
                    Text(
                      'produse',
                      style: textStyle.copyWith(
                          fontSize: 10, color: pacoLightGray),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Furnizor:',
            style: textStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: pacoRedDisabledColor),
            borderRadius: BorderRadius.all(
                Radius.circular(25.0) //         <--- border radius here
                ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                order != null ? order.supplierName : '',
                style: textStyleBold.copyWith(
                  fontSize: 16,
                ),
              ),
              Text(
                order != null ? 'Cod fiscal: ${order.supplierFiscalCode}' : '',
                style: textStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: BlocListener<OrderInputBloc, OrderInputState>(
            listener: (context, state) async {
              if (state is NavigateToSummaryState) {
                final navKey = NavKey.navKey;
                await navKey.currentState.pushNamed(OrderSummaryPage.route);
                _bloc.add(EmptyEvent());
              }
            },
            child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => states.contains(MaterialState.disabled)
                        ? pacoRedDisabledColor
                        : Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => states.contains(MaterialState.disabled)
                        ? pacoAppBarColor.withOpacity(0.5)
                        : pacoAppBarColor),
              ),
              onPressed: () {
                _bloc.add(SaveToPrefsCurrentOrderEvent(order));
              },
              child: Text('Începe recepție'),
            ),
          ),
        ),
      ],
    );
  }
}
