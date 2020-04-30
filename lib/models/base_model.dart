class BaseModel {
  int id;
  String name;

  BaseModel({this.id, this.name});

  BaseModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BaseModel &&
              runtimeType == other.runtimeType &&
              name == other.name && id == other.id;

  @override
  int get hashCode => id.hashCode;
}