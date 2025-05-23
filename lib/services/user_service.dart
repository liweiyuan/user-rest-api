import '../models/user.dart';
import '../dao/user_dao.dart';

class UserService {
  final UserDao userDao;

  UserService({UserDao? userDao}) : userDao = userDao ?? UserDao();

  // 获取所有用户
  Future<List<User>> getAllUsers() async {
    return await userDao.getAllUsers();
  }

  // 根据ID获取单个用户
  Future<User?> getUserById(int id) async {
    return await userDao.getUserById(id);
  }

  // 添加新用户
  Future<User> addUser(User user) async {
    return await userDao.createUser(user);
  }

  // 更新用户
  Future<User?> updateUser(int id, User updatedUser) async {
    final success = await userDao.updateUser(id, updatedUser);
    if (success) {
      return await userDao.getUserById(id);
    }
    return null;
  }

  // 删除用户
  Future<bool> deleteUser(int id) async {
    return await userDao.deleteUser(id);
  }
}
