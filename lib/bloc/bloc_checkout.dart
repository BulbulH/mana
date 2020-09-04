import 'dart:async';
import 'package:flutterecom/emuns/checkOutType.dart';
import 'package:flutterecom/models/responce/getAllOrderResponceModel.dart';

class CheckOutBloc{

  //-------------------------------------- SELECTIONS -------------------------------------//
//  order selection
  final selectCheckoutStreamController = StreamController<CheckOutType>.broadcast();
  StreamSink<CheckOutType> get selectCheckOutType_sink => selectCheckoutStreamController.sink;
  Stream<CheckOutType> get selectCheckOutType_counter => selectCheckoutStreamController.stream;

  selectCheckOut(CheckOutType checkOutType){
    selectCheckOutType_sink.add(checkOutType);
  }

  //-------------------------------------- HTTP REQUESTS -------------------------------------//
//  //get orders
//  final getOrderStreamController = StreamController<List<GetOrderResponce>>.broadcast();
//  StreamSink<List<GetOrderResponce>> get getOrder_sink => getOrderStreamController.sink;
//  Stream<List<GetOrderResponce>> get getOrder_counter => getOrderStreamController.stream;
//
//  refreshOrders(List<GetOrderResponce> orders){
//    getOrder_sink.add(orders);
//  }

}

final CheckOutBloc checkOutBloc=new CheckOutBloc();