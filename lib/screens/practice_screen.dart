import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/quiz_question.dart';

/// PracticeScreen provides a distraction-free multiple-choice quiz interface
/// for testing Data Structures and Algorithms knowledge.
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  // 10 core DSA practice questions
  static const List<QuizQuestion> _questions = [
    QuizQuestion(
      question: 'Which data structure follows the LIFO principle?',
      options: ['Queue', 'Stack', 'Linked List', 'Tree'],
      correctIndex: 1,
      explanation: 'A Stack follows Last-In, First-Out (LIFO): the last element pushed is the first popped.',
    ),
    QuizQuestion(
      question: 'What is the worst-case time complexity of Bubble Sort?',
      options: ['O(n)', 'O(n log n)', 'O(n²)', 'O(1)'],
      correctIndex: 2,
      explanation: 'Bubble Sort uses two nested loops, resulting in O(n²) comparisons in the worst case.',
    ),
    QuizQuestion(
      question: 'Which data structure follows the FIFO (First-In, First-Out) principle?',
      options: ['Stack', 'Queue', 'Binary Tree', 'Graph'],
      correctIndex: 1,
      explanation: 'A Queue processes elements in the exact order they arrive (FIFO).',
    ),
    QuizQuestion(
      question: 'What is the time complexity of accessing an element by index in an Array?',
      options: ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
      correctIndex: 0,
      explanation: 'Arrays store elements in contiguous memory, allowing instant O(1) index lookup.',
    ),
    QuizQuestion(
      question: 'What does the last node of a singly Linked List point to?',
      options: ['The head node', 'Itself', 'NULL', 'The middle node'],
      correctIndex: 2,
      explanation: 'The tail node of a singly linked list points to NULL to mark the end of the list.',
    ),
    QuizQuestion(
      question: 'Which searching algorithm requires the array to be sorted first?',
      options: ['Linear Search', 'Binary Search', 'Depth-First Search', 'Breadth-First Search'],
      correctIndex: 1,
      explanation: 'Binary Search repeatedly halves the search space, which only works on sorted data.',
    ),
    QuizQuestion(
      question: 'What is the time complexity of Binary Search on a sorted array?',
      options: ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
      correctIndex: 1,
      explanation: 'Cutting the search range in half each step gives O(log n) time complexity.',
    ),
    QuizQuestion(
      question: 'What is the space complexity of Bubble Sort?',
      options: ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
      correctIndex: 0,
      explanation: 'Bubble Sort sorts in-place using only a single temporary variable, so it needs O(1) extra space.',
    ),
    QuizQuestion(
      question: 'In a Binary Tree, what is the maximum number of children a node can have?',
      options: ['1', '2', '3', 'Unlimited'],
      correctIndex: 1,
      explanation: 'Each node in a binary tree has at most two children: a left child and a right child.',
    ),
    QuizQuestion(
      question: 'Which sorting algorithm uses a divide-and-conquer strategy with O(n log n) guaranteed time?',
      options: ['Bubble Sort', 'Insertion Sort', 'Selection Sort', 'Merge Sort'],
      correctIndex: 3,
      explanation: 'Merge Sort splits the array in half recursively and merges sorted halves in O(n log n) time.',
    ),
  ];

  // Ephemeral quiz session state
  int _currentIndex = 0;       // Current question index (0 to 9)
  int? _selectedOptionIndex;   // Currently tapped option (null if none selected)
  bool _hasSubmitted = false;  // True after user taps "Submit Answer"
  bool _isCompleted = false;   // True after finishing all 10 questions
  int _score = 0;              // Total correct answers

  /// Evaluates the selected answer and reveals feedback.
  void _handleSubmit() {
    if (_selectedOptionIndex == null || _hasSubmitted) return;

    final currentQuestion = _questions[_currentIndex];
    setState(() {
      _hasSubmitted = true;
      if (_selectedOptionIndex == currentQuestion.correctIndex) {
        _score++;
      }
    });
  }

  /// Advances to the next question or finishes the quiz on the final question.
  void _handleNext() {
    setState(() {
      if (_currentIndex + 1 < _questions.length) {
        _currentIndex++;
        _selectedOptionIndex = null;
        _hasSubmitted = false;
      } else {
        _isCompleted = true;
      }
    });
  }

  /// Resets the quiz back to Question 1 so the user can practice again.
  void _handleRestart() {
    setState(() {
      _currentIndex = 0;
      _selectedOptionIndex = null;
      _hasSubmitted = false;
      _isCompleted = false;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show the summary view once all questions are completed
    if (_isCompleted) {
      return _buildCompletionView();
    }

    final QuizQuestion currentQuestion = _questions[_currentIndex];
    final double progress = (_currentIndex + 1) / _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Page Title
          const Text(
            'Practice',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),

          // 2. Progress Indicator ("Question X of 10" + Progress Bar)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentIndex + 1} of ${_questions.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
              Text(
                'Score: $_score',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppTheme.softPurple,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryPurple,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 3. Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              currentQuestion.question,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 4. Four Selectable Answer Option Cards
          ...List.generate(
            currentQuestion.options.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildOptionCard(
                index: index,
                text: currentQuestion.options[index],
                correctIndex: currentQuestion.correctIndex,
              ),
            ),
          ),

          // 5. Explanation Banner (appears only after submitting)
          if (_hasSubmitted) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedOptionIndex == currentQuestion.correctIndex
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _selectedOptionIndex == currentQuestion.correctIndex
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _selectedOptionIndex == currentQuestion.correctIndex
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    color: _selectedOptionIndex == currentQuestion.correctIndex
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentQuestion.explanation,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // 6. Primary Action Button ("Submit Answer" -> "Next Question")
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // Disabled until the user picks an option
              onPressed: _selectedOptionIndex == null
                  ? null
                  : (_hasSubmitted ? _handleNext : _handleSubmit),
              child: Text(
                _hasSubmitted
                    ? (_currentIndex + 1 == _questions.length
                        ? 'Finish Quiz'
                        : 'Next Question')
                    : 'Submit Answer',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Renders a single multiple-choice option with clear visual selection
  /// and post-submission correct/incorrect highlighting.
  Widget _buildOptionCard({
    required int index,
    required String text,
    required int correctIndex,
  }) {
    final bool isSelected = _selectedOptionIndex == index;
    final bool isCorrect = index == correctIndex;

    // Determine border and background colors based on quiz state
    Color borderColor = Colors.grey.shade200;
    Color backgroundColor = Colors.white;
    Color circleColor = Colors.grey.shade300;
    IconData? trailingIcon;
    Color? trailingColor;

    if (!_hasSubmitted) {
      // Before submission: highlight the user's chosen option in purple
      if (isSelected) {
        borderColor = AppTheme.primaryPurple;
        backgroundColor = AppTheme.softPurple.withOpacity(0.5);
        circleColor = AppTheme.primaryPurple;
      }
    } else {
      // After submission: reveal green for the right answer, red for a wrong choice
      if (isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.shade50;
        circleColor = Colors.green;
        trailingIcon = Icons.check_circle_rounded;
        trailingColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.shade50;
        circleColor = Colors.red;
        trailingIcon = Icons.cancel_rounded;
        trailingColor = Colors.red;
      }
    }

    // Option letters: A, B, C, D
    final String letter = String.fromCharCode(65 + index);

    return InkWell(
      // Lock selection after the user submits
      onTap: _hasSubmitted
          ? null
          : () {
              setState(() {
                _selectedOptionIndex = index;
              });
            },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: isSelected || (_hasSubmitted && isCorrect) ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Letter badge (A, B, C, D)
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected || (_hasSubmitted && isCorrect)
                    ? circleColor
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected || (_hasSubmitted && isCorrect)
                      ? Colors.white
                      : AppTheme.textDark,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Option text
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textDark,
                ),
              ),
            ),

            // Optional check/cross icon after submission
            if (trailingIcon != null)
              Icon(trailingIcon, color: trailingColor, size: 22),
          ],
        ),
      ),
    );
  }

  /// Displays the final score summary and a button to retake the quiz.
  Widget _buildCompletionView() {
    final int percentage = ((_score / _questions.length) * 100).round();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppTheme.softPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: AppTheme.primaryPurple,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Quiz Completed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You scored $_score out of ${_questions.length} ($percentage%)',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textGrey,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleRestart,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}