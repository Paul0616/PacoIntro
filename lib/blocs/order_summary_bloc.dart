import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/order_summary_event.dart';
import 'package:pacointro/blocs/order_summary_state.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/progress_model.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'package:pacointro/utils/constants.dart';

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
                code: event.barCode,
                belongsToOrder: false,
                productType: ProductType.RECEPTION,
              ),
      );
    }
    if (event is ProgressRefreshEvent) {
      var scanned = await DBProvider.db.getCountProductsByOrderType(productType: ProductType.RECEPTION);
      var ordered = await DBProvider.db.getCountProductsByOrderType(productType: ProductType.ORDER);
      yield UpdateProgressState(ProgressModel(scanned, ordered));
    }

    if(event is FinishReceptionEvent) {
      await PreferencesRepository().removeLocalObject(key: orderKey);
      yield NavigateToHomeState();
    }
  }
}
