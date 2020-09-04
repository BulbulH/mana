


import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/responce/getAllCategoriesResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/prefrences.dart';

GetAllProducts getProductFromId(int productId){
  GetAllProducts thisProduct=null;
  if(products!=null)
  products.forEach((_Product){
    if(_Product.id==productId)
      thisProduct=_Product;
  });

  return thisProduct;
}

bool getIsCouponValidInProducts(_coupon,GetAllProducts getallproduct){
  bool couponAppicableOnProduct=_coupon.product_ids.length==0;

  _coupon.product_ids.forEach((CouponProductId) {

    int _excludeproductId =_coupon.excluded_product_ids.firstWhere((_exProductId) => _exProductId==CouponProductId||_exProductId==getallproduct.id,orElse:() =>  0);

    if(getallproduct.id==CouponProductId && _excludeproductId==0){
      couponAppicableOnProduct= true;
    }
  });
  return couponAppicableOnProduct;
}

bool getIsCouponValidInCategories(_coupon,GetAllProducts getallproduct){
  bool couponAppicableOnCategories=_coupon.product_categories.length==0;
  _coupon.product_categories.forEach((CouponCategoryId) {
    int _excludeCatId =_coupon.excluded_product_categories.firstWhere((_exCatId) => _exCatId==CouponCategoryId,orElse:() =>  0);

    if( _excludeCatId==0){

        GetAllProductCategories cat=categories.firstWhere((category) => category.id==CouponCategoryId && getallproduct.categories.contains(category.name),orElse:() => null);
        return cat!=null ;
    }
  });
  return couponAppicableOnCategories;
}
bool getIsCouponValidInAllProducts(_coupon){
  bool couponAppicableOnProduct=_coupon.product_ids.length==0;

  _coupon.product_ids.forEach((CouponProductId) {

    int _excludeproductId =_coupon.excluded_product_ids.firstWhere((_exProductId) => _exProductId==CouponProductId,orElse:() =>  0);
    Line_items cartItem =getCartProductsPref().firstWhere((_product) => _product.product_id==CouponProductId,orElse:() =>  null);

    if(cartItem!=null && _excludeproductId==0){
      couponAppicableOnProduct= true;
    }
  });
  return couponAppicableOnProduct;
}

bool getIsCouponValidInAllCategories(_coupon){
  bool couponAppicableOnCategories=_coupon.product_categories.length==0;
  _coupon.product_categories.forEach((CouponCategoryId) {
    int _excludeCatId =_coupon.excluded_product_categories.firstWhere((_exCatId) => _exCatId==CouponCategoryId,orElse:() =>  0);

    if(  _excludeCatId==0){
      GetAllProducts product=products.firstWhere((_product) {
        Line_items item=getCartProductsPref().firstWhere((_item) => _item.product_id==_product.id,orElse:() => null);
        GetAllProductCategories cat=categories.firstWhere((category) => category.id==CouponCategoryId && _product.categories.contains(category.name),orElse:() => null);
        return  cat!=null && item!=null;
      },orElse:() =>  null);

      if(product!=null)
        couponAppicableOnCategories=true;
    }
  });
  return couponAppicableOnCategories;
}