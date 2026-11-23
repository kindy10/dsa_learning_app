import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Simple immutable data class representing a single learning topic card.
/// Defining a small model keeps our UI code clean and avoids repeating card layouts.
class _ModuleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String tag; // e.g., "Interactive" or "Coming Soon"

  const _ModuleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tag,
  });
}

/// ModulesScreen displays all available Data Structures and Algorithms
/// organized into two clear sections.
class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  // List of Data Structures topics shown in the first section
  static const List<_ModuleItem> _dataStructures = [
    _ModuleItem(
      title: 'Linked List',
      subtitle: 'Nodes & pointers',
      icon: Icons.link_rounded,
      tag: 'Interactive',
    ),
    _ModuleItem(
      title: 'Stack',
      subtitle: 'LIFO principle',
      icon: Icons.layers_outlined,
      tag: 'Lesson',
    ),
    _ModuleItem(
      title: 'Queue',
      subtitle: 'FIFO principle',
      icon: Icons.linear_scale_rounded,
      tag: 'Lesson',
    ),
    _ModuleItem(
      title: 'Binary Tree',
      subtitle: 'Hierarchical nodes',
      icon: Icons.account_tree_outlined,
      tag: 'Lesson',
    ),
  ];

  // List of Algorithms topics shown in the second section
  static const List<_ModuleItem> _algorithms = [
    _ModuleItem(
      title: 'Bubble Sort',
      subtitle: 'O(n²) comparison sort',
      icon: Icons.bar_chart_rounded,
      tag: 'Interactive',
    ),
    _ModuleItem(
      title: 'Binary Search',
      subtitle: 'O(log n) divide & conquer',
      icon: Icons.search_rounded,
      tag: 'Lesson',
    ),
    _ModuleItem(
      title: 'Merge Sort',
      subtitle: 'O(n log n) recursive sort',
      icon: Icons.call_merge_rounded,
      tag: 'Lesson',
    ),
    _ModuleItem(
      title: 'Quick Sort',
      subtitle: 'Pivot partitioning',
      icon: Icons.bolt_rounded,
      tag: 'Lesson',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Page Title & Short Description
          const Text(
            'Learning Modules',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose what you want to learn.',
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.textGrey,
            ),
          ),

          const SizedBox(height: 24),

          // 2. Data Structures Section
          _buildSectionHeader(
            title: 'Data Structures',
            count: '${_dataStructures.length} topics',
          ),
          const SizedBox(height: 12),
          _buildModuleGrid(context, _dataStructures),

          const SizedBox(height: 28),

          // 3. Algorithms Section
          _buildSectionHeader(
            title: 'Algorithms',
            count: '${_algorithms.length} topics',
          ),
          const SizedBox(height: 12),
          _buildModuleGrid(context, _algorithms),
        ],
      ),
    );
  }

  /// Renders a section title on the left and a subtle topic count badge on the right.
  Widget _buildSectionHeader({
    required String title,
    required String count,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        Text(
          count,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryPurple,
          ),
        ),
      ],
    );
  }

  /// Builds a 2-column grid of module cards.
  /// shrinkWrap + NeverScrollableScrollPhysics lets the outer SingleChildScrollView
  /// handle all scrolling smoothly without nested scroll conflicts.
  Widget _buildModuleGrid(BuildContext context, List<_ModuleItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,          // 2 cards per row
        crossAxisSpacing: 14,       // Horizontal gap between cards
        mainAxisSpacing: 14,        // Vertical gap between rows
        childAspectRatio: 1.05,     // Keeps cards balanced and roomy
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildModuleCard(context, item);
      },
    );
  }

  /// Builds an individual topic card with an icon, title, subtitle, and tag.
  Widget _buildModuleCard(BuildContext context, _ModuleItem item) {
    final bool isInteractive = item.tag == 'Interactive';

    return InkWell(
      onTap: () {
        // Temporary feedback until we build Screen 3 & Screen 4
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} selected!'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Icon badge + Interactive/Lesson pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.softPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.icon,
                      color: AppTheme.primaryPurple,
                      size: 22,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isInteractive
                          ? AppTheme.primaryPurple.withOpacity(0.12)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.tag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isInteractive
                            ? AppTheme.primaryPurple
                            : AppTheme.textGrey,
                      ),
                    ),
                  ),
                ],
              ),

              // Spacer pushes the text neatly toward the bottom of the card
              const Spacer(),

              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}