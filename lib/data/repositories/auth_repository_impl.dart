import 'package:fanit_mdtest/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepositoryImpl(this.auth, this.firestore);

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final cred = await auth.signInWithEmailAndPassword(email: email, password: password);
    final snap = await firestore.collection('users').doc(cred.user!.uid).get();
    return snap.exists ? UserModel.fromMap(snap.data()!, snap.id) : null;
  }

  @override
  Future<UserEntity?> signUp(String name, String email, String password) async {
    final cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
    await cred.user!.updateDisplayName(name);
    await cred.user!.sendEmailVerification();
    final map = {'name': name, 'email': email, 'emailVerified': cred.user!.emailVerified, 'createdAt': FieldValue.serverTimestamp()};
    await firestore.collection('users').doc(cred.user!.uid).set(map);
    return UserModel(id: cred.user!.uid, name: name, email: email, emailVerified: false);
  }

  @override
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<UserEntity?> currentUser() async {
    final user = auth.currentUser;
    if (user == null) return null;
    final snap = await firestore.collection('users').doc(user.uid).get();
    return snap.exists ? UserModel.fromMap(snap.data()!, snap.id) : null;
  }

  @override
  Future<List<UserEntity>> getUsers() async {
    final q = await firestore.collection('users').get();
    return q.docs.map((d) => UserModel.fromMap(d.data(), d.id)).toList();
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }
}
