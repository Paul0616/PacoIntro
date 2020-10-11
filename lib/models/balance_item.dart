class BalanceItemModel {
  int barcode;
  String name;
  String measureUnit;
  double orderedQuantity;
  double receivedQuantity;
  int receivedItemId;

  BalanceItemModel(
      {this.barcode,
      this.name,
      this.measureUnit,
      this.orderedQuantity,
      this.receivedQuantity,
      this.receivedItemId});

  BalanceType get type {
    double diff = orderedQuantity - receivedQuantity;
    if (diff == 0.0)
      return BalanceType.BALANCED;
    else if (diff > 0)
      return BalanceType.INSUFFICIENT;
    else
      return BalanceType.PRODUCT_EXTRA;
  }
}

enum BalanceType { BALANCED, INSUFFICIENT, PRODUCT_EXTRA }
