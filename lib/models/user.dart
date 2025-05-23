class User {
  final int id;
  final String name;
  final int age;

  User({required this.id, required this.name, required this.age});
  // Factory constructor to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'age': age};
  }
}
