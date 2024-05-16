import 'package:flutter_riverpod/flutter_riverpod.dart';

//!Variables
String textTodo = '';
String newTextTodo = '';

//! Todo

class Todo {
  final String title;
  final bool isCompleted;

  Todo({required this.title, this.isCompleted = false});
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  void addTodo(String title) {
    state = [...state, Todo(title: title)];
  }

  void toggleTodo(int index, WidgetRef ref) {
    final todo = ref.watch(todoProvider);
    todo[index] =
        Todo(title: todo[index].title, isCompleted: !todo[index].isCompleted);
    state = [...todo];
  }

  void deleteTodo(int index, WidgetRef ref) {
    final todo = ref.watch(todoProvider);
    todo.removeAt(index);
    state = [...todo];
  }

  void replaceTodo(WidgetRef ref, int index, String newTitle) {
    List<Todo> todo = ref.watch(todoProvider);
    todo[index] = Todo(title: newTitle);
    state = [...todo];
  }
}

// !Filter
enum Filter { all, active, completed }

final filterProvider = StateProvider<Filter>((ref) {
  return Filter.all;
});

final filterTodoProvider = StateProvider<List<Todo>>((ref) {
  List<Todo> todo = ref.watch(todoProvider);
  Filter filter = ref.watch(filterProvider);
  if (filter == Filter.active) {
    return [...todo.where((element) => !element.isCompleted)];
  } else if (filter == Filter.completed) {
    return [...todo.where((element) => element.isCompleted)];
  } else {
    return [...todo];
  }
});
