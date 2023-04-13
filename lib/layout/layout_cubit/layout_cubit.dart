import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/layout/layout_cubit/layout_states.dart';
import 'package:ecommerce_app/models/category_model.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/modules/cart_screen/cart_screen.dart';
import 'package:ecommerce_app/modules/categories_screen/categories_screen.dart';
import 'package:ecommerce_app/modules/favorites_screen/favorites_screen.dart';
import 'package:ecommerce_app/modules/home_screen/home_screen.dart';
import 'package:ecommerce_app/modules/profile_screen/profile_screen.dart';
import 'package:ecommerce_app/shared/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http ;
import 'package:http/http.dart';
import '../../models/banner_model.dart';
import '../../models/product_model.dart';
import '../../shared/network/local_network.dart';

class LayoutCubit extends Cubit<LayoutStates>{
  LayoutCubit() : super(LayoutInitialState());

  int bottomNavIndex = 0 ;
  void changeBottomNavIndex({required int currentIndex}){
    bottomNavIndex = currentIndex ;
    emit(ChangeBottomNavigationIndexState());
  }

  List<Widget> layoutScreens = [const HomeScreen(),const CategoriesScreen(),const FavoritesScreen(),const CartScreen(),const ProfileScreen()];

  UserModel? userModel;
  void getUserData() async {
    emit(GetUserDataLoadingState());
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/profile"),
        headers:
        {
          'Authorization' : token!,
        }
    );
    var responseData = jsonDecode(response.body);
    if( responseData['status'] == true )
    {
      userModel = UserModel.fromJson(responseData['data']);
      debugPrint("User Data is : ${responseData['data']}");
      emit(GetUserDataSuccessState());
    }
    else
    {
      emit(FailedToGetUserDataState(responseData['message']));
    }
  }

  List<BannerModel> bannersData = [];
  // Get Banners Data
  void getBanners() async {
    Response response = await http.get(
      Uri.parse("https://student.valuxapps.com/api/banners"),
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      for( var item in responseBody['data'] )
      {
        bannersData.add(BannerModel.fromJson(data: item));
      }

      emit(GetBannersSuccessState());
    }
    else
    {
      bannersData = [];
      print("Banners Data is : $responseBody");
      emit(FailedToGetBannersState());
    }
  }

  List<CategoryModel> categoriesData = [];
  void getCategories() async {
    emit(GetCategoriesLoadingState());
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/categories"),
        headers:
        {
          'lang' : 'en'
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      for( var item in responseBody['data']['data'] )
      {
        categoriesData.add(CategoryModel.fromJson(data: item));
      }
      // print("First Url on Categories Data is : ${categoriesData.first.image}");
      emit(GetCategoriesSuccessState());
    }
    else
    {
      categoriesData = [];
      print("Banners Data is : $responseBody");
      emit(FailedToGetCategoriesState());
    }
  }

  List<ProductModel> productsData = [];
  // Get Banners Data
  Set<String> favoritesStatus = {};
  void getProducts() async {
    emit(GetProductsLoadingState());
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/home"),
        headers:
        {
          'lang' : "en"
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      for( var item in responseBody['data']['products'] )
      {
        productsData.add(ProductModel.fromJson(json: item));
      }
      emit(GetProductsSuccessState());
    }
    else
    {
      productsData = [];
      emit(FailedToGetProductsState());
    }
  }

  List<ProductModel> productsFiltered = [];
  void filterProducts({required String input})
  {
    productsFiltered = productsData.where((element)
    {
      return element.name.toString().toLowerCase().startsWith(input.toLowerCase());
    }).toList();
    emit(FilterProductsSuccessState());
  }

  List<ProductModel> favoritesData = [];
  Future<void> getFavorites() async {
    favoritesData.clear();
    emit(GetFavoritesLoadingState());
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/favorites"),
        headers:
        {
          'lang' : 'en',
          'Authorization' : token!
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      for( var item in responseBody['data']['data'] )
      {
        favoritesStatus.add(item['product']['id'].toString());
        favoritesData.add(ProductModel.fromJson(json: item['product']));
      }
      debugPrint("Favorites number is : ${responseBody['data']['total']}");
      debugPrint("Favorites Status Number is : ${favoritesStatus.length}");
      emit(GetFavoritesSuccessState());
    }
    else
    {
      favoritesData = [];
      debugPrint("Favorites Data is : $responseBody");
      emit(FailedToGetFavoritesState());
    }
  }


  List<ProductModel> cartData = [];
  Future<void> getCart() async {
    cartData.clear();
    emit(GetCartLoadingState());
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/carts"),
        headers:
        {
          'lang' : 'en',
          'Authorization' : token!
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      for( var item in responseBody['data']['cart_items'] )
      {
        cartsID.add(item['product']['id'].toString());
        cartData.add(ProductModel.fromJson(json: item['product']));
      }
      debugPrint("Cart number is : ${cartData.length}");
      emit(GetCartSuccessState());
    }
    else
    {
      emit(FailedToGetCartState());
    }
  }

  Set<String> cartsID = {};
  void addOrRemoveFromCart({required String productID}) async {
    cartsID.contains(productID) ? cartsID.remove(productID) : cartsID.add(productID);
    emit(GetCartLoadingState());
    Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/carts"),
        headers:
        {
          'Authorization' : token!,
          'lang' : "en"
        },
        body:
        {
          'product_id' : productID
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      await getCart();
      emit(AddOrRemoveFromCartSuccessState());
    }
    else
    {
      emit(FailedToAddOrRemoveFromCartState());
    }
  }

  void addOrRemoveToOrFromFavorites({required String productID}) async {
    favoritesStatus.contains(productID) == true ? favoritesStatus.remove(productID) : favoritesStatus.add(productID);
    emit(GetFavoritesLoadingState());
    Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/favorites"),
        headers:
        {
          'lang' : 'en',
          'Authorization' : token!
        },
        body:
        {
          "product_id": productID
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] == true )
    {
      await getFavorites();
      emit(AddOrRemoveFromFavoritesSuccessState());
    }
    else
    {
      emit(FailedToAddOrRemoveFromFavoritesState());
    }
  }

  int productNum = 1 ;
  void increment(){
    productNum++;
    emit(UpdateProductNumSuccessState());
  }

  void decrement(){
    if( productNum > 1 )
    {
      productNum--;
    }
    emit(UpdateProductNumSuccessState());
  }

  void changePassword({required String newPassword}) async {
    emit(ChangePasswordLoadingState());
    String? currentPassword = await CacheNetwork.getCacheData(key: 'password');
    Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/change-password"),
        body: {
          'current_password' : currentPassword,
          'new_password' : newPassword
        },
        headers: {
          'Authorization' : token!
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] )
    {
      CacheNetwork.insertToCache(key: "password", value: newPassword);
      password = newPassword;
      emit(ChangePasswordSuccessState());
    }
    else
    {
      emit(FailedToChangePasswordState());
    }
  }

  void updateUserData({required String phone,required String name}) async {
    emit(UpdateUserDataLoadingState());
    String? currentPassword = await CacheNetwork.getCacheData(key: 'password');
    Response response = await http.put(
        Uri.parse("https://student.valuxapps.com/api/update-profile"),
        body:
        {
          'name' : name,
          'email' : userModel!.email,
          'password' : currentPassword,
          'phone' : phone,
          'image' : userModel!.image,
        },
        headers:
        {
          'Authorization' : token!
        }
    );
    var responseBody = jsonDecode(response.body);
    if( responseBody['status'] )
    {
      userModel = UserModel.fromJson(responseBody['data']);
      emit(UpdateUserDataSuccessState());
    }
    else
    {
      emit(FailedToUpdateUserDataState());
    }
  }

}