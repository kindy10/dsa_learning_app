import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'ds_visualizer_screen.dart';
import 'algo_visualizer_screen.dart' ;

/// Simple immutable model representing a single topic card on the Learn screen.
class _ModuleItem {
  final String title;
  final IconData icon;

  const _ModuleItem({
    required this.title,
    required this.icon,
  });
}

/// ModulesScreen displays Data Structures and Algorithms in a clean,
/// centered 2-column card layout matching the app's visual identity.
class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  // Topics shown under the "Data Structures" section
  static const List<_ModuleItem> _dataStructures = [
    _ModuleItem(
      title: 'Arrays',
      icon: Icons.view_column_outlined,
    ),
    _ModuleItem(
      title: 'Linked List',
      icon: Icons.schema_outlined,
    ),
    _ModuleItem(
      title: 'Stacks',
      icon: Icons.layers_outlined,
    ),
    _ModuleItem(
      title: 'Trees',
      icon: Icons.account_tree_rounded,
    ),
  ];

  // Topics shown under the "Algorithms" section
  static const List<_ModuleItem> _algorithms = [
    _ModuleItem(
      title: 'Sorting',
      icon: Icons.swap_vert_rounded,
    ),
    _ModuleItem(
      title: 'Searching',
      icon: Icons.search_rounded,
    ),
    _ModuleItem(
      title: 'Graph Algorithms',
      icon: Icons.hub_outlined,
    ),
    _ModuleItem(
      title: 'Dynamic\nProgramming',
      icon: Icons.mediation_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Bold Purple Page Title
          const Text(
            'Learning Modules',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryPurple,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),

          // 2. Subtitle
          const Text(
            'Choose what you want to learn.',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textDark,
            ),
          ),

          const SizedBox(height: 24),

          // 3. Data Structures Section
          const Text(
            'Data Structures',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 14),
          _buildModuleGrid(context, _dataStructures),

          const SizedBox(height: 28),

          // 4. Algorithms Section
          const Text(
            'Algorithms',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 14),
          _buildModuleGrid(context, _algorithms),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Builds a 2-column grid of centered topic cards.
  /// shrinkWrap + NeverScrollableScrollPhysics lets the parent
  /// SingleChildScrollView control scrolling cleanly.
  Widget _buildModuleGrid(BuildContext context, List<_ModuleItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.15, // Balanced rectangular card proportions
      ),
      itemBuilder: (context, index) {
        return _buildModuleCard(context, items[index]);
      },
    );
  }

  /// Renders a minimalist white card with a soft shadow, centered purple
  /// icon container, and centered topic label.
  Widget _buildModuleCard(BuildContext context, _ModuleItem item) {
    // Normalize title for comparison (removes line breaks like in Dynamic\nProgramming)
    final String cleanTitle = item.title.replaceAll('\n', ' ');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Soft, subtle drop shadow instead of a hard border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Open the interactive Linked List visualizer when Linked List is tapped
            if (cleanTitle == 'Linked List') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DsVisualizerScreen(),
                ),
              );
              return;
            }
            // Open the interactive Bubble Sort visualizer when Sorting is tapped
            if (cleanTitle == 'Sorting') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AlgoVisualizerScreen(),
                ),
              );
              return;
            }
            // Temporary feedback for topics not yet implemented
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$cleanTitle coming soon!'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Soft purple rounded icon badge
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppTheme.softPurple,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    item.icon,
                    color: AppTheme.primaryPurple,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),

                // Centered topic label
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                    height: 1.2,
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