class TokenResponseModel {
  String apiKey;

  TokenResponseModel({this.apiKey});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['apikey'] = this.apiKey;

    return data;
  }

  TokenResponseModel.fromMap(Map<String, dynamic> json) {
    this.apiKey = json['apikey'];
  }
}
