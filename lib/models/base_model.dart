class BaseModel {
  int code;
  String name;

  BaseModel({this.code, this.name});

  BaseModel.fromJson(Map<String, dynamic> json) {
    code = json['ID'];
    name = json['NUME UTILIZATOR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.code;
    data['NUME UTILIZATOR'] = this.name;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
