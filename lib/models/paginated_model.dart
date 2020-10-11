import 'package:pacointro/models/product_model.dart';

class PaginatedModel {
  List<ProductModel> products;
  int totalPages;
  int currentPage;
  bool isLastPage;

  PaginatedModel(
      {this.products, this.totalPages, this.isLastPage, this.currentPage});

  PaginatedModel.fromJson(Map<String, dynamic> mapResponse) {
    totalPages = mapResponse['last_page'];
    isLastPage = mapResponse['next_page_url'] == null;
    currentPage = mapResponse['current_page'];
    var data = mapResponse['data'];
    //print(json.decode(data));
    products =
        data.map((e) => ProductModel.fromMap(e)).toList().cast<ProductModel>();
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['ID'] = this.id;
  //   data['NUME UTILIZATOR'] = this.name;
  //   return data;
  // }

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is PaginatedModel &&
  //         runtimeType == other.runtimeType &&
  //         name == other.name &&
  //         id == other.id;
  //
  // @override
  // int get hashCode => id.hashCode;
}
