class CardDetailModel {
  int id;
  int userId;
  String cardId;
  String expiryYear;
  int isDefault;
  String cardNumber;
  String cardName;
  String expiryMonth;
  int cvv;
  Null zipcode;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  CardDetailModel(
      {this.id,
      this.userId,
      this.cardId,
      this.expiryYear,
      this.isDefault,
      this.cardNumber,
      this.cardName,
      this.expiryMonth,
      this.cvv,
      this.zipcode,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CardDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cardId = json['card_id'];
    expiryYear = json['expiry_year'];
    isDefault = json['is_default'];
    cardNumber = json['card_number'];
    cardName = json['card_name'];
    expiryMonth = json['expiry_month'];
    cvv = json['cvv'];
    zipcode = json['zipcode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['card_id'] = this.cardId;
    data['expiry_year'] = this.expiryYear;
    data['is_default'] = this.isDefault;
    data['card_number'] = this.cardNumber;
    data['card_name'] = this.cardName;
    data['expiry_month'] = this.expiryMonth;
    data['cvv'] = this.cvv;
    data['zipcode'] = this.zipcode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
