import 'package:fanit_mdtest/domain/entities/user_entity.dart';
import 'package:fanit_mdtest/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;
  UserEntity? _user;
  bool _loading = false;
  String? _error;

  AuthProvider(this.repository);

  UserEntity? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      _user = await repository.signIn(email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      _user = await repository.signUp(name, email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCurrentUser() async {
    _loading = true;
    notifyListeners();
    try {
      _user = await repository.currentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await repository.logout();
    _user = null;
    notifyListeners();
  }
}
