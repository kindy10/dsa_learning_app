import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/algorithm_step.dart';

/// AlgoVisualizerScreen visually demonstrates how Bubble Sort works
/// using vertical bars, comparison highlights, and playback controls.
class AlgoVisualizerScreen extends StatefulWidget {
  const AlgoVisualizerScreen({super.key});

  @override
  State<AlgoVisualizerScreen> createState() => _AlgoVisualizerScreenState();
}

class _AlgoVisualizerScreenState extends State<AlgoVisualizerScreen> {
  // Initial unsorted array to visualize
  static const List<int> _initialArray = [64, 34, 25, 12, 22, 11, 90];

  // Precomputed list of every step in the Bubble Sort execution
  late final List<AlgorithmStep> _steps;

  // Tracks which snapshot is currently displayed
  int _currentStepIndex = 0;

  // Timer drives automatic playback when the user presses Play
  Timer? _timer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Generate all Bubble Sort snapshots once when the screen opens
    _steps = _generateBubbleSortSteps(_initialArray);
  }

  @override
  void dispose() {
    // Always cancel timers in dispose() to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }

  /// Runs Bubble Sort on a copy of the array and records an immutable
  /// AlgorithmStep snapshot for every comparison and swap.
  List<AlgorithmStep> _generateBubbleSortSteps(List<int> input) {
    final List<int> arr = List<int>.from(input);
    final List<AlgorithmStep> steps = [];
    final Set<int> sorted = {};
    final int n = arr.length;

    // Step 0: Initial unsorted state
    steps.add(
      AlgorithmStep(
        values: List<int>.from(arr),
        explanation: 'Press Play to start Bubble Sort.',
      ),
    );

    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        // Record the comparison step
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            comparingIndices: {j, j + 1},
            sortedIndices: Set<int>.from(sorted),
            explanation: 'Comparing ${arr[j]} and ${arr[j + 1]}...',
          ),
        );

        // Swap if the left element is greater than the right element
        if (arr[j] > arr[j + 1]) {
          final int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;

          // Record the post-swap step
          steps.add(
            AlgorithmStep(
              values: List<int>.from(arr),
              comparingIndices: {j, j + 1},
              sortedIndices: Set<int>.from(sorted),
              explanation: 'Swapped ${arr[j + 1]} and ${arr[j]}.',
            ),
          );
        }
      }
      // After each full pass, the largest unsorted element is in its final spot
      sorted.add(n - i - 1);
    }

    // Mark the very first element as sorted too
    sorted.add(0);

    // Final sorted state
    steps.add(
      AlgorithmStep(
        values: List<int>.from(arr),
        sortedIndices: Set<int>.from(sorted),
        explanation: 'Array is completely sorted!',
      ),
    );

    return steps;
  }

  /// Starts stepping through the precomputed snapshots automatically.
  void _handlePlay() {
    if (_isPlaying) return;

    // If already at the end, restart from step 0
    if (_currentStepIndex >= _steps.length - 1) {
      setState(() => _currentStepIndex = 0);
    }

    setState(() => _isPlaying = true);

    _timer = Timer.periodic(const Duration(milliseconds: 550), (timer) {
      if (_currentStepIndex < _steps.length - 1) {
        setState(() => _currentStepIndex++);
      } else {
        // Stop automatically once sorting finishes
        _handlePause();
      }
    });
  }

  /// Pauses the playback timer while keeping the current step visible.
  void _handlePause() {
    _timer?.cancel();
    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  /// Stops playback and resets the bars back to the initial unsorted array.
  void _handleReset() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentStepIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AlgorithmStep currentStep = _steps[_currentStepIndex];
    final int maxValue = _initialArray.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Algorithm Visualization'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Selected Algorithm Pill & Step Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.softPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Bubble Sort',
                      style: TextStyle(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    'Step $_currentStepIndex / ${_steps.length - 1}',
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2. Vertical Bar Visualization Canvas
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      // Bars aligned to the bottom like a classic sorting chart
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            currentStep.values.length,
                            (index) => _buildBar(
                              value: currentStep.values[index],
                              maxValue: maxValue,
                              isComparing:
                                  currentStep.comparingIndices.contains(index),
                              isSorted:
                                  currentStep.sortedIndices.contains(index),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Live explanation of the current comparison/swap
                      Text(
                        currentStep.explanation,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 3. Playback Controls: Play, Pause, Reset
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isPlaying ? null : _handlePlay,
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      label: const Text('Play'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isPlaying ? _handlePause : null,
                      icon: const Icon(Icons.pause_rounded, size: 20),
                      label: const Text('Pause'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _handleReset,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 20,
                        color: AppTheme.primaryPurple,
                      ),
                      label: const Text(
                        'Reset',
                        style: TextStyle(color: AppTheme.textDark),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 4. Complexity Information Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.softPurple.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ComplexityItem(
                      label: 'Time Complexity',
                      value: 'O(n²)',
                    ),
                    SizedBox(
                      height: 32,
                      child: VerticalDivider(color: Colors.black12),
                    ),
                    _ComplexityItem(
                      label: 'Space Complexity',
                      value: 'O(1)',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Renders a single animated vertical bar scaled proportionally to maxValue.
  Widget _buildBar({
    required int value,
    required int maxValue,
    required bool isComparing,
    required bool isSorted,
  }) {
    // Choose bar color based on its current role in the algorithm
    Color barColor = AppTheme.softPurple;
    if (isComparing) {
      barColor = Colors.orangeAccent; // Highlight active comparison
    } else if (isSorted) {
      barColor = AppTheme.primaryPurple; // Final sorted position
    }

    // Scale height cleanly between 30px and 180px
    final double barHeight = (value / maxValue) * 180;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isComparing ? Colors.orange.shade800 : AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 32,
          height: barHeight,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

/// Small helper widget for displaying Time and Space Complexity neatly.
class _ComplexityItem extends StatelessWidget {
  final String label;
  final String value;

  const _ComplexityItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
      ],
    );
  }
}