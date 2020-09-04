

class PaymentGatewayResponce{
  String id;
  String title;
  String description;
  bool enabled;


  PaymentGatewayResponce(this.id, this.title, this.description, this.enabled);

  PaymentGatewayResponce.fromJson(Map<String, dynamic> json):
        id = json['id'],
        title = json['title'],
        description = json['description'],
        enabled = json['enabled']
  {}

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'title': title,
        'description': description,
        'enabled': enabled,
      };
}

