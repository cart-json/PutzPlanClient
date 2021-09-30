class User {
  final String _name;
  final int _points;
  final int _id;
  final bool absent;
  final String mainTaskName;

  User.fromJson(Map<String, dynamic> user)
      : this._name = user['name'] ?? '',
        this._points = user['points'] ?? 0,
        this._id = user['id'] ?? 0,
        this.absent = user['absent'] ?? false,
        this.mainTaskName = user['mainTask'];

  String toString() {
    return this._name + this._id.toString();
  }

  static List<User> jsonToUserList(List<dynamic> response) {
    return response.map((e) => User.fromJson(e)).toList();
  }

  String get name => _name;
  int get id => _id;
  int get points => _points;
}
