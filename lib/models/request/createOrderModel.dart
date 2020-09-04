
import 'package:flutterecom/models/request/customerBillingModel.dart';
import 'package:flutterecom/models/request/customerShippingModel.dart';

class CreateOrder{
  String payment_method;
  String payment_method_title;
  bool set_paid;
  Billing billing;
  Shipping shipping;
  List<Line_items> line_items;

  CreateOrder(this.payment_method, this.payment_method_title, this.set_paid, this.billing, this.shipping, this.line_items);
  CreateOrder.fromJson(Map<String, dynamic> json):
        payment_method = json['payment_method'],
        payment_method_title = json['payment_method_title'],
        set_paid = json['set_paid'],
        billing = Billing.fromJson(json['billing']),
        shipping = Shipping.fromJson(json['shipping']),
        line_items =  List<Line_items>.from(json['line_items'].map((data) => Line_items.fromJson(data)).toList())
  {}

  Map<String, dynamic> toJson() =>
      {
        'payment_method': payment_method,
        'payment_method_title': payment_method_title,
        'set_paid': set_paid,
        'billing': billing,
        'shipping': shipping,
        'line_items': line_items.map((element) {
          return element.toJson();
        }).toList(),
      };
}

class Line_items{
  int product_id;
  int variation_id=-1;
  int quantity;
  Line_items(this.product_id, this.variation_id, this.quantity );

  Line_items.fromJson(Map<String, dynamic> json):
        product_id = json['product_id'],
        variation_id = json.containsKey("variation_id")?json['variation_id']:-1,
        quantity = json['quantity']{}

  Map<String, dynamic> toJson()
  {
    Map<String, dynamic> map={
        'product_id': product_id,
        'variation_id': variation_id,
        'quantity': quantity,
      };
    map.removeWhere((key, value) => (key=="variation_id"&& value == -1));
    return map;
  }
}
