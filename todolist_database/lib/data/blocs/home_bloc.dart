import 'dart:async';

import 'package:todolist_database/data/blocs/bloc_provider.dart';

enum NavBarItem { TASK, HISTORY, PROFILE }

class BottomNavBarBloc implements BlocBase {
  final StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.TASK;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.TASK);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.HISTORY);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.PROFILE);
        break;
    }
  }

  @override
  void dispose() {
    _navBarController.close();
  }
}