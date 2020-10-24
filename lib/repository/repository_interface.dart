import 'package:pacointro/models/credentials_model.dart';

import 'package:pacointro/utils/constants.dart';


abstract class DataSource {
  void dispose();
  Future<Map<String, dynamic>> getToken(CredentialModel credentials);
  Future<Map<String, dynamic>> checkUser();
  Future<Map<String, dynamic>> getProduct(
      {String code, String debit, SearchType searchType, int page});
  Future<Map<String, dynamic>> putIssue(
      {int code, String debit, int status, int userId});
  Future<Map<String, dynamic>> getProductDetails({int code, String debit});
  Future<Map<String, dynamic>> getSalesInPeriod(
      {int code, String debit, String startDate, String endDate});
  Future<Map<String, dynamic>> getLastInputDate({int code, String debit});
  Future<Map<String, dynamic>> getOrderByNumber(
      {String orderNumber, String repository});

  Future<int> getOrderCount(
      {String orderNumber, String repository});
  Future<Map<String, dynamic>> getOrderItems(
      {String orderNumber, String repository});
  Future<Map<String, dynamic>> postReception(Map<String, dynamic> body);
}
