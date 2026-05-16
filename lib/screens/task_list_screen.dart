import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_form.dart';

/// The main task list screen displaying all tasks with statistics,
/// sorting, searching, and CRUD operations.
/// Uses StatefulWidget with setState for state management.
class TaskListScreen extends StatefulWidget {
  /// The master list of tasks shared from the parent widget.
  final List<Task> tasks;

  /// Callback to notify parent when the task list changes.
  final VoidCallback onTasksChanged;

  const TaskListScreen({
    super.key,
    required this.tasks,
    required this.onTasksChanged,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Current sort mode: 'date' or 'priority'
  String _sortMode = 'date';

  // Search query for filtering tasks by title
  String _searchQuery = '';

  // Whether the search bar is visible
  bool _isSearching = false;

  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns a filtered and sorted copy of the task list.
  /// First filters by search query using List.where(),
  /// then sorts using List.sort() with compareTo().
  List<Task> get _filteredTasks {
    // Filter tasks by title matching the search query
    List<Task> filtered = widget.tasks.where((task) {
      return task.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Sort based on the selected sort mode
    if (_sortMode == 'date') {
      // Sort by due date — earliest first using compareTo
      filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (_sortMode == 'priority') {
      // Sort by priority — High(0) > Medium(1) > Low(2)
      filtered.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    }

    return filtered;
  }

  /// Opens a modal bottom sheet to add a new task.
  /// Uses showModalBottomSheet with the TaskForm widget.
  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TaskForm(
          onSave: (task) {
            setState(() {
              widget.tasks.add(task);
            });
            widget.onTasksChanged();
          },
        );
      },
    );
  }

  /// Opens a modal bottom sheet to edit an existing task.
  /// Pre-fills the form with the current task data.
  void _showEditTaskSheet(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TaskForm(
          existingTask: task,
          onSave: (updatedTask) {
            setState(() {
              final index = widget.tasks.indexWhere((t) => t.id == task.id);
              if (index != -1) {
                widget.tasks[index] = updatedTask;
              }
            });
            widget.onTasksChanged();
          },
        );
      },
    );
  }

  /// Deletes a task after showing a confirmation dialog.
  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Task',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${task.title}"?',
            style: TextStyle(color: Colors.white.withAlpha(180)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.tasks.removeWhere((t) => t.id == task.id);
                });
                widget.onTasksChanged();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirmation dialog, then deletes all tasks.
  void _clearAllTasks() {
    if (widget.tasks.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Clear All Tasks',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete all ${widget.tasks.length} tasks? This action cannot be undone.',
            style: TextStyle(color: Colors.white.withAlpha(180)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.tasks.clear();
                });
                widget.onTasksChanged();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete All',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Toggles the completed status of a task.
  void _toggleComplete(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    widget.onTasksChanged();
  }

  /// Returns the color for each priority level.
  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return const Color(0xFFEF4444);
      case Priority.medium:
        return const Color(0xFFF59E0B);
      case Priority.low:
        return const Color(0xFF10B981);
    }
  }

  /// Returns the icon for each category.
  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.work:
        return Icons.work;
      case Category.personal:
        return Icons.person;
      case Category.health:
        return Icons.favorite;
      case Category.education:
        return Icons.school;
      case Category.finance:
        return Icons.account_balance_wallet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _filteredTasks;
    // Calculate statistics
    final totalTasks = widget.tasks.length;
    final completedTasks = widget.tasks.where((t) => t.isCompleted).length;
    final pendingTasks = totalTasks - completedTasks;
    final completionPercent = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search tasks by title...',
                  hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text(
                'My Tasks',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        centerTitle: !_isSearching,
        actions: [
          // Search icon to filter tasks by title as you type
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            tooltip: _isSearching ? 'Close Search' : 'Search Tasks',
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          // Sort menu in the AppBar
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            tooltip: 'Sort Tasks',
            color: const Color(0xFF1E293B),
            onSelected: (value) {
              setState(() {
                _sortMode = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: _sortMode == 'date'
                          ? const Color(0xFF6366F1)
                          : Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Due Date',
                      style: TextStyle(
                        color: _sortMode == 'date'
                            ? const Color(0xFF6366F1)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'priority',
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      size: 18,
                      color: _sortMode == 'priority'
                          ? const Color(0xFF6366F1)
                          : Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Priority',
                      style: TextStyle(
                        color: _sortMode == 'priority'
                            ? const Color(0xFF6366F1)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Clear all tasks icon
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            tooltip: 'Clear All Tasks',
            onPressed: _clearAllTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics bar
          _buildStatisticsBar(
            totalTasks,
            completedTasks,
            pendingTasks,
            completionPercent,
          ),
          // Task list
          Expanded(
            child: tasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(tasks[index]);
                    },
                  ),
          ),
        ],
      ),
      // Floating action button to add new tasks
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Builds the statistics bar showing task counts and a LinearProgressIndicator.
  Widget _buildStatisticsBar(
    int total,
    int completed,
    int pending,
    double percent,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total', total, const Color(0xFF6366F1)),
              _buildStatItem('Done', completed, const Color(0xFF10B981)),
              _buildStatItem('Pending', pending, const Color(0xFFF59E0B)),
            ],
          ),
          const SizedBox(height: 12),
          // LinearProgressIndicator showing completion percentage
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: const Color(0xFF0F172A),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF6366F1),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(percent * 100).toStringAsFixed(0)}% Complete',
            style: TextStyle(
              color: Colors.white.withAlpha(160),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single stat item (label + count) for the statistics bar.
  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withAlpha(140),
          ),
        ),
      ],
    );
  }

  /// Builds the empty state view when there are no tasks.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.white.withAlpha(60),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No tasks match your search'
                : 'No tasks yet',
            style: TextStyle(
              color: Colors.white.withAlpha(120),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try a different search term'
                : 'Tap + to add your first task',
            style: TextStyle(
              color: Colors.white.withAlpha(80),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single task card with priority color, category icon,
  /// completion toggle, edit and delete actions.
  /// Overdue tasks are highlighted with a red border.
  Widget _buildTaskCard(Task task) {
    final priorityColor = _getPriorityColor(task.priority);
    final categoryIcon = _getCategoryIcon(task.category);
    final isOverdue = task.isOverdue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        // Overdue tasks get a red border highlight
        border: Border.all(
          color: isOverdue
              ? const Color(0xFFEF4444)
              : Colors.transparent,
          width: isOverdue ? 2 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: isOverdue
                ? const Color(0xFFEF4444).withAlpha(30)
                : Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Completion checkbox
                GestureDetector(
                  onTap: () => _toggleComplete(task),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? const Color(0xFF10B981)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: task.isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFF475569),
                        width: 2,
                      ),
                    ),
                    child: task.isCompleted
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                // Task title
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: Colors.white.withAlpha(100),
                    ),
                  ),
                ),
                // Priority badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.priorityLabel,
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Description
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                task.description,
                style: TextStyle(
                  color: Colors.white.withAlpha(130),
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            // Bottom row: category, date, and action buttons
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                children: [
                  // Category chip
                  Icon(categoryIcon, color: const Color(0xFF6366F1), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    task.categoryLabel,
                    style: TextStyle(
                      color: Colors.white.withAlpha(120),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Due date
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: isOverdue
                        ? const Color(0xFFEF4444)
                        : Colors.white.withAlpha(100),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                    style: TextStyle(
                      color: isOverdue
                          ? const Color(0xFFEF4444)
                          : Colors.white.withAlpha(120),
                      fontSize: 12,
                      fontWeight:
                          isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isOverdue) ...[
                    const SizedBox(width: 4),
                    const Text(
                      'OVERDUE',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Edit button
                  InkWell(
                    onTap: () => _showEditTaskSheet(task),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Color(0xFF6366F1),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Delete button
                  InkWell(
                    onTap: () => _deleteTask(task),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        color: Color(0xFFEF4444),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
