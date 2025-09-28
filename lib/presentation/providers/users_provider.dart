import 'package:fanit_mdtest/domain/entities/user_entity.dart';
import 'package:fanit_mdtest/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class UsersProvider extends ChangeNotifier {
  final AuthRepository repository;
  List<UserEntity> _users = [];
  String _filter = "all";
  String _search = "";

  UsersProvider(this.repository);

  List<UserEntity> get users {
    var list = _users;
    if (_filter != "all") {
      final verified = _filter == "verified";
      list = list.where((u) => u.emailVerified == verified).toList();
    }
    if (_search.isNotEmpty) {
      list = list.where((u) => u.name.toLowerCase().contains(_search.toLowerCase()) || u.email.toLowerCase().contains(_search.toLowerCase())).toList();
    }
    return list;
  }

  String get filter => _filter;

  Future<void> loadUsers() async {
    _users = await repository.getUsers();
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSearch(String search) {
    _search = search;
    notifyListeners();
  }
}
