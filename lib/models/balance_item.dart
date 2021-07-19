class BalanceItemModel {
  int barcode;
  String name;
  String measureUnit;
  double orderedQuantity;
  double receivedQuantity;
  int receivedItemId;
  int invoiceId;
  String invoiceInfo;

  BalanceItemModel(
      {this.barcode,
      this.name,
      this.measureUnit,
      this.orderedQuantity,
      this.receivedQuantity,
      this.receivedItemId,
      this.invoiceId,
      this.invoiceInfo});

  BalanceType get type {
    double diff = orderedQuantity - receivedQuantity;
    if (diff == 0.0)
      return BalanceType.BALANCED;
    else if (diff > 0)
      return BalanceType.INSUFFICIENT;
    else
      return BalanceType.PRODUCT_EXTRA;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.barcode;
    data['name'] = this.name;
    data['UM'] = this.measureUnit;
    data['orderedQuantity'] = this.orderedQuantity;
    //data['receivedQuantity'] = this.receivedQuantity;
    return data;
  }


}

enum BalanceType { BALANCED, INSUFFICIENT, PRODUCT_EXTRA }
