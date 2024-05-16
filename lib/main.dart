import 'package:flutter/material.dart';
import 'providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main(List<String> args) {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todo = ref.watch(filterTodoProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            title: const Text('Todo App'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.red,
          ),
          body: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: false,
                    onSelected: (value) {
                      ref.read(filterProvider.notifier).state = Filter.all;
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Completed'),
                    selected: false,
                    onSelected: (value) {
                      ref.read(filterProvider.notifier).state =
                          Filter.completed;
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Active'),
                    selected: false,
                    onSelected: (value) {
                      ref.read(filterProvider.notifier).state =
                          Filter.active;
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: todo.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(todo[index].title),
                        trailing: IconButton.outlined(
                          onPressed: () => ref
                              .read(todoProvider.notifier)
                              .deleteTodo(index, ref),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        leading: Checkbox(
                            value: todo[index].isCompleted,
                            onChanged: (_) => ref
                                .read(todoProvider.notifier)
                                .toggleTodo(index, ref)),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  replaceDialogPopup(context, ref, index));
                        });
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return addDialogPopup(context, ref);
                  });
            },
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }
}

Widget addDialogPopup(BuildContext context, WidgetRef ref) {
  return AlertDialog(
    title: const Text('Add Todo'),
    content: TextField(
      // keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      autofocus: true,
      onChanged: (value) => textTodo = value,
    ),
    surfaceTintColor: Colors.grey,
    actions: <Widget>[
      OutlinedButton(
          onPressed: () {
            if (textTodo != '') {
              ref.watch(todoProvider.notifier).addTodo(textTodo);
              textTodo = '';
            }
            Navigator.pop(context);
          },
          child: const Text('Add')),
      OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel')),
    ],
  );
}

Widget replaceDialogPopup(BuildContext context, ref, int index) {
  return AlertDialog(
    title: const Text('Replace Todo'),
    content: TextField(
      minLines: 1,
      maxLines: 5,
      autofocus: true,
      onChanged: (value) => newTextTodo = value,
    ),
    surfaceTintColor: Colors.grey,
    actions: <Widget>[
      OutlinedButton(
          onPressed: () {
            if (newTextTodo != '') {
              ref
                  .watch(todoProvider.notifier)
                  .replaceTodo(ref, index, newTextTodo);
              newTextTodo = '';
            }
            Navigator.pop(context);
          },
          child: const Text('Replace')),
      OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel')),
    ],
  );
}
