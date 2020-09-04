
import 'package:flutterecom/models/request/customerCreateModel.dart';

class GetAllProducts{
  int id;
  String title;
  String status;
  bool featured;
  String description;
  String short_description;
  String price;
  String regular_price;
  String sale_price;
  bool on_sale;
  int total_sales;
  String average_rating;
  int rating_count;
  List<int> related_ids;
  List<String> categories;
  List<String> tags;
  List<Images> images;
  List<ProductAttributes> attributes;
  List<Variations> variations;


  GetAllProducts(this.id, this.title, this.status, this.featured,
      this.description, this.short_description, this.price, this.regular_price,
      this.sale_price, this.on_sale, this.total_sales, this.average_rating,
      this.rating_count, this.related_ids, this.categories, this.tags, this.images,
      this.attributes, this.variations);

  GetAllProducts.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    status = json['status'];
    featured = json['featured'];
    description = json['description'];
    short_description = json['short_description'];
    price = json['price'];
    regular_price = json['regular_price'];
    sale_price = json['sale_price'];
    on_sale = json['on_sale'];
    total_sales = json['total_sales'];
    average_rating = json['average_rating'];
    rating_count = json['rating_count'];
    related_ids = List<int>.from(json['related_ids'].map((data) => data).toList());
    categories = List<String>.from(json['categories'].map((data) => data).toList());
    tags = List<String>.from(json['tags'].map((data) => data).toList());
    images = List<Images>.from(json['images'].map((data) => Images.fromJson(data)).toList());
    attributes = List<ProductAttributes>.from(json['attributes'].map((data) => ProductAttributes.fromJson(data)).toList());
    variations = List<Variations>.from(json['variations'].map((data) => Variations.fromJson(data)).toList());
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'title': title,
        'status': status,
        'featured': featured,
        'description': description,
        'short_description': short_description,
        'price': price,
        'regular_price': regular_price,
        'sale_price': sale_price,
        'on_sale': on_sale,
        'total_sales': total_sales,
        'average_rating': average_rating,
        'rating_count': rating_count,
        'related_ids': related_ids,
        'categories': categories,
        'tags': tags,
        'images': images,
        'attributes': attributes,
        'variations': variations,
      };
}

class Categories{
  int id;
  String name;
  String slug;


  Categories(this.id, this.name, this.slug);

  Categories.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'],
        slug = json['slug']
  {}

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'slug': slug,
      };
}

class Images{
  int id;
  String src;
  String name;


  Images(this.id, this.src, this.name);

  Images.fromJson(Map<String, dynamic> json):
        id = json['id'],
        src = json['src'],
        name = json['name']
  {}

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'src': src,
        'name': name,
      };
}

class ProductAttributes{
  int id;
  String name;
  bool visible;
  List<String> options;


  ProductAttributes(this.id, this.name, this.visible, this.options);

  ProductAttributes.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'],
        visible = json['visible'],
        options = List<String>.from(json['options'].map((data) => data as String).toList())
  {}

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'visible': visible,
        'options': options,
      };
}

class Variations{
  int id;
  String sku;
  String price;
  String regular_price;
  String sale_price;
  int stock_quantity;
  bool in_stock;
  bool purchaseable;
  bool visible;
  bool on_sale;
  List<Images> images;
  List<VariationAttributes> attributes;


  Variations(this.id, this.sku, this.price, this.regular_price, this.sale_price,
      this.stock_quantity, this.in_stock, this.purchaseable, this.visible,
      this.on_sale, this.images, this.attributes);

  Variations.fromJson(Map<String, dynamic> json):
        id = json['id'],
        sku = json['sku'],
        price = json['price'],
        regular_price = json['regular_price'],
        sale_price = json['sale_price'],
        stock_quantity = json['stock_quantity'],
        in_stock = json['in_stock'],
        purchaseable = json['purchaseable'],
        visible = json['visible'],
        on_sale = json['on_sale'],
        images = List<Images>.from(json['image'].map((data) => Images.fromJson(data)).toList()),
        attributes = List<VariationAttributes>.from(json['attributes'].map((data) => VariationAttributes.fromJson(data)).toList())
  {}

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'sku': sku,
        'price': price,
        'regular_price': regular_price,
        'sale_price': sale_price,
        'stock_quantity': stock_quantity,
        'in_stock': in_stock,
        'purchaseable': purchaseable,
        'visible': visible,
        'on_sale': on_sale,
        'images': images,
        'attributes': attributes,
      };
}

class VariationAttributes{
  String name;
  String option;


  VariationAttributes(this.name, this.option);

  VariationAttributes.fromJson(Map<String, dynamic> json):
        name = json['name'],
        option = json['option']
  {}

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'option': option,
      };
}
