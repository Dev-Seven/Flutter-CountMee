import 'dart:convert';

OrderResponseModel orderResponseModelFromJson(String str) => OrderResponseModel.fromJson(json.decode(str));

String orderResponseModelToJson(OrderResponseModel data) => json.encode(data.toJson());

class OrderResponseModel {
  OrderResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  bool success;
  int statusCode;
  String message;
  Order data;

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) => OrderResponseModel(
    success: json["success"] == null ? null : json["success"],
    statusCode: json["status_code"] == null ? null : json["status_code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Order.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "status_code": statusCode == null ? null : statusCode,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Order {
  Order({
    this.orderNumber,
    this.userId,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupLocation,
    this.dropLatitude,
    this.dropLongitude,
    this.dropLocation,
    this.transportMode,
    this.totalDistance,
    this.totalPayable,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String orderNumber;
  int userId;
  String pickupLatitude;
  String pickupLongitude;
  String pickupLocation;
  String dropLatitude;
  String dropLongitude;
  String dropLocation;
  String transportMode;
  String totalDistance;
  String totalPayable;
  int status;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderNumber: json["order_number"] == null ? null : json["order_number"],
    userId: json["user_id"] == null ? null : json["user_id"],
    pickupLatitude: json["pickup_latitude"] == null ? null : json["pickup_latitude"],
    pickupLongitude: json["pickup_longitude"] == null ? null : json["pickup_longitude"],
    pickupLocation: json["pickup_location"] == null ? null : json["pickup_location"],
    dropLatitude: json["drop_latitude"] == null ? null : json["drop_latitude"],
    dropLongitude: json["drop_longitude"] == null ? null : json["drop_longitude"],
    dropLocation: json["drop_location"] == null ? null : json["drop_location"],
    transportMode: json["transport_mode"] == null ? null : json["transport_mode"],
    totalDistance: json["total_distance"] == null ? null : json["total_distance"],
    totalPayable: json["total_payable"] == null ? null : json["total_payable"],
    status: json["status"] == null ? null : json["status"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "order_number": orderNumber == null ? null : orderNumber,
    "user_id": userId == null ? null : userId,
    "pickup_latitude": pickupLatitude == null ? null : pickupLatitude,
    "pickup_longitude": pickupLongitude == null ? null : pickupLongitude,
    "pickup_location": pickupLocation == null ? null : pickupLocation,
    "drop_latitude": dropLatitude == null ? null : dropLatitude,
    "drop_longitude": dropLongitude == null ? null : dropLongitude,
    "drop_location": dropLocation == null ? null : dropLocation,
    "transport_mode": transportMode == null ? null : transportMode,
    "total_distance": totalDistance == null ? null : totalDistance,
    "total_payable": totalPayable == null ? null : totalPayable,
    "status": status == null ? null : status,
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "id": id == null ? null : id,
  };
}
