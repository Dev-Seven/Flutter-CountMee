class OrderCountModel {
  int deliveredOrders;
  int rejectedOrders;
  int pendingOrders;

  OrderCountModel(
      {this.deliveredOrders, this.rejectedOrders, this.pendingOrders});

  OrderCountModel.fromJson(Map<String, dynamic> json) {
    deliveredOrders = json['delivered_orders'];
    rejectedOrders = json['rejected_orders'];
    pendingOrders = json['pending_orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivered_orders'] = this.deliveredOrders;
    data['rejected_orders'] = this.rejectedOrders;
    data['pending_orders'] = this.pendingOrders;
    return data;
  }
}
