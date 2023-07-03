import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';


abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {

  Future<bool> connectionChecker() async {
    if(kIsWeb){
      return checkerWeb();
    }
    return mobileChecker();
  }

  Future<bool> mobileChecker() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<bool> checkerWeb() async {
    try {
      final result = await Dio().get('www.google.com');
      if(result.statusCode == 200) return true;
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Future<bool> get isConnected => connectionChecker();
}