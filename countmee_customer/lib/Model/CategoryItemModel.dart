class CategoryItemModel {
  int id;
  String name;
  int status;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  CategoryItemModel(
      {this.id,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CategoryItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
