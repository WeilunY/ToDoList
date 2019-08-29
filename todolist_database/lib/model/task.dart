
class Task {
    int id;
    String content;
    int type;
    String createTime;
    String finishedTime;
    String dueDate;
    int status;

    Task({
        this.id,
        this.content,
        this.type,
        this.createTime,
        this.finishedTime,
        this.dueDate,
        this.status,
    });

    factory Task.fromJson(Map<String, dynamic> json) => new Task(
        id: json["id"],
        content: json["content"],
        type: json["type"],
        createTime: json["create_time"],
        finishedTime: json["finished_time"],
        dueDate: json["due_date"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "type": type,
        "create_time": createTime,
        "finished_time": finishedTime,
        "due_date": dueDate,
        "status": status,
    };
}
