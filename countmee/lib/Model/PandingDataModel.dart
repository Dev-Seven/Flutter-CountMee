class PandingDataModel {
  int id;
  String orderNumber;
  int userId;
  dynamic deliveryboy_id;
  String is_drop;
  int first_deliveryboy;
  String is_delivered;
  String is_pickup;
  bool is_collection_center;
  String pickupLocation;
  String pickupLatitude;
  String pickupLongitude;
  String dropLocation;
  String dropLatitude;
  String dropLongitude;
  String transportMode;
  String transportImage;
  String updatedPickupLocation;
  String updatedPickupLatitude;
  String updatedPickupLongitude;
  String updatedDropLocation;
  String updatedDropLatitude;
  String updatedDropLongitude;
  int status;
  String deliveryCharge;
  String refundable;
  String discount;
  String totalPayable;
  String paymentType;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String commission;
  List<PackageDetail> packageDetail;
  List<PackageImage> packageImages;
  List<Users> users;
  CreateBy createBy;
  dynamic isRequestDrop;

  @override
  String toString() {
    return 'PandingDataModel{id: $id, orderNumber: $orderNumber, is_collection_center: $is_collection_center,userId: $userId, pickupLocation: $pickupLocation, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, dropLocation: $dropLocation, dropLatitude: $dropLatitude, dropLongitude: $dropLongitude, transportMode: $transportMode, status: $status, deliveryCharge: $deliveryCharge, refundable: $refundable, discount: $discount, totalPayable: $totalPayable, paymentType: $paymentType, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, packageDetail: $packageDetail, packageImages: $packageImages, users: $users, createBy: $createBy}';
  }

  PandingDataModel(
      {this.id,
      this.orderNumber,
      this.userId,
      this.deliveryboy_id,
      this.is_delivered,
      this.is_drop,
      this.is_pickup,
      this.is_collection_center,
      this.pickupLocation,
      this.pickupLatitude,
      this.pickupLongitude,
      this.first_deliveryboy,
      this.dropLocation,
      this.dropLatitude,
      this.dropLongitude,
      this.transportMode,
      this.transportImage,
      this.updatedPickupLocation,
      this.updatedPickupLatitude,
      this.updatedPickupLongitude,
      this.updatedDropLocation,
      this.updatedDropLatitude,
      this.updatedDropLongitude,
      this.status,
      this.deliveryCharge,
      this.refundable,
      this.discount,
      this.totalPayable,
      this.paymentType,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.commission,
      this.packageDetail,
      this.packageImages,
      this.users,
      this.createBy,
      this.isRequestDrop});

  PandingDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    userId = json['user_id'];
    deliveryboy_id = json['deliveryboy_id'];
    first_deliveryboy = json['first_deliveryboy'];
    is_pickup = json['is_pickup'];
    is_drop = json['is_drop'];
    is_delivered = json['is_delivered'];
    is_collection_center = json['is_collection_center'];
    pickupLocation = json['pickup_location'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    dropLocation = json['drop_location'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    transportMode = json['transport_mode'];
    transportImage = json['transport_image'];
    updatedPickupLocation = json['updated_pickup_location'];
    updatedPickupLatitude = json['updated_pickup_latitude'];
    updatedPickupLongitude = json['updated_pickup_longitude'];
    updatedDropLocation = json['updated_drop_location'];
    updatedDropLatitude = json['updated_drop_latitude'];
    updatedDropLongitude = json['updated_drop_longitude'];
    status = json['status'];
    deliveryCharge = json['delivery_charge'];
    refundable = json['refundable'];
    discount = json['discount'];
    totalPayable = json['total_payable'];
    paymentType = json['payment_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    commission = json['commission'];
    isRequestDrop = json['is_drop_request'];
    if (json['package_detail'] != null) {
      packageDetail = new List<PackageDetail>();
      json['package_detail'].forEach((v) {
        packageDetail.add(new PackageDetail.fromJson(v));
      });
    }
    if (json['package_image'] != null) {
      packageImages = new List<PackageImage>();
      json['package_image'].forEach((v) {
        packageImages.add(new PackageImage.fromJson(v));
      });
    }
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    createBy = json['create_by'] != null
        ? new CreateBy.fromJson(json['create_by'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['user_id'] = this.userId;
    data['deliveryboy_id'] = this.deliveryboy_id;
    data['first_deliveryboy'] = this.first_deliveryboy;
    data['is_drop'] = this.is_drop;
    data['is_delivered'] = this.is_delivered;
    data['is_collection_center'] = this.is_collection_center;
    data['pickup_location'] = this.pickupLocation;
    data['pickup_latitude'] = this.pickupLatitude;
    data['pickup_longitude'] = this.pickupLongitude;
    data['drop_location'] = this.dropLocation;
    data['is_pickup'] = this.is_pickup;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['transport_mode'] = this.transportMode;
    data['transport_image'] = this.transportImage;
    data['updated_pickup_location'] = this.updatedPickupLocation;
    data['updated_pickup_latitude'] = this.updatedPickupLatitude;
    data['updated_pickup_longitude'] = this.updatedPickupLongitude;
    data['updated_drop_location'] = this.updatedDropLocation;
    data['updated_drop_latitude'] = this.updatedDropLatitude;
    data['updated_drop_longitude'] = this.updatedDropLongitude;
    data['status'] = this.status;
    data['delivery_charge'] = this.deliveryCharge;
    data['refundable'] = this.refundable;
    data['discount'] = this.discount;
    data['total_payable'] = this.totalPayable;
    data['payment_type'] = this.paymentType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['commission'] = this.commission;
    data['is_drop_request'] = this.isRequestDrop;
    if (this.packageDetail != null) {
      data['package_detail'] =
          this.packageDetail.map((v) => v.toJson()).toList();
    }
    if (this.packageImages != null) {
      data['package_image'] =
          this.packageImages.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.createBy != null) {
      data['create_by'] = this.createBy.toJson();
    }
    return data;
  }
}

class PackageDetail {
  int id;
  int userId;
  int packageId;
  String productName;
  String parcelSize;
  String handleProduct;
  String deliveryPriority;
  String itemCategories;
  String weight;
  String length;
  String width;
  String height;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String productDesc;
  String otherProductDesc;
  int courierBag;

  PackageDetail(
      {this.id,
      this.userId,
      this.packageId,
      this.productName,
      this.parcelSize,
      this.handleProduct,
      this.deliveryPriority,
      this.itemCategories,
      this.weight,
      this.length,
      this.width,
      this.height,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.otherProductDesc,
      this.courierBag,
      this.productDesc});

  PackageDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    packageId = json['package_id'];
    productName = json['product_name'];
    parcelSize = json['parcel_size'];
    handleProduct = json['handle_product'];
    deliveryPriority = json['delivery_priority'];
    itemCategories = json['item_categories'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    productDesc = json['description'];
    otherProductDesc = json['other_description'];
    courierBag = json['courier_bag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['package_id'] = this.packageId;
    data['product_name'] = this.productName;
    data['parcel_size'] = this.parcelSize;
    data['handle_product'] = this.handleProduct;
    data['delivery_priority'] = this.deliveryPriority;
    data['item_categories'] = this.itemCategories;
    data['weight'] = this.weight;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['description'] = this.productDesc;
    data['other_description'] = this.otherProductDesc;
    data['courier_bag'] = this.courierBag;
    return data;
  }
}

class PackageImage {
  int id;
  int packageDetailId;
  int packageId;
  String type;
  String image;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  PackageImage(
      {this.id,
      this.packageDetailId,
      this.packageId,
      this.type,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  PackageImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageDetailId = json['package_detail_id'];
    packageId = json['package_id'];
    type = json['type'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_detail_id'] = this.packageDetailId;
    data['package_id'] = this.packageId;
    data['type'] = this.type;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Users {
  int id;
  int packageId;
  int userId;
  String deliveryContact;
  String userType;
  String name;
  String address;
  String latitude;
  String longitude;
  String officeName;
  String mobileNumber1;
  String mobileNumber2;
  String addressAs;
  String googleMapLink;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  @override
  String toString() {
    return 'Users{id: $id, packageId: $packageId, userId: $userId, deliveryContact: $deliveryContact, userType: $userType, name: $name, address: $address, latitude: $latitude, longitude: $longitude, officeName: $officeName, mobileNumber1: $mobileNumber1, mobileNumber2: $mobileNumber2, addressAs: $addressAs, googleMapLink: $googleMapLink, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }

  Users(
      {this.id,
      this.packageId,
      this.userId,
      this.deliveryContact,
      this.userType,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.officeName,
      this.mobileNumber1,
      this.mobileNumber2,
      this.addressAs,
      this.googleMapLink,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    userId = json['user_id'];
    deliveryContact = json['delivery_contact'];
    userType = json['user_type'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    officeName = json['office_name'];
    mobileNumber1 = json['mobile_number_1'];
    mobileNumber2 = json['mobile_number_2'];
    addressAs = json['address_as'];
    googleMapLink = json['google_map_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_id'] = this.packageId;
    data['user_id'] = this.userId;
    data['delivery_contact'] = this.deliveryContact;
    data['user_type'] = this.userType;
    data['name'] = this.name;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['office_name'] = this.officeName;
    data['mobile_number_1'] = this.mobileNumber1;
    data['mobile_number_2'] = this.mobileNumber2;
    data['address_as'] = this.addressAs;
    data['google_map_link'] = this.googleMapLink;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class CreateBy {
  int id;
  String firstName;
  String lastName;
  String name;
  Null username;
  String email;
  Null phoneCode;
  String phoneNumber;
  String address;
  Null city;
  Null cityId;
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
  Null parentCollectionCenterId;
  Null rememberToken;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  @override
  String toString() {
    return 'CreateBy{id: $id, firstName: $firstName, lastName: $lastName, name: $name, username: $username, email: $email, phoneCode: $phoneCode, phoneNumber: $phoneNumber, address: $address, city: $city, cityId: $cityId, latitude: $latitude, longitude: $longitude, image: $image, role: $role, otp: $otp, notificationStatus: $notificationStatus, totalCommision: $totalCommision, status: $status, activate: $activate, isConfirm: $isConfirm, emailVerifiedAt: $emailVerifiedAt, password: $password, parentCollectionCenterId: $parentCollectionCenterId, rememberToken: $rememberToken, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }

  CreateBy(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.username,
      this.email,
      this.phoneCode,
      this.phoneNumber,
      this.address,
      this.city,
      this.cityId,
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
      this.parentCollectionCenterId,
      this.rememberToken,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CreateBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    city = json['city'];
    cityId = json['city_id'];
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
    parentCollectionCenterId = json['parent_collection_center_id'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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
    data['city'] = this.city;
    data['city_id'] = this.cityId;
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
    data['parent_collection_center_id'] = this.parentCollectionCenterId;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
