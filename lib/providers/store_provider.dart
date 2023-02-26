// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_pagination/models/store_model.dart';
import 'package:flutter_pagination/services/store_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Storestate { initial, loading, loaded, failed }

class StoreProvider with ChangeNotifier {
  List<StoreModel> storeLists = [];
  // Future<List<StoreModel>> get storeLists => _storeLists;
  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Storestate _state = Storestate.initial;
  Storestate get state => _state;

  final int _totalLimit = 20;
  int _count = 5;
  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  StoreProvider() {
    getStoreLists(isInitialRefresh: true);
  }

  Future<List<StoreModel>> getStoreLists(
      {required bool isInitialRefresh}) async {
    try {
      if (isInitialRefresh) {
        log("initial loading started");
        setState(storestate: Storestate.loading);
        _count = 5;
        storeLists = await StoreServices().getStoresServices(limit: _count);

        _count + 5;
        setState(storestate: Storestate.loaded);
      } else {
        if (_count <= _totalLimit) {
          _isRefreshing = true;
          notifyListeners();
          List<StoreModel> list =
              await StoreServices().getStoresServices(limit: _count);
          storeLists.addAll(list);
          _isRefreshing = false;
          _count + 5;
          notifyListeners();
        } else {
          storeLists = storeLists;
          Fluttertoast.showToast(msg: "No More Data");
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      setState(storestate: Storestate.failed);
      notifyListeners();
    }
    return storeLists;
  }

  setState({required Storestate storestate}) {
    _state = storestate;
    notifyListeners();
  }
}
