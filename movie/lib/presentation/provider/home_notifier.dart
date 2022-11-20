

import 'package:flutter/cupertino.dart';


class HomeNotifier extends ChangeNotifier{
  DrawerItem _selectedDrawerItem = DrawerItem.Movie;
  DrawerItem get selectedDrawerItem => _selectedDrawerItem;

  void setSelectedDrawerItem(DrawerItem newItem) {
    this._selectedDrawerItem = newItem;
    notifyListeners();
  }
}