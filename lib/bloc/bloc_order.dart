import 'dart:async';
import 'package:flutterecom/emuns/ratingType.dart';
import 'package:flutterecom/emuns/orderType.dart';
import 'package:flutterecom/models/responce/getAllOrderResponceModel.dart';

class OrderBloc{

  //-------------------------------------- SELECTIONS -------------------------------------//
  //order selection
  final selectOrderTypeStreamController = StreamController<OrderStatus>.broadcast();
  StreamSink<OrderStatus> get selectOrderType_sink => selectOrderTypeStreamController.sink;
  Stream<OrderStatus> get selectOrderType_counter => selectOrderTypeStreamController.stream;

  selectOrderType(OrderStatus orderStatus){
    selectOrderType_sink.add(orderStatus);
  }

  //-------------------------------------- HTTP REQUESTS -------------------------------------//
  //get orders
  final getOrderStreamController = StreamController<List<GetOrderResponce>>.broadcast();
  StreamSink<List<GetOrderResponce>> get getOrder_sink => getOrderStreamController.sink;
  Stream<List<GetOrderResponce>> get getOrder_counter => getOrderStreamController.stream;

  refreshOrders(List<GetOrderResponce> orders){
    getOrder_sink.add(orders);
  }


}

final OrderBloc orderBloc=new OrderBloc();