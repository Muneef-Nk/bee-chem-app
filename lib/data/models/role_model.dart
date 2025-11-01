class Role {
  int? id;
  String? role;

  Role({this.id, this.role});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
  }
}
