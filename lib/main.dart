import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  List<Task> tasks = [];

  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDFFDD),
      appBar: AppBar(
        title: Text("To-do list App"),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Scaffold.of(context).showBottomSheet(
                (context) => AddTaskScreen(
                      onSubmitClicked: (String title, String description) {
                        _addTask(title, description);
                      },
                    ),
                elevation: 20);
          },
        );
      }),
      body: AnimatedList(
        key: listKey,
        initialItemCount: tasks.length,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          return _buildItem(context, animation, tasks[index]);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, Animation animation, Task task) {
    return FadeTransition(
      opacity: animation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          shadowColor: Color(0xFF6699FF).withOpacity(.60),
          child: InkWell(
            onTap: () {},
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.local_fire_department_rounded),
                onPressed: () {},
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteTask(task);
                },
              ),
              title: Text(task.title),
              subtitle: Text(task.description),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteTask(Task task) {
    listKey.currentState.removeItem(tasks.indexOf(task),
        (BuildContext context, Animation<double> animation) {
      return _buildItem(context, animation, task);
    });
    tasks.remove(task);
  }

  void _addTask(String title, String desc) {
    tasks.add(Task(title, desc));
    listKey.currentState.insertItem(tasks.length - 1);
  }
}

class AddTaskScreen extends StatefulWidget {
  final Function(String title, String desc) onSubmitClicked;

  AddTaskScreen({Key key, this.onSubmitClicked}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 36,
          ),
          Text(
            'Add Task',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 16,
          ),
          TextField(
            controller: titleCtrl,
            decoration: InputDecoration(
                labelText: "Title", hintText: "Enter title here"),
          ),
          SizedBox(height: 16),
          TextField(
            controller: descriptionCtrl,
            decoration: InputDecoration(
                labelText: "Description", hintText: "Enter description here"),
          ),
          SizedBox(height: 16),
          RaisedButton(
              child: Text("SUBMIT"),
              onPressed: () {
                Navigator.pop(context);
                widget.onSubmitClicked(titleCtrl.text, descriptionCtrl.text);
              }),
          SizedBox(
            height: 36,
          ),
        ],
      ),
    );
  }
}

class Task {
  final String title;
  final String description;

  Task(this.title, this.description);
}
