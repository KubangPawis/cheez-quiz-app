import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createQuiz(String title, String userId) async {
    final doc = await _db.collection('quizzes').add({
      'title': title,
      'createdBy': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> addQuestion({
    required String quizId,
    required String question,
    required Map<String, String> choices,
    required String correctAnswer,
  }) async {
    await _db
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .add({
      'question': question,
      'choices': choices,
      'correctAnswer': correctAnswer,
    });
  }
}
