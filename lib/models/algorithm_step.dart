/// Represents a single immutable snapshot of a sorting algorithm's execution.
/// Storing precomputed snapshots makes Play, Pause, and Reset completely
/// predictable and bug-free without mutating lists mid-animation.
class AlgorithmStep {
  /// The array values at this exact step.
  final List<int> values;

  /// Indices of the two bars currently being compared (highlighted in purple/accent).
  final Set<int> comparingIndices;

  /// Indices of bars that are already in their final sorted positions.
  final Set<int> sortedIndices;

  /// Short human-readable explanation of what is happening in this step.
  final String explanation;

  const AlgorithmStep({
    required this.values,
    this.comparingIndices = const {},
    this.sortedIndices = const {},
    required this.explanation,
  });
}