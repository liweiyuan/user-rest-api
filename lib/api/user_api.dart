import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/user.dart';
import '../service/user_service.dart';

class UserApi {
  final UserService _userService;

  UserApi(this._userService);

  Router get router {
    final router = Router();

    // 获取所有用户
    router.get('/users', (Request request) {
      final users = _userService.getAllUsers();
      return Response.ok(
        jsonEncode(users.map((user) => user.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // 根据ID获取单个用户
    router.get('/users/<id>', (Request request, String id) {
      final userId = int.tryParse(id);
      if (userId == null) {
        return Response.notFound('User not found');
      }
      final user = _userService.getUserById(userId);
      if (user == null) {
        return Response.notFound('User not found');
      }
      return Response.ok(
        jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // 添加新用户
    router.post('/users', (Request request) async {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);
      final user = User.fromJson(data);
      final newUser = _userService.addUser(user);
      return Response.ok(
        jsonEncode(newUser.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // 更新用户
    router.put('/users/<id>', (Request request, String id) async {
      final userId = int.tryParse(id);
      if (userId == null) {
        return Response.notFound('User not found');
      }
      final payload = await request.readAsString();
      final data = jsonDecode(payload);
      final updatedUser = User.fromJson(data);
      final user = _userService.updateUser(userId, updatedUser);
      if (user == null) {
        return Response.notFound('User not found');
      }
      return Response.ok(
        jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // 删除用户
    router.delete('/users/<id>', (Request request, String id) {
      final userId = int.tryParse(id);
      if (userId == null || !_userService.deleteUser(userId)) {
        return Response.notFound('User not found');
      }
      return Response.ok('User deleted successfully');
    });

    return router;
  }
}
