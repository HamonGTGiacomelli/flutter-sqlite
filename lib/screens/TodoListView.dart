import 'package:flutter/material.dart';
import 'package:fluttersqlite/model/todo.dart';
import 'package:fluttersqlite/util/dbhelper.dart';

class TodoList extends StatefulWidget {
  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  void getData() {
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((results) {
        List<Todo> todoList = List<Todo>();

        count = results.length;

        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(results[i]));
          debugPrint(todoList[i].title);
        }

        setState(() {
          todos = todoList;
        });

        debugPrint("Items " + count.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (todos == null) {
      todos = List<Todo>();
      getData();
    }

    return Scaffold(
      body: todosListItem(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Transform(
            transform: Matrix4.identity()..translate(0.0, -32.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                debugPrint("Estou aqui");
              },
            ),
          ),
        ],
      ),
    );
  }

  ListView todosListItem() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.todos[position].priority),
              child: Text(this.todos[position].priority.toString()),
            ),
            title: Text(this.todos[position].title),
            subtitle: Text(this.todos[position].date),
            onTap: () {
              debugPrint("Tapped on " + this.todos[position].id.toString());
            },
          ),
        );
      },
    );
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;

      default:
        return Colors.green;
    }
  }
}