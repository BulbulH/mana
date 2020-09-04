import 'dart:async';
import 'package:flutterecom/emuns/ratingType.dart';
import 'package:flutterecom/emuns/listtype.dart';
import 'package:flutterecom/models/responce/getAllCategoriesResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';

class HomeBloc{

  //-------------------------------------- SELECTIONS -------------------------------------//
  //category selection
  final filterStreamController = StreamController<int>.broadcast();
  StreamSink<int> get filter_sink => filterStreamController.sink;
  Stream<int> get filter_counter => filterStreamController.stream;

  selectCategory(int categoryId){
    filter_sink.add(categoryId);
  }

  //-------------------------------------- HTTP REQUESTS -------------------------------------//
  //get Products
  final getProductStreamController = StreamController<List<GetAllProducts>>.broadcast();
  StreamSink<List<GetAllProducts>> get getProduct_sink => getProductStreamController.sink;
  Stream<List<GetAllProducts>> get getProduct_counter => getProductStreamController.stream;

  refreshProducts(List<GetAllProducts> products){
    getProduct_sink.add(products);
  }


  //get categories
  final getProductCategoryStreamController = StreamController<List<GetAllProductCategories>>.broadcast();
  StreamSink<List<GetAllProductCategories>> get getProductCategory_sink => getProductCategoryStreamController.sink;
  Stream<List<GetAllProductCategories>> get getProductCategory_counter => getProductCategoryStreamController.stream;

  refreshProductCategories(List<GetAllProductCategories> categories){
    getProductCategory_sink.add(categories);
  }

}

final HomeBloc homeBloc=new HomeBloc();