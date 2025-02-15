import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/api_services/todo_services.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/utils/todo_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Material App',
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenOrientation = screenHeight > screenWidth;

    return Scaffold(
      floatingActionButton: SizedBox(
        height: screenOrientation
            ? screenWidth * 0.16
            : screenHeight * 0.16,
        width: screenOrientation
            ? screenWidth * 0.16
            : screenHeight * 0.16,
        child: FloatingActionButton(
          backgroundColor: Colors.indigo.shade900,
          onPressed: () async{
              var result  = await openBottomSheet(
              titleController: _todoController,
              descriptionController: _descriptionController,
              context: context,
              screenOrientation: screenOrientation,
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            );

              if(result == null){

              }else{
                setState(() {

                });
              }
            },
          child: Icon(
            Icons.edit,
            size: screenOrientation
                ? screenWidth * 0.08
                : screenHeight * 0.08,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Todo',
          style: TextStyle(fontFamily: 'Todo_Appbar_Font'),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: TodoServices.fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Todos Available',
                style: TextStyle(fontFamily: 'Todo_Normal_Font'),
              ),
            );
          }

          var data = snapshot.data as List<Todo>;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(data[index].title!),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red.shade900,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: screenOrientation
                            ? screenWidth * 0.05
                            : screenHeight * 0.05),
                    child: Icon(
                      Icons.delete,
                      size: screenOrientation
                          ? screenWidth * 0.065
                          : screenHeight * 0.065,
                    ),
                  ),
                ),
                onDismissed: (direction) async {
                  await TodoServices.deleteTodo(data[index].id!);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'Todo Deleted',
                    style: TextStyle(fontFamily: 'Todo_Normal_Font'),
                  )));
                  setState(() {});
                  },
                child: Card(
                  child: ExpansionTile(
                    backgroundColor: Colors.grey.shade900,
                    tilePadding: EdgeInsets.all(
                      screenOrientation
                          ? screenWidth * 0.03
                          : screenHeight * 0.03,
                    ),
                    childrenPadding: EdgeInsets.only(
                        left: screenOrientation
                            ? screenWidth * 0.13
                            : screenHeight * 0.13),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      data[index].title!,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Todo_Normal_Font',
                          fontSize: screenOrientation
                              ? screenWidth * 0.05
                              : screenHeight * 0.05),
                    ),
                    trailing: Text(
                      formatDate(data[index].createdAt!),
                      style: TextStyle(
                          fontFamily: 'Todo_Normal_Font',
                          fontSize: screenOrientation
                              ? screenWidth * 0.03
                              : screenHeight * 0.03),
                    ),
                    children: [
                      Text(
                        data[index].description!,
                        style: TextStyle(
                            fontFamily: 'Todo_Normal_Font',
                            fontSize: screenOrientation
                                ? screenWidth * 0.04
                                : screenHeight * 0.04),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              screenOrientation
                                  ? screenWidth * 0.0
                                  : screenHeight * 0.0,
                              screenOrientation
                                  ? screenWidth * 0.01
                                  : screenHeight * 0.01,
                              screenOrientation
                                  ? screenWidth * 0.04
                                  : screenHeight * 0.04,
                              screenOrientation
                                  ? screenWidth * 0.01
                                  : screenHeight * 0.01),
                          child: TextButton(
                            onPressed: () async {
                              var result = await openBottomSheet(
                                  titleController: _todoController,
                                  descriptionController: _descriptionController,
                                  context: context,
                                  screenOrientation: screenOrientation,
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth,
                                  todoObject: data[index]
                              );
                              if(result == null){

                              }else{
                                setState(() {});
                              }
                            },
                            child: Text(
                              'edit',
                              style: TextStyle(
                                  fontFamily: 'Todo_Normal_Font',
                                  fontSize: screenOrientation
                                      ? screenWidth * 0.038
                                      : screenHeight * 0.038),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
