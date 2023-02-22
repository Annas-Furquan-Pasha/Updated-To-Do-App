class Task {
    final String lId;
    final String id;
    final String title;
    final String description;
    final String dueDate;
    final String dueTime;

    Task({
        required this.lId,
        required this.id,
        required this.title,
        required this.description,
        required this.dueDate,
        required this.dueTime,
        });
}

class TaskList {
    final String lId;
    final String title;
    final List<Task>? tasksList;

    TaskList(this.lId, this.title, [this.tasksList]);

    Map<String, dynamic> toMap() {
        return {
          'lId' : lId,
          'title' : title,
        };
    }
}