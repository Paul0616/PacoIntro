import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:pacointro/models/last_input_product_model.dart';
import 'package:pacointro/models/location_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/models/sales_product_model.dart';
import 'package:pacointro/models/stock_product_model.dart';
import 'package:pacointro/pages/CheckProducts/details_page.dart';
import 'package:pacointro/pages/CheckProducts/price_page.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/repository/fake_repository.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class MainBloc implements BaseBloc {
  final FakeRepository _repository;
  LocationModel _currentLocation;
  String _currentBarcode;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();
  bool isManualSearchForProduct = false;
  String _manualSearchForProductString = '';
  String _orderNumber = '';

  MainBloc.withRepository(this._repository) {
    _currentLocationController.stream
        .listen((location) => print(location.name));
    _barcodeController.stream.listen((response) {
      if (response.status == Status.COMPLETED) {
        print("Barcode: ${response.data}");
        _currentBarcode = response.data.barcode;
        _getProductNameAndPrice(
            _currentBarcode, response.data.searchType == SearchType.BY_NAME);
      }
    });
    _productsListController.stream.listen((response) {
      if (response != null && response.status == Status.COMPLETED) {
        final navKey = NavKey.navKey;
        if (isManualSearchForProduct) {
          isManualSearchForProduct = false;
          if (response.data.length > 1)
            print('multiple products');
          else {
            setCurrentProduct(ApiResponse.completed(response.data.first));
            navKey.currentState.popAndPushNamed(PricePage.route);
          }
        } else {
          setCurrentProduct(ApiResponse.completed(response.data.first));
          navKey.currentState.pushNamed(PricePage.route);
        }
      }
      if (response != null && response.status == Status.ERROR) {
        print('--------------ERROR ${response.message}');
        setCurrentProduct(ApiResponse.error(response.message));
        _errorController.sink.add(response.message);
      }
      if (response != null && response.status == Status.LOADING) {
        print('--------------LOADING ${response.message}');
        setCurrentProduct(ApiResponse.error(response.message));
      }
    });
  }

  /* *******************************************************
    STREAMS
   ********************************************************/
  var _currentLocationController = PublishSubject<LocationModel>();

  var _barcodeController = BehaviorSubject<ApiResponse<BarcodeSearch>>();
  var _productsListController =
      BehaviorSubject<ApiResponse<List<ProductModel>>>();
  var _currentProductController = BehaviorSubject<ApiResponse<ProductModel>>();
  var _stockAndDateController =
      BehaviorSubject<ApiResponse<StockProductModel>>();
  var _lastInputController =
      BehaviorSubject<ApiResponse<LastInputProductModel>>();
  var _salesController = BehaviorSubject<ApiResponse<SalesProductModel>>();
  var _errorController = BehaviorSubject<String>();
  var _searchEnableForProductController = PublishSubject<bool>();
  var _loadOrderValidationController = PublishSubject<bool>();

  var _startDateController = BehaviorSubject<DateTime>();
  var _endDateController = BehaviorSubject<DateTime>();

  /* *******************************************************
    OUTPUT
   ********************************************************/
  Stream<LocationModel> get currentLocationStream =>
      _currentLocationController.stream;

  Stream<ApiResponse<ProductModel>> get currentProductStream =>
      _currentProductController.stream;

//  Stream<ApiResponse<ProductModel>> get currentProductStream =>
//      _productsListController.stream.transform(
//        StreamTransformer<ApiResponse<List<ProductModel>>,
//                ApiResponse<ProductModel>>.fromHandlers(
//            handleData: (response, sink) {
//          switch (response.status) {
//            case Status.LOADING:
//              sink.add(ApiResponse.loading(response.message));
//              break;
//            case Status.COMPLETED:
//              sink.add(ApiResponse.completed(response.data.first));
//              break;
//            case Status.ERROR:
//              sink.add(ApiResponse.error(response.message));
//              break;
//          }
//        }),
//      );

  Stream<ApiResponse<List<ProductModel>>> get currentProductList =>
      _productsListController.stream;

  Stream<String> get errorOccur => _errorController.stream;

  Stream<ApiResponse<StockProductModel>> get currentStockStream =>
      _stockAndDateController.stream;

  Stream<ApiResponse<LastInputProductModel>> get currentLastInputStream =>
      _lastInputController.stream;

  Stream<ApiResponse<SalesProductModel>> get currentSalesStream =>
      _salesController.stream;

  Stream<bool> get enableSearchProduct =>
      _searchEnableForProductController.stream;

  Stream<bool> get loadOrderValidation => _loadOrderValidationController.stream;

  Stream<DateTime> get startDate => _startDateController.stream;

  Stream<DateTime> get endDate => _endDateController.stream;

  /* *******************************************************
    METHODS
   ********************************************************/
  getCurrentLocation() async {
    _currentLocation = await _repository.getLocalLocation();
    if (_currentLocation != null)
      _currentLocationController.sink.add(_currentLocation);
  }

  _getProductNameAndPrice(String barcode, bool searchByName) async {
    _productsListController.sink.add(await _repository.getProduct(
        code: barcode,
        debit: _currentLocation.debit,
        searchByName: searchByName));
  }

  _getStockAndDate(String barcode) async {
    _stockAndDateController.sink.add(ApiResponse.loading("loading"));
    _stockAndDateController.sink.add(await _repository.getStockAndDate(
        code: barcode, debit: _currentLocation.debit));
  }

  _getLastInput(String barcode) async {
    _lastInputController.sink.add(ApiResponse.loading('loading'));
    _lastInputController.sink.add(await _repository.getLastInputDate(
        code: barcode, debit: _currentLocation.debit));
  }

  _getSales(String barcode, DateTime startDate, DateTime endDate) async {
    _salesController.sink.add(ApiResponse.loading('loading'));
    _startDateController.sink.add(startDate);
    _endDateController.sink.add(endDate);
    _salesController.sink.add(await _repository.getSalesInPeriod(
        code: barcode,
        debit: _currentLocation.debit,
        startDate: startDate,
        endDate: endDate));
  }

  sinkStartDate(DateTime startDate) {
    _startDate = startDate;
    _startDateController.sink.add(startDate);
  }

  sinkEndDate(DateTime endDate) {
    _endDate = endDate;
    _endDateController.sink.add(endDate);
  }

  navigateToDetails() {
    final navKey = NavKey.navKey;
    navKey.currentState.pushNamed(DetailsPage.route);
    _getStockAndDate(_currentBarcode);
    _getLastInput(_currentBarcode);
    _getSales(_currentBarcode, _startDate, _endDate);
  }

  refreshSales() {
    _getSales(_currentBarcode, _startDate, _endDate);
  }

  Future scan() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      if (barcode.type == ResultType.Barcode)
        _barcodeController.sink.add(ApiResponse.completed(
            BarcodeSearch(barcode.rawContent, SearchType.BY_CODE)));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        _barcodeController.sink.add(ApiResponse.error(
            'Trebuie sa accepti permisiunile pentru folosirea camerei!'));
      } else {
        _barcodeController.sink.add(ApiResponse.error('Unknown error: $e'));
      }
    }
  }

  manualSearchByCodeStringValidation(String barcode, SearchType searchType) {
    _manualSearchForProductString = barcode;
    _searchEnableForProductController.sink.add(
        _manualSearchForProductString.length >
            (searchType == SearchType.BY_CODE ? 0 : 3));
  }

  orderNumberValidation(String orderNumber){
    _orderNumber = orderNumber;
    _loadOrderValidationController.sink.add(_orderNumber.length > 0 && int.tryParse(_orderNumber) != null);
  }

  sendSearchBarcodeForProductString(SearchType searchType) {
    _barcodeController.sink.add(ApiResponse.completed(
        BarcodeSearch(_manualSearchForProductString, searchType)));
  }

  setCurrentProduct(ApiResponse<ProductModel> response) {
    _currentProductController.sink.add(response);
  }

  resetManualSearchString() {
    _manualSearchForProductString = '';
    _searchEnableForProductController.sink.add(false);
  }

  resetsFoundProducts() {
    _productsListController.sink.add(null);
  }

  deleteError() {
    _errorController.sink.add('');
  }

  @override
  void dispose() {
    _currentLocationController?.close();
    _barcodeController?.close();
    _productsListController?.close();
    _errorController?.close();
    _salesController?.close();
    _lastInputController?.close();
    _stockAndDateController?.close();
    _searchEnableForProductController?.close();
    _currentProductController?.close();
    _startDateController?.close();
    _endDateController?.close();
    _loadOrderValidationController?.close();
  }
}

class BarcodeSearch {
  String barcode;
  SearchType searchType;

  BarcodeSearch(this.barcode, this.searchType);
}
