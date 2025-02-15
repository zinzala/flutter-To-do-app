import 'package:flutter/material.dart';
import '../api_services/todo_services.dart';
import '../model/todo.dart';

Future<bool?> openBottomSheet({
  required BuildContext context,
  required bool screenOrientation,
  required double screenHeight,
  required double screenWidth,
  required TextEditingController titleController,
  required TextEditingController descriptionController,
  Todo? todoObject,
}) async {
  if (todoObject != null) {
    titleController.text = todoObject.title!;
    descriptionController.text = todoObject.description!;
  } else {
    titleController.clear();
    descriptionController.clear();
  }

  return await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return OpenBottomSheet(
        context: context,
        screenOrientation: screenOrientation,
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        titleController: titleController,
        descriptionController: descriptionController,
        todoObject: todoObject,
      );
    },
  );
}

class OpenBottomSheet extends StatefulWidget {
  BuildContext context;
  bool screenOrientation;
  double screenHeight;
  double screenWidth;
  TextEditingController titleController;
  TextEditingController descriptionController;
  Todo? todoObject;

  OpenBottomSheet(
      {super.key,
      required this.context,
      required this.screenOrientation,
      required this.screenHeight,
      required this.screenWidth,
      required this.titleController,
      required this.descriptionController,
      this.todoObject});

  @override
  State<OpenBottomSheet> createState() => _OpenBottomSheetState();
}

class _OpenBottomSheetState extends State<OpenBottomSheet> {
  String? errorTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context)
              .bottom), //MediaQuery.of(context).viewInsets.bottom
      child: SingleChildScrollView(
        child: Container(
          height: widget.screenOrientation
              ? widget.screenWidth * 0.80
              : widget.screenHeight * 0.80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.screenOrientation
                  ? widget.screenWidth * 0.03
                  : widget.screenHeight * 0.03),
              topRight: Radius.circular(widget.screenOrientation
                  ? widget.screenWidth * 0.03
                  : widget.screenHeight * 0.03),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                widget.screenOrientation
                    ? widget.screenWidth * 0.02
                    : widget.screenHeight * 0.02,
                widget.screenOrientation
                    ? widget.screenWidth * 0.03
                    : widget.screenHeight * 0.03,
                widget.screenOrientation
                    ? widget.screenWidth * 0.02
                    : widget.screenHeight * 0.02,
                0.0),
            child: Column(
              children: [
                TextField(
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Todo_Normal_Font'),
                  controller: widget.titleController,
                  decoration: InputDecoration(
                      errorText: errorTitle,
                      errorStyle: TextStyle(color: Colors.red,fontFamily: 'Todo_Normal_Font'),
                      hintStyle: TextStyle(
                          fontFamily: 'Todo_Normal_Font',
                          color: Colors.black54),
                      hintText: 'Enter Todo',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
                SizedBox(
                  height: widget.screenOrientation
                      ? widget.screenWidth * 0.02
                      : widget.screenHeight * 0.02,
                ),
                TextField(
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Todo_Normal_Font'),
                  controller: widget.descriptionController,
                  minLines: 5,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontFamily: 'Todo_Normal_Font', color: Colors.black54),
                    hintText: 'Enter Description...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: widget.screenOrientation
                      ? widget.screenWidth * 0.04
                      : widget.screenHeight * 0.04,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.screenOrientation
                            ? widget.screenWidth * 0.08
                            : widget.screenHeight * 0.08,
                        vertical: widget.screenOrientation
                            ? widget.screenWidth * 0.03
                            : widget.screenHeight * 0.03,
                      ),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              widget.screenOrientation
                                  ? widget.screenWidth * 0.03
                                  : widget.screenHeight * 0.03))),
                  onPressed: () async {
                    if (widget.titleController.text.isEmpty) {
                      errorTitle = 'Title can not be empty';
                      setState(() {});
                    } else {
                      errorTitle = null;
                      Todo todo = Todo(
                          title: widget.titleController.text.toString(),
                          description:
                              widget.descriptionController.text.toString(),
                          isCompleted: false);

                      if (widget.todoObject != null) {
                        await TodoServices.updateTodo(
                            todo, widget.todoObject!.id!);
                        Navigator.pop(context, true);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Todo Updated',
                          style: TextStyle(fontFamily: 'Todo_Normal_Font'),
                        )));
                      } else {
                        await TodoServices.createTodo(todo);
                        Navigator.pop(context, true);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Todo Added',
                          style: TextStyle(fontFamily: 'Todo_Normal_Font'),
                        )));
                      }
                      setState(() {});
                    }
                  },
                  child: Text(
                    (widget.todoObject == null) ? 'ADD' : 'UPDATE',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Todo_Normal_Font',
                      fontSize: widget.screenOrientation
                          ? widget.screenWidth * 0.04
                          : widget.screenHeight * 0.04,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
