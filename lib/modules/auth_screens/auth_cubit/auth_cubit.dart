import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/shared/constants/constants.dart';
import 'package:ecommerce_app/shared/network/local_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit() : super(AuthInitialState());

  // Todo: API URL => https://student.valuxapps.com/api/
  // Todo: Register endpoint => register
  void register({required String email,required String name,
    required String phone,required String password}) async {
    emit(RegisterLoadingState());
    try{
      Response response = await http.post(
        Uri.parse('https://student.valuxapps.com/api/register'),
        body: {
          'name' : name,
          'email' : email,
          'password' : password,
          'phone' : phone,
          'image' : "jdfjfj"
        },
      );
      if( response.statusCode == 200 )
      {
        var data = jsonDecode(response.body);
        if( data['status'] == true )
        {
          await CacheNetwork.insertToCache(key: "password", value: password);
          debugPrint("Response is : $data");
          emit(RegisterSuccessState());
        }
        else
        {
          debugPrint("Response is : $data");
          emit(FailedToRegisterState(message: data['message']));
        }
      }
    }
    catch(e){
      debugPrint("Failed to Register , reason : $e");
      emit(FailedToRegisterState(message: e.toString()));
    }
  }
  void login({required String email,required String password}) async {
    emit(LoginLoadingState());
    try{
      Response response = await http.post(
        Uri.parse('https://student.valuxapps.com/api/login'),
        body: {
          'email' : email,
          'password' : password
        },
      );
      if( response.statusCode == 200 )
      {
        var responseData = jsonDecode(response.body);
        if( responseData['status'] == true )
        {
           await CacheNetwork.insertToCache(key: "token", value: responseData['data']['token']);
           token = await CacheNetwork.getCacheData(key: 'token');
           await CacheNetwork.insertToCache(key: "password", value: password);
          emit(LoginSuccessState());
        }
        else
        {
          debugPrint("Failed to login, reason is : ${responseData['message']}");
          emit(FailedToLoginState(message: responseData['message']));
        }
      }
    }
    catch(e){
      emit(FailedToLoginState(message: e.toString()));
    }
  }
}