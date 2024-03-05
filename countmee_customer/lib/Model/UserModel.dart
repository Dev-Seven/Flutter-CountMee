class UserModel {
  int id;
  String firstName;
  String lastName;
  String name;
  String username;
  String email;
  String phoneCode;
  String phoneNumber;
  String address;
  String latitude;
  String longitude;
  String image;
  int role;
  int otp;
  int notificationStatus;
  String totalCommision;
  int status;
  int activate;
  int isConfirm;
  Null emailVerifiedAt;
  String password;
  Null rememberToken;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String token;

  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.username,
      this.email,
      this.phoneCode,
      this.phoneNumber,
      this.address,
      this.latitude,
      this.longitude,
      this.image,
      this.role,
      this.otp,
      this.notificationStatus,
      this.totalCommision,
      this.status,
      this.activate,
      this.isConfirm,
      this.emailVerifiedAt,
      this.password,
      this.rememberToken,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    image = json['image'];
    role = json['role'];
    otp = json['otp'];
    notificationStatus = json['notification_status'];
    totalCommision = json['total_commision'];
    status = json['status'];
    activate = json['activate'];
    isConfirm = json['is_confirm'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone_code'] = this.phoneCode;
    data['phone_number'] = this.phoneNumber;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['image'] = this.image;
    data['role'] = this.role;
    data['otp'] = this.otp;
    data['notification_status'] = this.notificationStatus;
    data['total_commision'] = this.totalCommision;
    data['status'] = this.status;
    data['activate'] = this.activate;
    data['is_confirm'] = this.isConfirm;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['token'] = this.token;
    return data;
  }
}
