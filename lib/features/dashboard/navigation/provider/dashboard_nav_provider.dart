import 'package:flutter/cupertino.dart';

class DashboardNavigationProvider extends ChangeNotifier {
  int currentPageIndex = 0;

  void changePageIndex(int page) {
    assert(page >= 0 && page <= 2);
    currentPageIndex = page;
    notifyListeners();
  }
}
