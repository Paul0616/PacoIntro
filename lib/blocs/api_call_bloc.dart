
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pacointro/database/database.dart';
import 'package:pacointro/models/balance_item.dart';
import 'package:pacointro/models/last_input_product_model.dart';
import 'package:pacointro/models/order_model.dart';
import 'package:pacointro/models/paginated_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/sales_product_model.dart';
import 'package:pacointro/models/stock_product_model.dart';
import 'package:pacointro/models/token_response_model.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/repository/preferences_repository.dart';
import 'package:pacointro/repository/repository.dart';
import 'package:pacointro/utils/constants.dart';

import 'api_call_event.dart';
import 'api_call_state.dart';

class ApiCallBloc extends Bloc<ApiCallEvent, ApiCallState> {
  //final HttpClient _httpClient = Repository.customHttpClient(cert: Repository.ISRG_X1);
  final Repository repository = Repository(httpClient: http.Client());

  //final FakeRepository repository = FakeRepository();

  @override
  ApiCallState get initialState => ApiCallEmptyState();

  @override
  Stream<ApiCallState> mapEventToState(ApiCallEvent event) async* {
    if (event is LoadingEvent) {
      yield ApiCallLoadingState(event.loadingMessage);
    }

    if (event is GetTokenEvent) {
      yield ApiCallLoadingState('get token...');
      try {
        final Map<String, dynamic> baseApiResponse =
            await repository.getToken(event.credentials);

        String token = baseApiResponse['apikey'];
        if (token != null) {
          var prefs = PreferencesRepository();
          await prefs.saveLocalToken(token: TokenResponseModel(apiKey: token));
          await prefs.savePassword(event.credentials.password);
          yield ApiCallLoadedState(response: token, callId: CallId.TOKEN_CALL);
        } else {
          if (baseApiResponse['status'] != null &&
              baseApiResponse['status'] == 401)
            yield ApiCallErrorState(message: 'User sau parola gresite');
          else
            yield ApiCallErrorState(message: baseApiResponse.toString());
        }
      } catch (e) {
        yield ApiCallErrorState(message: '${e.toString()}');
      }
    }

    if (event is CheckUserEvent) {
      yield ApiCallLoadingState('checking user...');
      try {
        final Map<String, dynamic> response = await repository.checkUser();
        //if()
        var prefs = PreferencesRepository();
        UserModel user = UserModel.fromMap(response);
        await prefs.saveLocalUser(user: user);
        yield ApiCallLoadedState(
            response: user, callId: CallId.CHECK_USER_CALL);
      } catch (e) {
        yield ApiCallErrorState(message: '${e.toString()}');
      }
    }

    if (event is GetProductsEvent) {
      if (event.page == 1) yield ApiCallLoadingState('caut produse...');
      try {
        var prefs = PreferencesRepository();
        var currentLocation = await prefs.getLocalLocation();
        final Map<String, dynamic> response = await repository.getProduct(
            code: event.code,
            debit: currentLocation.debit,
            searchType: event.searchType,
            page: event.page);
        PaginatedModel paginatedModel = PaginatedModel.fromJson(response);
        if (paginatedModel.products.isEmpty) {
          yield ApiCallErrorState(
              message: 'Nu am găsit nume/cod \'${event.code}\'');
          return;
        }
        yield ApiCallLoadedState(
            response: paginatedModel, callId: CallId.GET_PRODUCTS_CALL);
      } catch (e) {
        yield ApiCallErrorState(message: '${e.toString()}');
      }
    }
    if (event is GetProductDetailsEvent) {
      yield ApiCallLoadingState('loading stock...');
      try {
        var prefs = PreferencesRepository();
        var currentLocation = await prefs.getLocalLocation();
        final Map<String, dynamic> response = await repository
            .getProductDetails(code: event.code, debit: currentLocation.debit);

        StockProductModel stockProductModel =
            StockProductModel.fromMap(response);

        yield ApiCallLoadedState(
            response: stockProductModel, callId: CallId.GET_DETAILS_CALL);
      } catch (e) {
        yield ApiCallErrorState(message: '${e.toString()}');
      }
    }

    if (event is LastInputEvent) {
      yield ApiCallLoadingState('loading last input...');
      try {
        var prefs = PreferencesRepository();
        var currentLocation = await prefs.getLocalLocation();
        final Map<String, dynamic> response = await repository.getLastInputDate(
            code: event.code, debit: currentLocation.debit);

        LastInputProductModel lastInputProductModel =
            LastInputProductModel.fromMap(response);

        yield ApiCallLoadedState(
            response: lastInputProductModel,
            callId: CallId.GET_LAST_INPUT_CALL);
      } catch (e) {
        yield ApiCallErrorState(message: '${e.toString()}');
      }
    }

    if (event is GetSalesInPeriodEvent) {
      yield ApiCallLoadingState('loading sales in period...');
      try {
        var prefs = PreferencesRepository();
        var currentLocation = await prefs.getLocalLocation();
        final Map<String, dynamic> response = await repository.getSalesInPeriod(
          code: event.code,
          debit: currentLocation.debit,
          startDate: DateFormat('yyyy-MM-dd').format(event.startDate),
          endDate: DateFormat('yyyy-MM-dd').format(event.endDate),
        );

        SalesProductModel salesProductModel =
            SalesProductModel.fromMap(response);

        yield ApiCallLoadedState(
            response: salesProductModel,
            callId: CallId.GET_SALE_IN_PERIOD_CALL);
      } catch (e) {
        yield ApiCallErrorState(message: '${e.toString()}');
      }
    }

    if (event is PutProductWithIssueEvent) {
      yield ApiCallLoadingState('se trimite...');
      try {
        var prefs = PreferencesRepository();
        var currentLocation = await prefs.getLocalLocation();
        var localUser = await prefs.getLocalUser();
        final Map<String, dynamic> response = await repository.putIssue(
            code: event.code,
            debit: currentLocation.debit,
            status: event.status,
            userId: localUser.code);
        yield ApiCallLoadedState(
            response: response, callId: CallId.PRODUCT_WITH_ISSUE_CALL);
      } catch (e) {
        yield ApiCallErrorState(message: '${e.toString()}');
      }
    }

    if (event is PostReceptionEvent) {
      yield ApiCallLoadingState('se trimite...');
      try {
        var prefs = PreferencesRepository();
        var localOrder = await prefs.getLocalOrder();
        var balancedProducts = await makeBalance();
        Map<String, dynamic> data = localOrder.toAPIJson();
        List<BalanceItemModel> _finalProducts = [];
        for (var product in balancedProducts) {
          if (!_finalProducts
              .any((element) => element.barcode == product.barcode)) {
            _finalProducts.add(product);
          }
          // else {
          //   var _p = _finalProducts.firstWhere(
          //       (element) => element.barcode == product.barcode,
          //       orElse: () => null);
          //   _p.receivedQuantity += product.receivedQuantity;
          // }
        }
        data["items"] = _finalProducts.map((product) {
          var _productMap = product.toJson();
          var productWithSameCode = balancedProducts
              .where((element) => element.barcode == product.barcode)
              .toList();
          _productMap['receivedQuantity'] = productWithSameCode
              .map((e) =>
                  {"invoiceId": e.invoiceId, "quantity": e.receivedQuantity})
              .toList();
          return _productMap;
        }).toList();
        data["location"] = (await prefs.getLocalLocation()).name;
       // prettyPrintJson(data);
        final Map<String, dynamic> response =
            await repository.postReception(data);
        yield ApiCallLoadedState(
            response: response, callId: CallId.POST_RECEPTION);
      } catch (e) {
        yield ApiCallErrorState(message: '${e.toString()}');
      }
    }

    if (event is OrderByNumberEvent) {
      yield ApiCallLoadingState('looking for order...');
      try {
        var prefs = PreferencesRepository();
        var currentLocation = await prefs.getLocalLocation();
        final Map<String, dynamic> response = await repository.getOrderItems(
          orderNumber: event.orderNumber,
          repository: currentLocation.name,
        );
        List<ProductModel> orderedProducts = [];
        print(response['data']);
        orderedProducts = (response['data'])
            .map((e) => ProductModel.fromMap(e))
            .toList()
            .cast<ProductModel>();
        await DBProvider.db.deleteAllFromTable();
        await DBProvider.db
            .insertBulkProduct(orderedProducts, ProductType.ORDER);
        // orderedProducts = await DBProvider.db
        //     .getProductsByOrderType(productType: ProductType.ORDER);
        final Map<String, dynamic> response1 =
            await repository.getOrderByNumber(
          orderNumber: event.orderNumber,
          repository: currentLocation.name,
        );
        // var productNumber = await DBProvider.db.getCountProductsByOrderType(productType: ProductType.ORDER);
        // if(productNumber == 0)
        OrderModel orderModel = OrderModel.fromMap(response1);

        yield ApiCallLoadedState(
            response: orderModel, callId: CallId.GET_ORDER_BY_NUMBER);
      } catch (e) {
        yield ApiCallErrorState(message: '${e.toString()}');
      }
    }

    if (event is ApiCallErrorEvent) {
      yield ApiCallErrorState(message: event.message);
    }

    if (event is EmptyEvent) {
      yield ApiCallEmptyState();
    }
  }
}

class ApiCallBloc1 extends ApiCallBloc {}

class ApiCallBloc2 extends ApiCallBloc {}

class ApiCallBloc3 extends ApiCallBloc {}
