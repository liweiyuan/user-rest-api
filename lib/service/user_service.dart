import '../models/user.dart';

class UserService {
  // 内存存储 - 使用Map模拟数据库
  final Map<int, User> _users = {};
  int _nextId = 1;
  UserService() {
    // 添加一些初始的mock数据
    addUser(User(id: 0, name: 'John Doe', email: 'john@example.com', age: 30));
    addUser(
      User(id: 0, name: 'Jane Smith', email: 'jane@example.com', age: 25),
    );
    addUser(
      User(id: 0, name: 'Bob Johnson', email: 'bob@example.com', age: 35),
    );
  }

  // 获取所有用户
  List<User> getAllUsers() {
    return _users.values.toList();
  }

  // 根据ID获取单个用户
  User? getUserById(int id) {
    return _users[id];
  }

  // 添加新用户
  User addUser(User user) {
    final newUser = User(
      id: user.id == 0 ? _nextId++ : user.id,
      name: user.name,
      email: user.email,
      age: user.age,
    );
    _users[newUser.id] = newUser;
    return newUser;
  }

  // 更新用户
  User? updateUser(int id, User updatedUser) {
    if (!_users.containsKey(id)) return null;

    final user = User(
      id: id,
      name: updatedUser.name,
      email: updatedUser.email,
      age: updatedUser.age,
    );

    _users[id] = user;
    return user;
  }

  // 删除用户
  bool deleteUser(int id) {
    if (!_users.containsKey(id)) return false;
    _users.remove(id);
    return true;
  }
}
