class ToDoItem{

  final int id;
  final String content;
  final int type;
  final String create_time;
  final String finished_time;

  ToDoItem({this.id, this.content, this.type, this.create_time, this.finished_time });

  factory ToDoItem.fromJson( Map<String,dynamic> json) {
    return ToDoItem (
      id: json['id'],
      content: json['content'],
      type: json['type'],
      create_time: json['create_time'],
      finished_time: json['finished_time'],
    );
  }

}