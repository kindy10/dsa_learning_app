/// Represents a single multiple-choice DSA quiz question.
/// Keeping the model immutable ensures quiz data cannot be accidentally
/// modified while the user is taking a test.
class QuizQuestion {
  /// The question text displayed to the student.
  final String question;

  /// List of 4 possible answer choices.
  final List<String> options;

  /// Index (0–3) of the correct option in [options].
  final int correctIndex;

  /// Short explanation shown after the user submits their answer.
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}