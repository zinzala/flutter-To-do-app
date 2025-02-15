class Todo{

  //  {
  //       "_id": "67a6df737a04b84fda32dcbe",
  //       "title": "task one",
  //       "description": "task one description",
  //       "is_completed": false,
  //       "created_at": "2025-02-08T04:37:07.414Z",
  //       "updated_at": "2025-02-08T04:37:07.414Z"
  //     },


  String? id;
  String? title;
  String? description;
  bool? isCompleted;
  String? createdAt;
  String? updatedAt;

  Todo(
      {required this.title,
      required this.description,
      required this.isCompleted,
      this.id,
      this.createdAt,
      this.updatedAt}
      );


  // named constructor
  Todo.fromJson(Map<String,dynamic> map){
    id = map['_id'];
    title = map['title'];
    description = map['description'];
    isCompleted = map['is_completed'];
    createdAt = map['created_at'];
    updatedAt = map['updated_at'];
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> data = {};
    data['title'] = title;
    data['description'] = description;
    data['is_completed'] = isCompleted;
    return data;
  }
}