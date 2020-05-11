import 'package:pacointro/models/credentials_model.dart';
import 'package:pacointro/models/last_input_product_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/sales_product_model.dart';
import 'package:pacointro/models/stock_product_model.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'package:pacointro/repository/repository_interface.dart';

class Repository extends PreferencesRepository implements DataSource {
  @override
  void dispose() {}

  @override
  Future<ApiResponse<UserModel>> checkUsers(CredentialModel credentials) {
    // TODO: implement checkUsers
    return null;
  }

  @override
  Future<ApiResponse<List<ProductModel>>> getProduct(
      {String code, String debit}) {
    // TODO: implement getProduct
    return null;
  }

  @override
  Future<ApiResponse<StockProductModel>> getStockAndDate(
      {String code, String debit}) {
    // TODO: implement getStockAndDate
    return null;
  }

  @override
  Future<ApiResponse<LastInputProductModel>> getLastInputDate(
      {String code, String debit}) {
    // TODO: implement getLastInputDate
    return null;
  }

  @override
  Future<ApiResponse<SalesProductModel>> getSalesInPeriod(
      {String code, String debit, DateTime startDate, DateTime endDate}) {
    // TODO: implement getSalesInPeriod
    return null;
  }
}
