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
    required String type
  }) async {
    await _db
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .add({
      'question': question,
      'choices': choices,
      'correctAnswer': correctAnswer,
      'type': type
    });
  }
  Future<void> updateQuizTitle(String quizId, String newTitle) async {
  await FirebaseFirestore.instance
      .collection('quizzes')
      .doc(quizId)
      .update({'title': newTitle});
}

Future<void> deleteQuiz(String quizId) async {
  final quizRef = FirebaseFirestore.instance.collection('quizzes').doc(quizId);

  // Delete questions subcollection
  final questionsSnapshot = await quizRef.collection('questions').get();
  for (final doc in questionsSnapshot.docs) {
    await doc.reference.delete();
  }

  // Delete the quiz document
  await quizRef.delete();
}

  Future<void> deleteQuestion(String quizId, String questionId) async {
    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .doc(questionId)
        .delete();
  }
}
