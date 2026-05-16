import 'package:flutter/material.dart';

/// Profile screen displaying real student information.
/// Contains the student's name, matricule, programme, level, and email.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile avatar with gradient border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withAlpha(100),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF1E293B),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Student name
            const Text(
              'DJIEMENI TEPIE DENTEP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Matricule badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'LMUI250757',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Information cards
            _buildInfoCard(
              icon: Icons.school,
              label: 'Programme',
              value: 'Software Engineering',
              color: const Color(0xFF6366F1),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.bar_chart,
              label: 'Level',
              value: '400',
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.book,
              label: 'Course',
              value: 'Mobile Application Development',
              color: const Color(0xFF06B6D4),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.person_outline,
              label: 'Lecturer',
              value: 'Mr. Atumkeze',
              color: const Color(0xFF10B981),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'dentep.djemeni@university.edu',
              color: const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.calendar_today,
              label: 'Academic Year',
              value: '2025 / 2026',
              color: const Color(0xFFEF4444),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Builds a styled information card with an icon, label, and value.
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha(60),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withAlpha(140),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
