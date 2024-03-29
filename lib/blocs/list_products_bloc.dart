import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/list_products_event.dart';
import 'package:pacointro/blocs/list_products_state.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/balance_item.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'package:pacointro/utils/constants.dart';

class ListProductsBloc extends Bloc<ListProductsEvent, ListProductsState> {
  @override
  ListProductsState get initialState => EmptyListState();

  @override
  Stream<ListProductsState> mapEventToState(ListProductsEvent event) async* {
    if (event is MakeBalanceEvent) {
      yield LoadingBalanceState('loading balance...');
      List<BalanceItemModel> balanceItems = await makeBalance(alphabeticalOrder: true);

      yield BalanceLoadedState(balanceItems);
    }
    //===============================
    if (event is GetScannedProductsEvent) {
      yield LoadingBalanceState('loading balance...');
      var order = await PreferencesRepository().getLocalOrder();
      List<ProductModel> products = await DBProvider.db
          .getProductsByOrderType(productType: ProductType.RECEPTION, invoiceIdFilter: event.invoiceIdFilter);
      List<BalanceItemModel> balanceItems = [];

      for (ProductModel product in products) {
        balanceItems.add(
          BalanceItemModel(
            barcode: product.code,
            name: product.name,
            measureUnit: product.measureUnit,
            orderedQuantity: 0,
            receivedQuantity: product.quantity,
            receivedItemId: product.id,
            invoiceId: product.invoiceId,
            invoiceInfo: getInvoiceInfo(fromOrder: order, invoiceId: product.invoiceId),
          ),
        );
      }
      yield BalanceLoadedState(balanceItems);
    }
    //===============================
    if (event is RefreshEvent) {
      yield EmptyListState();
    }
    //===============================
    if (event is DeleteItemEvent) {
      await DBProvider.db.deleteProductById(id: event.id);
      yield EmptyListState();
    }
  }


}
