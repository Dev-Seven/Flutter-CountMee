import 'dart:convert';

TransportModeModel transportModeModelFromJson(String str) => TransportModeModel.fromJson(json.decode(str));

String transportModeModelToJson(TransportModeModel data) => json.encode(data.toJson());

class TransportModeModel {
  TransportModeModel({
    this.id,
    this.transportId,
    this.name,
    this.price,
    this.maximumWeight,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.image,
  });

  int id;
  String transportId;
  String name;
  String price;
  String maximumWeight;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String image;

  factory TransportModeModel.fromJson(Map<String, dynamic> json) => TransportModeModel(
    id: json["id"] == null ? null : json["id"],
    transportId: json["transport_id"] == null ? null : json["transport_id"],
    name: json["name"] == null ? null : json["name"],
    price: json["price"] == null ? null : json["price"],
    maximumWeight: json["maximum_weight"] == null ? null : json["maximum_weight"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "transport_id": transportId == null ? null : transportId,
    "name": name == null ? null : name,
    "price": price == null ? null : price,
    "maximum_weight": maximumWeight == null ? null : maximumWeight,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "image": image == null ? null : image,
  };
}
