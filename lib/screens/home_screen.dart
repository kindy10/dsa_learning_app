import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// HomeScreen is the main dashboard of the DSA Learning App.
/// It is a StatelessWidget for now because its data is static; later,
/// we can connect it to a progress provider to show live user stats.
class HomeScreen extends StatelessWidget {
  /// Callback function passed from MainShell to switch to the "Learn" tab
  /// when the user taps on Data Structures, Algorithms, or Continue Learning.
  final VoidCallback onNavigateToLearn;

  const HomeScreen({
    super.key,
    required this.onNavigateToLearn,
  });

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView prevents overflow errors on smaller screens
    // by allowing the entire dashboard to scroll vertically.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        // Aligns all child widgets to the left edge
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top App Header ("DSA Learning")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.code_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'DSA Learning',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              // Subtle profile/notification placeholder icon
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.softPurple,
                child: const Icon(
                  Icons.person,
                  color: AppTheme.primaryPurple,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 2. Welcome Message & Subtitle
          const Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Continue your learning journey.',
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.textGrey,
            ),
          ),

          const SizedBox(height: 24),

          // 3. Overall Learning Progress Card (35%)
          _buildProgressCard(),

          const SizedBox(height: 24),

          // 4. Main Category Cards Section
          const Text(
            'Explore Topics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),

          // Row places the two category cards side by side
          Row(
            children: [
              // Expanded ensures both cards share equal horizontal width
              Expanded(
                child: _buildCategoryCard(
                  title: 'Data Structures',
                  subtitle: 'Lists, Stacks, Trees',
                  icon: Icons.account_tree_outlined,
                  onTap: onNavigateToLearn,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildCategoryCard(
                  title: 'Algorithms',
                  subtitle: 'Sorting & Searching',
                  icon: Icons.bar_chart_rounded,
                  onTap: onNavigateToLearn,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 5. "Continue Learning" Section
          const Text(
            'Continue Learning',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          _buildContinueLearningCard(),
        ],
      ),
    );
  }

  /// Helper method that builds the purple overall progress card.
  /// Breaking UI sections into private helper methods keeps build() clean and readable.
  Widget _buildProgressCard() {
    const double progressValue = 0.35; // 35% overall progress

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '35%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // ClipRRect rounds the corners of the LinearProgressIndicator
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: progressValue,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '7 of 20 lessons completed',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method for the Data Structures and Algorithms category cards.
  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    // InkWell adds a Material ripple effect when the card is tapped
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.softPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryPurple,
                  size: 26,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
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

  /// Helper method for the "Continue Learning" card showing the active lesson.
  Widget _buildContinueLearningCard() {
    return InkWell(
      onTap: onNavigateToLearn,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Lesson icon badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.softPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.link_rounded,
                  color: AppTheme.primaryPurple,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              // Expanded lets the text take up remaining space without overflowing
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Linked List Basics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Data Structures • 60% completed',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              // Forward arrow indicator
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppTheme.primaryPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}