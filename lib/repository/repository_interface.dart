import 'package:pacointro/models/credentials_model.dart';
import 'package:pacointro/models/last_input_product_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/sales_product_model.dart';
import 'package:pacointro/models/stock_product_model.dart';
import 'package:pacointro/models/user_model.dart';

import 'api_response.dart';

abstract class DataSource {
  void dispose();
  Future<ApiResponse<UserModel>> checkUsers(CredentialModel credentials);
  Future<ApiResponse<List<ProductModel>>> getProduct(
      {String code, String debit});
  Future<ApiResponse<StockProductModel>> getStockAndDate(
      {String code, String debit});
  Future<ApiResponse<LastInputProductModel>> getLastInputDate(
      {String code, String debit});
  Future<ApiResponse<SalesProductModel>> getSalesInPeriod(
      {String code, String debit, String startDate, String endDate});
}