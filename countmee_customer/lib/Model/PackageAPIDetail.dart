class PackageAPIDetail {
  String productDesc;
  String otherProductDesc;
  int courierBag;
  String parcelSize;
  String handleProduct;
  String weight;


  @override
  String toString() {
    return 'PackageAPIDetail{productDesc: $productDesc, otherProductDesc: $otherProductDesc, parcelSize: $parcelSize, handleProduct: $handleProduct, weight: $weight, courierBag: $courierBag}';
  }

  PackageAPIDetail({
      this.handleProduct,
      this.weight,
      this.productDesc,
      this.otherProductDesc,
      this.parcelSize,
      this.courierBag,
  });

  PackageAPIDetail.fromJson(Map<String, dynamic> json) {
    parcelSize = json['parcel_size'];
    handleProduct = json['handle_product'];
    weight = json['weight'];
    productDesc = json['description'];
    otherProductDesc = json['other_description'];
    courierBag = json['courier_bag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parcel_size'] = this.parcelSize;
    data['handle_product'] = this.handleProduct;
    data['weight'] = this.weight;
    data['description'] = this.productDesc;
    data['other_description'] = this.otherProductDesc;
    data['courier_bag'] = this.courierBag;
    return data;
  }
}
