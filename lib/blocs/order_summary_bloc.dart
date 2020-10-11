import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/order_summary_event.dart';
import 'package:pacointro/blocs/order_summary_state.dart';
import 'package:pacointro/database/database.dart';

import 'package:pacointro/models/invoice_model.dart';
import 'package:pacointro/models/product_model.dart';

class OrderSummaryBloc extends Bloc<OrderSummaryEvent, OrderSummaryState> {
  @override
  OrderSummaryState get initialState => EmptyOrderSummaryState();

  @override
  Stream<OrderSummaryState> mapEventToState(OrderSummaryEvent event) async* {
    if (event is FindProductInOrderEvent) {
      var products = await DBProvider.db.getProductsByBarcode(
          code: event.barCode, productType: ProductType.ORDER);
      yield ProductBelongOrderState(
        products.isNotEmpty
            ? products.first
            : ProductModel(
                id: event.barCode,
                belongsToOrder: false,
                productType: ProductType.RECEPTION,
              ),
      );
    }
    if (event is ProgressRefreshEvent) {}
  }
}
