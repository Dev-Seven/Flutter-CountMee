class UserAPIDetails {
  String deliveryContact;
  String name;
  String address;
  String latitude;
  String longitude;
  String mobileNumber1;
  String mobileNumber2;
  String googleMapLink;


  UserAPIDetails(
      {this.deliveryContact,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.mobileNumber1,
      this.mobileNumber2,
      this.googleMapLink});

  UserAPIDetails.fromJson(Map<String, dynamic> json) {
    deliveryContact = json['delivery_contact'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mobileNumber1 = json['mobile_number_1'];
    mobileNumber2 = json['mobile_number_2'];
    googleMapLink = json['google_map_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_contact'] = this.deliveryContact;
    data['name'] = this.name;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['mobile_number_1'] = this.mobileNumber1;
    data['mobile_number_2'] = this.mobileNumber2;
    data['google_map_link'] = this.googleMapLink;
    return data;
  }
}
