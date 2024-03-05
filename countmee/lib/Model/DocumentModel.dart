class DocumentModel {
  int id;
  String adharcardNumber;
  String adharcardFile;
  String vehicleNumber;
  String vehicleDocument;
  int userId;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  DocumentModel(
      {this.id,
      this.adharcardNumber,
      this.adharcardFile,
      this.vehicleNumber,
      this.vehicleDocument,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adharcardNumber = json['adharcard_number'];
    adharcardFile = json['adharcard_file'];
    vehicleNumber = json['vehicle_number'];
    vehicleDocument = json['vehicle_document'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['adharcard_number'] = this.adharcardNumber;
    data['adharcard_file'] = this.adharcardFile;
    data['vehicle_number'] = this.vehicleNumber;
    data['vehicle_document'] = this.vehicleDocument;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
