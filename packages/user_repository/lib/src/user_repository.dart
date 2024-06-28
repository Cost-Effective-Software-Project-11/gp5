import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger();

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User?> getUser(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        return User.fromMap(doc.data()!);
      } else {
        _logger.w('User with id $id does not exist.');
      }
    } on FirebaseException catch (e) {
      _logger.e('FirebaseException: ${e.message}');
    } catch (e) {
      _logger.e('Exception: $e');
    }
    return null;
  }
}