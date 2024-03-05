import 'dart:convert';

NotificatioListModel notificatioListModelFromJson(String str) => NotificatioListModel.fromJson(json.decode(str));

String notificatioListModelToJson(NotificatioListModel data) => json.encode(data.toJson());

class NotificatioListModel {
  NotificatioListModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  bool success;
  int statusCode;
  String message;
  List<NotificationData> data;

  factory NotificatioListModel.fromJson(Map<String, dynamic> json) => NotificatioListModel(
    success: json["success"] == null ? null : json["success"],
    statusCode: json["status_code"] == null ? null : json["status_code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<NotificationData>.from(json["data"].map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "status_code": statusCode == null ? null : statusCode,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationData {
  NotificationData({
    this.id,
    this.senderId,
    this.receiverId,
    this.packageId,
    this.collectionId,
    this.title,
    this.message,
    this.status,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  int senderId;
  int receiverId;
  int packageId;
  int collectionId;
  String title;
  String message;
  int status;
  int type;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    id: json["id"] == null ? null : json["id"],
    senderId: json["sender_id"] == null ? null : json["sender_id"],
    receiverId: json["receiver_id"] == null ? null : json["receiver_id"],
    packageId: json["package_id"] == null ? null : json["package_id"],
    collectionId: json["collection_center_id"] == null ? null : json["collection_center_id"],
    title: json["title"] == null ? null : json["title"],
    message: json["message"] == null ? null : json["message"],
    status: json["status"] == null ? null : json["status"],
    type: json["type"] == null ? null : json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "sender_id": senderId == null ? null : senderId,
    "receiver_id": receiverId == null ? null : receiverId,
    "package_id": packageId == null ? null : packageId,
    "collection_center_id": collectionId == null ? null : collectionId,
    "title": title == null ? null : title,
    "message": message == null ? null : message,
    "status": status == null ? null : status,
    "type": type == null ? null : type,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
