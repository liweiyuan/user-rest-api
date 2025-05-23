import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class UserApi {
  final UserService _userService;

  UserApi(this._userService);

  Router get router {
    final router = Router();

    // 获取所有用户
    router.get('/users', (Request request) async {
      final users = await _userService.getAllUsers();
      return Response.ok(
        jsonEncode(users.map((user) => user.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // 根据ID获取单个用户
    router.get('/users/<id>', (Request request, String id) async {
      final userId = int.tryParse(id);
      if (userId == null) {
        return Response.notFound('Invalid user ID');
      }
      final user = await _userService.getUserById(userId);
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
      try {
        final payload = await request.readAsString();
        final data = jsonDecode(payload);
        final user = User.fromJson(data);
        final newUser = await _userService.addUser(user);
        return Response.ok(
          jsonEncode(newUser.toJson()),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.badRequest(
          body: jsonEncode({'error': '无效的用户数据格式'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    // 更新用户
    router.put('/users/<id>', (Request request, String id) async {
      final userId = int.tryParse(id);
      if (userId == null) {
        return Response.badRequest(
          body: jsonEncode({'error': '无效的用户ID'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      try {
        final payload = await request.readAsString();
        final data = jsonDecode(payload);
        final updatedUser = User.fromJson(data);
        final user = await _userService.updateUser(userId, updatedUser);
        if (user == null) {
          return Response.notFound('User not found');
        }
        return Response.ok(
          jsonEncode(user.toJson()),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.badRequest(
          body: jsonEncode({'error': '无效的用户数据格式'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    // 删除用户
    router.delete('/users/<id>', (Request request, String id) async {
      final userId = int.tryParse(id);
      if (userId == null) {
        return Response.badRequest(
          body: jsonEncode({'error': '无效的用户ID'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final success = await _userService.deleteUser(userId);
      if (!success) {
        return Response.notFound('User not found');
      }
      return Response.ok('User deleted successfully');
    });

    return router;
  }
}
