class Task {
    final String id;
    final String title;
    final String description;
    final String dueDate;
    final String dueTime;

    Task({
        required this.id,
        required this.title,
        required this.description,
        required this.dueDate,
        required this.dueTime,
        });

    Map<String, dynamic> toMap() {
        return {
            'id' : id,
            'title' : title,
            'description' : description,
            'dueDate' : dueDate,
            'dueTime' : dueTime,
        };
    }
}