import 'dart:convert';

import 'package:countmee/Model/ItemDetailModel.dart';

TrackOrderModel trackOrderModelFromJson(String str) => TrackOrderModel.fromJson(json.decode(str));

String trackOrderModelToJson(TrackOrderModel data) => json.encode(data.toJson());

class TrackOrderModel {
  TrackOrderModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  bool success;
  int statusCode;
  String message;
  Data data;

  factory TrackOrderModel.fromJson(Map<String, dynamic> json) => TrackOrderModel(
    success: json["success"] == null ? null : json["success"],
    statusCode: json["status_code"] == null ? null : json["status_code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "status_code": statusCode == null ? null : statusCode,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.orderDetails,
    this.trackDetails,
  });

  ItemDetailModel orderDetails;
  List<TrackDetail> trackDetails;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderDetails: json["order_details"] == null ? null : ItemDetailModel.fromJson(json["order_details"]),
    trackDetails: json["track_details"] == null ? null : List<TrackDetail>.from(json["track_details"].map((x) => TrackDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order_details": orderDetails == null ? null : orderDetails.toJson(),
    "track_details": trackDetails == null ? null : List<dynamic>.from(trackDetails.map((x) => x.toJson())),
  };
}

class TrackDetail {
  TrackDetail({
    this.id,
    this.orderId,
    this.customerId,
    this.deliveryBoyId,
    this.warehouseId,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupAddress,
    this.dropLatitude,
    this.dropLongitude,
    this.dropAddress,
    this.isDestination,
    this.isSource,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.warehouseDetails,
    this.deliveryBoyDetails,
  });

  int id;
  int orderId;
  int customerId;
  int deliveryBoyId;
  dynamic warehouseId;
  String pickupLatitude;
  String pickupLongitude;
  String pickupAddress;
  String dropLatitude;
  String dropLongitude;
  String dropAddress;
  int isDestination;
  int isSource;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  dynamic warehouseDetails;
  CreateBy deliveryBoyDetails;

  factory TrackDetail.fromJson(Map<String, dynamic> json) => TrackDetail(
    id: json["id"] == null ? null : json["id"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    customerId: json["customer_id"] == null ? null : json["customer_id"],
    deliveryBoyId: json["delivery_boy_id"] == null ? null : json["delivery_boy_id"],
    warehouseId: json["warehouse_id"],
    pickupLatitude: json["pickup_latitude"] == null ? null : json["pickup_latitude"],
    pickupLongitude: json["pickup_longitude"] == null ? null : json["pickup_longitude"],
    pickupAddress: json["pickup_address"] == null ? null : json["pickup_address"],
    dropLatitude: json["drop_latitude"] == null ? null : json["drop_latitude"],
    dropLongitude: json["drop_longitude"] == null ? null : json["drop_longitude"],
    dropAddress: json["drop_address"] == null ? null : json["drop_address"],
    isDestination: json["is_destination"] == null ? null : json["is_destination"],
    isSource: json["is_source"] == null ? null : json["is_source"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    warehouseDetails: json["warehouse_details"],
    deliveryBoyDetails: json["delivery_boy_details"] == null ? null : CreateBy.fromJson(json["delivery_boy_details"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "order_id": orderId == null ? null : orderId,
    "customer_id": customerId == null ? null : customerId,
    "delivery_boy_id": deliveryBoyId == null ? null : deliveryBoyId,
    "warehouse_id": warehouseId,
    "pickup_latitude": pickupLatitude == null ? null : pickupLatitude,
    "pickup_longitude": pickupLongitude == null ? null : pickupLongitude,
    "pickup_address": pickupAddress == null ? null : pickupAddress,
    "drop_latitude": dropLatitude == null ? null : dropLatitude,
    "drop_longitude": dropLongitude == null ? null : dropLongitude,
    "drop_address": dropAddress == null ? null : dropAddress,
    "is_destination": isDestination == null ? null : isDestination,
    "is_source": isSource == null ? null : isSource,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "warehouse_details": warehouseDetails,
    "delivery_boy_details": deliveryBoyDetails == null ? null : deliveryBoyDetails.toJson(),
  };
}