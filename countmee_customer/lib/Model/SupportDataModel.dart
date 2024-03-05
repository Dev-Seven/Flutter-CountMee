class SupportDataModel {
  int id;
  String type;
  String name;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  SupportDataModel(
      {this.id,
      this.type,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  SupportDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
