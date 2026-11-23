import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// DsVisualizerScreen provides an interactive Linked List visualization.
/// Users can Insert, Delete, Search, and Clear nodes while seeing the
/// pointer connections update in real time.
class DsVisualizerScreen extends StatefulWidget {
  const DsVisualizerScreen({super.key});

  @override
  State<DsVisualizerScreen> createState() => _DsVisualizerScreenState();
}

class _DsVisualizerScreenState extends State<DsVisualizerScreen> {
  // Initial linked list values: 10 -> 20 -> 30
  final List<int> _nodes = [10, 20, 30];

  // Stores the index of a node highlighted by a Search operation (null if none)
  int? _highlightedIndex;

  // Feedback message displayed below the visualization canvas
  String _statusMessage = 'Tap an operation below to modify the Linked List.';

  /// Opens a clean dialog to ask the user for an integer value.
  /// Reused by Insert, Delete, and Search to avoid duplicating dialog code.
  Future<int?> _promptForValue({
    required String title,
    required String hint,
    required String actionLabel,
  }) async {
    final controller = TextEditingController();

    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final parsed = int.tryParse(controller.text.trim());
                Navigator.pop(context, parsed);
              },
              child: Text(actionLabel),
            ),
          ],
        );
      },
    );
  }

  /// Appends a new node to the tail of the Linked List.
  Future<void> _handleInsert() async {
    final value = await _promptForValue(
      title: 'Insert Node',
      hint: 'Enter an integer (e.g. 40)',
      actionLabel: 'Insert',
    );
    if (value == null) return;

    setState(() {
      _nodes.add(value);
      _highlightedIndex = _nodes.length - 1; // Briefly highlight the new node
      _statusMessage = 'Inserted node $value at the tail.';
    });
  }

  /// Deletes the first node matching the entered value (or removes the tail if empty).
  Future<void> _handleDelete() async {
    if (_nodes.isEmpty) {
      setState(() => _statusMessage = 'The list is already empty.');
      return;
    }

    final value = await _promptForValue(
      title: 'Delete Node',
      hint: 'Enter value to delete (e.g. ${_nodes.last})',
      actionLabel: 'Delete',
    );
    if (value == null) return;

    setState(() {
      _highlightedIndex = null;
      final removed = _nodes.remove(value);
      _statusMessage = removed
          ? 'Deleted node $value from the list.'
          : 'Node $value was not found in the list.';
    });
  }

  /// Searches linearly through the Linked List and highlights the found node.
  Future<void> _handleSearch() async {
    if (_nodes.isEmpty) {
      setState(() => _statusMessage = 'Cannot search an empty list.');
      return;
    }

    final value = await _promptForValue(
      title: 'Search Node',
      hint: 'Enter value to find (e.g. 20)',
      actionLabel: 'Search',
    );
    if (value == null) return;

    final index = _nodes.indexOf(value);
    setState(() {
      if (index != -1) {
        _highlightedIndex = index;
        _statusMessage = 'Found $value at position $index (O(n) search).';
      } else {
        _highlightedIndex = null;
        _statusMessage = 'Value $value not found in the list.';
      }
    });
  }

  /// Removes all nodes from the Linked List.
  void _handleClear() {
    setState(() {
      _nodes.clear();
      _highlightedIndex = null;
      _statusMessage = 'Cleared all nodes. Head now points to NULL.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar automatically includes a back button when pushed via Navigator
      appBar: AppBar(
        title: const Text('Data Structures'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Selected Topic Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.softPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Linked List',
                      style: TextStyle(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Length: ${_nodes.length}',
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2. Main Visualization Canvas (Expanded makes it the main focus)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Horizontal scroll lets the list grow without overflowing the screen
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _nodes.isEmpty
                            ? _buildNullBadge()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Build each node followed by an arrow
                                  for (int i = 0; i < _nodes.length; i++) ...[
                                    _buildNodeBox(
                                      value: _nodes[i],
                                      isHead: i == 0,
                                      isHighlighted: i == _highlightedIndex,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6),
                                      child: Icon(
                                        Icons.arrow_forward_rounded,
                                        color: AppTheme.primaryPurple,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                  // Final pointer always ends at NULL
                                  _buildNullBadge(),
                                ],
                              ),
                      ),
                      const SizedBox(height: 24),
                      // Live status text explaining the last action
                      Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 3. Operation Buttons (Insert, Delete, Search, Clear)
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'Insert',
                      icon: Icons.add_rounded,
                      onPressed: _handleInsert,
                      isPrimary: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionButton(
                      label: 'Delete',
                      icon: Icons.remove_rounded,
                      onPressed: _handleDelete,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'Search',
                      icon: Icons.search_rounded,
                      onPressed: _handleSearch,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionButton(
                      label: 'Clear',
                      icon: Icons.delete_outline_rounded,
                      onPressed: _handleClear,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 4. Explanation Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.softPurple.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.primaryPurple,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'A linked list is a linear data structure where each node points to the next node.',
                        style: TextStyle(
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
          ),
        ),
      ),
    );
  }

  /// Renders a single visual node with its integer value and an optional "HEAD" label.
  Widget _buildNodeBox({
    required int value,
    required bool isHead,
    required bool isHighlighted,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label above the first node so students see where traversal starts
        SizedBox(
          height: 18,
          child: isHead
              ? const Text(
                  'HEAD',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                )
              : null,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 68,
          height: 68,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isHighlighted ? AppTheme.primaryPurple : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.primaryPurple,
              width: 2,
            ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: AppTheme.primaryPurple.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.white : AppTheme.textDark,
            ),
          ),
        ),
      ],
    );
  }

  /// Renders the NULL terminator at the end of the Linked List.
  Widget _buildNullBadge() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text(
          'NULL',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.textGrey,
          ),
        ),
      ),
    );
  }

  /// Helper for consistent operation buttons.
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: AppTheme.primaryPurple),
      label: Text(
        label,
        style: const TextStyle(color: AppTheme.textDark),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}