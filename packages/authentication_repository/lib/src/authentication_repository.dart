import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum _AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final StreamController<_AuthenticationStatus> _controller = StreamController<_AuthenticationStatus>();

  AuthenticationRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _controller.add(_AuthenticationStatus.authenticated);
      } else {
        _controller.add(_AuthenticationStatus.unauthenticated);
      }
    });
  }

  Stream<_AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield _firebaseAuth.currentUser != null
        ? _AuthenticationStatus.authenticated
        : _AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    try {
      // Fetch the document by username
      var querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No user found with this username');
      }

      var userDoc = querySnapshot.docs.first;
      var email = userDoc['email'];
      var storedPassword = userDoc['password'];

      print('Email: $email, Stored Password: $storedPassword, Input Password: $password');

      if (storedPassword != password) {
        throw Exception('Incorrect password');
      }

      // Sign in with email and password
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _controller.add(_AuthenticationStatus.authenticated);
    } catch (e) {
      print('Login error: $e');
      _controller.add(_AuthenticationStatus.unauthenticated);
      rethrow;
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      print("Signing up user with email: $email");
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User signed up with UID: ${userCredential.user!.uid}");
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'password': password,
      });
      _controller.add(_AuthenticationStatus.authenticated);
      print("User data stored in Firestore");
    } catch (e) {
      print("Signup error: $e");
      _controller.add(_AuthenticationStatus.unauthenticated);
      rethrow;
    }
  }

  bool isLoggedIn() {
    var isLoggedIn = _firebaseAuth.currentUser != null;
    print('Current user: ${_firebaseAuth.currentUser}');
    return isLoggedIn;
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    _controller.add(_AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
