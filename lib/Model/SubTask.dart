class SubTask {
  final String _name;
  final int _id;
  final int points;
  final String mainTaskName;

  SubTask.fromJson(Map<String, dynamic> task)
      : this._name = task['name'] ?? '',
        this._id = task['id'] ?? 0,
        this.points = task['points'] ?? 0,
        this.mainTaskName = task['mainTask'] ?? '';

  static List<SubTask> jsonToTaskList(List<dynamic> response) {
    return response.map((e) => SubTask.fromJson(e)).toList();
  }

  String toString() {
    return this._name + this._id.toString();
  }

  String get name => _name;
  int get id => _id;
}

//Import, Zugriff und Änderungen an den Nutzern
