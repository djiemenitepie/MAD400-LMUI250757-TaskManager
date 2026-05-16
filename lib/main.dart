import 'package:flutter/material.dart';
import 'models/task.dart';
import 'screens/task_list_screen.dart';
import 'screens/profile_screen.dart';

/// Entry point of the Task Manager application.
/// Student: DJIEMENI TEPIE DENTEP — Matricule: LMUI250757
/// Course: Mobile Application Development — Level 400 Software Engineering
void main() {
  runApp(const TaskManagerApp());
}

/// Root widget of the application.
/// Configures the global theme with a dark color scheme.
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dentep Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF8B5CF6),
          surface: Color(0xFF1E293B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

/// HomeScreen manages the BottomNavigationBar and uses IndexedStack
/// to preserve the state of each tab when switching between them.
/// The task list is stored here and passed down to child screens.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Currently selected tab index for BottomNavigationBar
  int _currentIndex = 0;

  // Master list of tasks — shared with the TaskListScreen
  final List<Task> _tasks = [
    // Sample tasks to demonstrate the app's functionality
    Task(
      title: 'Complete Flutter CA',
      description: 'Build the task manager app for mobile dev course',
      dueDate: DateTime(2026, 5, 16),
      priority: Priority.high,
      category: Category.education,
    ),
    Task(
      title: 'Review Dart Concepts',
      description: 'Study classes, constructors, and list methods in Dart',
      dueDate: DateTime(2026, 5, 17),
      priority: Priority.medium,
      category: Category.education,
    ),
    Task(
      title: 'Morning Workout',
      description: 'Complete 30 minutes of cardio exercise',
      dueDate: DateTime(2026, 5, 14),
      priority: Priority.low,
      category: Category.health,
    ),
    Task(
      title: 'Team Meeting Preparation',
      description: 'Prepare slides and agenda for the project meeting',
      dueDate: DateTime(2026, 5, 18),
      priority: Priority.high,
      category: Category.work,
    ),
    Task(
      title: 'Pay Tuition Fees',
      description: 'Complete the tuition payment for the current semester',
      dueDate: DateTime(2026, 5, 20),
      priority: Priority.high,
      category: Category.finance,
    ),
  ];

  /// Called by child widgets when the task list is modified.
  /// Triggers a rebuild to update the UI across all screens.
  void _onTasksChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps both screens alive to preserve their state
      body: IndexedStack(
        index: _currentIndex,
        children: [
          TaskListScreen(
            tasks: _tasks,
            onTasksChanged: _onTasksChanged,
          ),
          const ProfileScreen(),
        ],
      ),
      // BottomNavigationBar with two tabs: Tasks and Profile
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1E293B),
          selectedItemColor: const Color(0xFF6366F1),
          unselectedItemColor: const Color(0xFF64748B),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt),
              activeIcon: Icon(Icons.task_alt),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
