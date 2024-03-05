import 'package:countmee/Model/PandingDataModel.dart';

class CommissionModel {
  String date;
  List<Commission> commission;

  CommissionModel({
    this.date,
    this.commission,
  });

  CommissionModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['commission'] != null) {
      commission = new List<Commission>();
      json['commission'].forEach((v) {
        commission.add(new Commission.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.commission != null) {
      data['commission'] =
          this.commission.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Commission {
  int id;
  int userId;
  int packageId;
  String commission;
  String createdAt;
  String updatedAt;
  String deletedAt;
  PandingDataModel packageDetail;

  Commission(
      {
        this.id,
        this.userId,
        this.packageId,
        this.commission,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.packageDetail,
      });

  Commission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    packageId = json['package_id'];
    commission = json['commision'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    packageDetail = json['package'] != null
        ? new PandingDataModel.fromJson(json['package'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['package_id'] = this.packageId;
    data['commision'] = this.commission;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.packageDetail != null) {
      data['package'] = this.packageDetail.toJson();
    }
    return data;
  }
}