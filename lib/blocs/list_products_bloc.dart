import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/list_products_event.dart';
import 'package:pacointro/blocs/list_products_state.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/balance_item.dart';
import 'package:pacointro/models/product_model.dart';

class ListProductsBloc extends Bloc<ListProductsEvent, ListProductsState> {
  @override
  ListProductsState get initialState => EmptyListState();

  @override
  Stream<ListProductsState> mapEventToState(ListProductsEvent event) async* {
    if (event is MakeBalanceEvent) {
      yield LoadingBalanceState('loading balance...');
      List<BalanceItemModel> balanceItems = List<BalanceItemModel>();

      List<ProductModel> orderedProducts = await DBProvider.db
          .getProductsByOrderType(productType: ProductType.ORDER);
      List<ProductModel> receivedProducts = await DBProvider.db
          .getProductsByOrderType(productType: ProductType.RECEPTION);
      for (ProductModel receivedProduct in receivedProducts) {
        var orderProduct = orderedProducts.firstWhere(
            (element) => element.id == receivedProduct.id,
            orElse: () => null);
        balanceItems.add(BalanceItemModel(
            barcode: receivedProduct.id,
            name: receivedProduct.name,
            measureUnit: receivedProduct.measureUnit,
            orderedQuantity: (orderProduct != null ? orderProduct.quantity : 0),
            receivedQuantity: receivedProduct.quantity));
      }
      for (ProductModel orderProduct in orderedProducts) {
        var receivedProduct = receivedProducts.firstWhere(
            (element) => element.id == orderProduct.id,
            orElse: () => null);

        if (receivedProduct == null)
          balanceItems.add(BalanceItemModel(
              barcode: orderProduct.id,
              name: orderProduct.name,
              measureUnit: orderProduct.measureUnit,
              orderedQuantity: orderProduct.quantity,
              receivedQuantity: 0));
      }

      yield BalanceLoadedState(balanceItems);
    }
    //===============================
    if (event is GetScannedProductsEvent) {
      yield LoadingBalanceState('loading balance...');
      List<ProductModel> products = await DBProvider.db
          .getProductsByOrderType(productType: ProductType.RECEPTION);
      List<BalanceItemModel> balanceItems = List<BalanceItemModel>();
      for (ProductModel product in products) {
        balanceItems.add(BalanceItemModel(
            barcode: product.id,
            name: product.name,
            measureUnit: product.measureUnit,
            orderedQuantity: 0,
            receivedQuantity: product.quantity));
      }
      yield BalanceLoadedState(balanceItems);
    }
  }
}
