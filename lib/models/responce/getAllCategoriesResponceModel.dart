import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';

class GetAllProductCategories{
  int id;
  String name;
  String description;
  Images image;
  int count;


  GetAllProductCategories(this.id, this.name, this.description, this.image, this.count);

  GetAllProductCategories.fromJson(Map<String, dynamic> json){
    Map<String, dynamic> images=json['image'];
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = images==null?null:Images.fromJson(images);
    count = json['count'];
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'count': count
      };
}
