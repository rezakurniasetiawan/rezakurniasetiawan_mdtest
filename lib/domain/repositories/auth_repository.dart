import 'package:fanit_mdtest/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signIn(String email, String password);
  Future<UserEntity?> signUp(String name, String email, String password);
  Future<void> resetPassword(String email);
  Future<void> sendEmailVerification();
  Future<UserEntity?> currentUser();
  Future<List<UserEntity>> getUsers();
  Future<void> logout();
}
