import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cypherkeep/data/models/todo_item.dart';
import 'package:cypherkeep/data/services/hive_service.dart';
import 'package:cypherkeep/core/constants/storage_keys.dart';
import 'package:uuid/uuid.dart';

/// Provider for decoy todo app
final decoyProvider =
    StateNotifierProvider<DecoyNotifier, List<TodoItem>>((ref) {
  return DecoyNotifier();
});

/// Notifier for decoy todo management
class DecoyNotifier extends StateNotifier<List<TodoItem>> {
  DecoyNotifier() : super([]) {
    _loadTodos();
  }

  final _hiveService = HiveService();
  final _uuid = const Uuid();

  Future<void> _loadTodos() async {
    final box = _hiveService.getBox<TodoItem>(StorageKeys.decoyTodoBox);

    // Add default todos if empty
    if (box.isEmpty) {
      await _addDefaultTodos();
    }

    state = box.values.toList();
  }

  Future<void> _addDefaultTodos() async {
    final box = _hiveService.getBox<TodoItem>(StorageKeys.decoyTodoBox);
    final now = DateTime.now();

    final defaultTodos = [
      TodoItem(
        id: _uuid.v4(),
        title: 'Buy groceries',
        description: 'Milk, eggs, bread',
        createdAt: now,
        priority: 3,
      ),
      TodoItem(
        id: _uuid.v4(),
        title: 'Call dentist',
        description: 'Schedule appointment',
        createdAt: now,
        priority: 4,
      ),
      TodoItem(
        id: _uuid.v4(),
        title: 'Finish project report',
        description: 'Due by Friday',
        createdAt: now,
        dueDate: now.add(const Duration(days: 3)),
        priority: 5,
      ),
      TodoItem(
        id: _uuid.v4(),
        title: 'Pay bills',
        description: 'Electricity and water',
        createdAt: now.subtract(const Duration(days: 2)),
        priority: 4,
        isCompleted: true,
      ),
    ];

    for (final todo in defaultTodos) {
      await box.add(todo);
    }
  }

  Future<void> addTodo(
    String title, {
    String? description,
    DateTime? dueDate,
    int priority = 3,
  }) async {
    final clampedPriority = priority.clamp(1, 5);

    final item = TodoItem(
      id: _uuid.v4(),
      title: title,
      description: description ?? '',
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: clampedPriority,
    );

    final box = _hiveService.getBox<TodoItem>(StorageKeys.decoyTodoBox);
    await box.add(item);
    state = box.values.toList();
  }

  Future<void> updateTodo(
    String id,
    String title, {
    String? description,
    DateTime? dueDate,
    int priority = 3,
  }) async {
    final box = _hiveService.getBox<TodoItem>(StorageKeys.decoyTodoBox);
    final index = box.values.toList().indexWhere((t) => t.id == id);
    if (index != -1) {
      final oldTodo = box.getAt(index)!;
      final updatedTodo = TodoItem(
        id: oldTodo.id,
        title: title,
        description: description ?? '',
        createdAt: oldTodo.createdAt,
        dueDate: dueDate,
        priority: priority.clamp(1, 5),
        isCompleted: oldTodo.isCompleted,
      );
      await box.putAt(index, updatedTodo);
      state = box.values.toList();
    }
  }

  Future<void> deleteTodo(String id) async {
    final box = _hiveService.getBox<TodoItem>(StorageKeys.decoyTodoBox);
    final index = box.values.toList().indexWhere((t) => t.id == id);
    if (index != -1) {
      await box.deleteAt(index);
      state = box.values.toList();
    }
  }

  Future<void> toggleTodo(String id) async {
    final box = _hiveService.getBox<TodoItem>(StorageKeys.decoyTodoBox);
    final index = box.values.toList().indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = box.getAt(index)!;
      final updated = todo.copyWith(isCompleted: !todo.isCompleted);
      await box.putAt(index, updated);
      state = box.values.toList();
    }
  }

  List<TodoItem> getActiveTodos() {
    return state.where((todo) => !todo.isCompleted).toList();
  }

  List<TodoItem> getCompletedTodos() {
    return state.where((todo) => todo.isCompleted).toList();
  }

  String generateId() => _uuid.v4();
}
