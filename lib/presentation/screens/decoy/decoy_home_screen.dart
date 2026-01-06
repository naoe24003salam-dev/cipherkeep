import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cypherkeep/data/models/todo_item.dart';
import 'package:cypherkeep/logic/providers/auth_provider.dart';
import 'package:cypherkeep/logic/providers/decoy_provider.dart';

import 'decoy_todo_screen.dart';

class DecoyHomeScreen extends ConsumerStatefulWidget {
  const DecoyHomeScreen({super.key});

  @override
  ConsumerState<DecoyHomeScreen> createState() => _DecoyHomeScreenState();
}

class _DecoyHomeScreenState extends ConsumerState<DecoyHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openTodoForm({TodoItem? todo}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DecoyTodoScreen(existingTodo: todo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(decoyProvider);
    final activeTodos = todos.where((t) => !t.isCompleted).toList();
    final completedTodos = todos.where((t) => t.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'filter_all') {
                // Show all tasks
              } else if (value == 'filter_active') {
                _tabController.animateTo(0);
              } else if (value == 'filter_completed') {
                _tabController.animateTo(1);
              } else if (value == 'secret_vault') {
                // Secret access to vault
                ref.read(authProvider.notifier).logout();
                context.go('/pin');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'filter_all',
                child: Row(
                  children: [
                    Icon(Icons.list),
                    SizedBox(width: 8),
                    Text('View All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'filter_active',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline),
                    SizedBox(width: 8),
                    Text('Active Only'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'filter_completed',
                child: Row(
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 8),
                    Text('Completed Only'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'secret_vault',
                child: Row(
                  children: [
                    Icon(Icons.vpn_key),
                    SizedBox(width: 8),
                    Text('Access Vault'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Active (${activeTodos.length})',
              icon: const Icon(Icons.check_circle_outline),
            ),
            Tab(
              text: 'Completed (${completedTodos.length})',
              icon: const Icon(Icons.check_circle),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today overview',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${activeTodos.length} tasks pending · ${completedTodos.length} done',
                        style: TextStyle(color: Colors.blueGrey.shade700),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text('${todos.length} total'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTodoList(activeTodos, false),
                _buildTodoList(completedTodos, true),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTodoForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoList(List<TodoItem> todos, bool isCompleted) {
    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.task_alt,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isCompleted ? 'No completed tasks' : 'No active tasks',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (value) {
                if (value != null) {
                  ref.read(decoyProvider.notifier).toggleTodo(todo.id);
                }
              },
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration:
                    todo.isCompleted ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todo.description.trim().isNotEmpty)
                  Text(
                    todo.description,
                    style: TextStyle(
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (todo.dueDate != null)
                      Chip(
                        label: Text(
                          '${todo.dueDate!.month}/${todo.dueDate!.day}/${todo.dueDate!.year}',
                          style: TextStyle(
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        avatar: const Icon(Icons.calendar_today, size: 16),
                        backgroundColor: Colors.blue.shade50,
                      ),
                    Chip(
                      label: Text(_priorityLabel(todo.priority)),
                      backgroundColor: _priorityColor(todo.priority),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _openTodoForm(todo: todo);
                } else if (value == 'delete') {
                  ref.read(decoyProvider.notifier).deleteTodo(todo.id);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Color _priorityColor(int priority) {
    if (priority >= 4) return Colors.red.shade100;
    if (priority == 3) return Colors.orange.shade100;
    return Colors.green.shade100;
  }

  String _priorityLabel(int priority) {
    if (priority >= 4) return 'High';
    if (priority == 3) return 'Medium';
    return 'Low';
  }
}
