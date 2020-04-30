class CredentialModel {
  String userName;
  String password;

  CredentialModel({this.userName, this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['userName'] = this.userName;
    data['password'] = this.password;
    return data;
  }

}