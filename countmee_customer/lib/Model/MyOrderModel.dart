class MyOrderModel {
  int id;
  String orderNumber;
  int userId;
  String pickupLocation;
  String pickupLatitude;
  String pickupLongitude;
  String dropLocation;
  String dropLatitude;
  String dropLongitude;
  String transportMode;
  int status;
  String deliveryCharge;
  String refundable;
  String discount;
  String totalPayable;
  String paymentType;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String packageStatus;

  MyOrderModel(
      {this.id,
      this.orderNumber,
      this.userId,
      this.pickupLocation,
      this.pickupLatitude,
      this.pickupLongitude,
      this.dropLocation,
      this.dropLatitude,
      this.dropLongitude,
      this.transportMode,
      this.status,
      this.deliveryCharge,
      this.refundable,
      this.discount,
      this.totalPayable,
      this.paymentType,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.packageStatus});

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    userId = json['user_id'];
    pickupLocation = json['pickup_location'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    dropLocation = json['drop_location'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    transportMode = json['transport_mode'];
    status = json['status'];
    deliveryCharge = json['delivery_charge'];
    refundable = json['refundable'];
    discount = json['discount'];
    totalPayable = json['total_payable'];
    paymentType = json['payment_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    packageStatus = json['package_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['user_id'] = this.userId;
    data['pickup_location'] = this.pickupLocation;
    data['pickup_latitude'] = this.pickupLatitude;
    data['pickup_longitude'] = this.pickupLongitude;
    data['drop_location'] = this.dropLocation;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['transport_mode'] = this.transportMode;
    data['status'] = this.status;
    data['delivery_charge'] = this.deliveryCharge;
    data['refundable'] = this.refundable;
    data['discount'] = this.discount;
    data['total_payable'] = this.totalPayable;
    data['payment_type'] = this.paymentType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['package_status'] = this.packageStatus;
    return data;
  }
}
