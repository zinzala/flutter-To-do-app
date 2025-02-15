import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';

import '../model/todo.dart';

class TodoServices{

  static final String baseUrl = "https://api.nstack.in/v1/todos";


  //get todos
  static Future<List<Todo>?> fetchTodos() async{
    List<Todo> todos = [];
    try{
      Response response = await get(Uri.parse(baseUrl+"?page=1&limit=10"));
      if(response.statusCode == 200){
        log('success ${response.statusCode}',name:'fetchTodos()',error: response.body);
        Map<String,dynamic> decodedJsonData = jsonDecode(response.body);
        var dataIWant = decodedJsonData['items'];
        for(var map in dataIWant){
          Todo individualTodo = Todo.fromJson(map);
          todos.add(individualTodo);
        }
      }else{
        log('failed ${response.statusCode}',name: 'fetchTodos()',error: response.body);
      }

      return todos;
    }catch(error){
      log('Error occurred',name:'Catch block',error: error.toString());
    }
  }



  //create_todo
  static Future<void> createTodo(Todo todo) async{
    try{
     Response response = await post(Uri.parse(baseUrl),body: jsonEncode(todo.toJson()),headers: {"Content-Type": "application/json"});
     if(response.statusCode == 201){
       log('success ${response.statusCode}',name: 'createTodo()',error: response.body);
     }else{
       log('failed ${response.statusCode}',name: 'createTodo()',error: response.body);
     }
    }catch(error){
      log('Error occurred',name:'Catch block',error: error.toString());
    }
  }



  //update_todo
  static Future<void> updateTodo(Todo todo,String id) async{
    try{
      Response response = await put(Uri.parse('$baseUrl/$id'),headers: {"Content-Type": "application/json"},body: jsonEncode(todo.toJson()));
      if(response.statusCode == 200){
        log('success ${response.statusCode}',name: "updateTodo()",error: response.body);
      }else{
        log('failed ${response.statusCode}',name: "updateTodo()",error: response.body);
      }
    }catch(error){
      log('Error occurred',name:'Catch block',error: error.toString());
    }
  }

  
  //delete_todo
  static Future<void> deleteTodo(String id) async{
    try{
      Response response = await delete(Uri.parse('$baseUrl/$id'));
      if(response.statusCode == 200){
        log('success ${response.statusCode}',name: 'deleteTodo()',error: response.body);
      }else{
        log('failed ${response.statusCode}',name: 'deleteTodo()',error: response.body);
      }
    }catch(error){
      log('Error occurred',name:'Catch block',error: error.toString());
    }
  }



}