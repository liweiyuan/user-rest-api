import 'dart:convert';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:shelf/shelf.dart';
import 'package:user_rest_api/models/user.dart';
import 'package:user_rest_api/services/user_service.dart';
import 'package:user_rest_api/api/user_api.dart';
//生成Mock服务
@GenerateMocks([UserService])
import 'user_api_test.mocks.dart';

void main() {
  late MockUserService mockUserService;
  late UserApi userApi;

  setUp(() {
    mockUserService = MockUserService();
    userApi = UserApi(mockUserService);
  });

  group('UserApi', () {
    test('GET /users 应返回所有用户', () async {
      // 准备mock数据
      final users = [
        User(id: 1, name: 'User 1', email: 'user1@example.com', age: 30),
        User(id: 2, name: 'User 2', email: 'user2@example.com', age: 25),
      ];

      // 设置mock行为
      when(mockUserService.getAllUsers()).thenReturn(users);

      // 发送请求到API
      final request = Request('GET', Uri.parse('http://localhost/users'));
      final response = await userApi.router.call(request);

      // 验证响应
      expect(response.statusCode, 200);

      final responseBody = await response.readAsString();
      final responseJson = jsonDecode(responseBody) as List;

      expect(responseJson.length, 2);
      expect(responseJson[0]['name'], 'User 1');
      expect(responseJson[1]['name'], 'User 2');

      // 验证mock服务被调用
      verify(mockUserService.getAllUsers()).called(1);
    });

    test('GET /users/:id 应返回单个用户', () async {
      // 准备mock数据
      final user = User(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        age: 35,
      );

      // 设置mock行为
      when(mockUserService.getUserById(1)).thenReturn(user);

      // 发送请求到API
      final request = Request('GET', Uri.parse('http://localhost/users/1'));
      final response = await userApi.router.call(request);

      // 验证响应
      expect(response.statusCode, 200);

      final responseBody = await response.readAsString();
      final responseJson = jsonDecode(responseBody);

      expect(responseJson['id'], 1);
      expect(responseJson['name'], 'Test User');

      // 验证mock服务被调用
      verify(mockUserService.getUserById(1)).called(1);
    });

    test('GET /users/:id 对于不存在的用户应返回404', () async {
      // 设置mock行为 - 返回null表示用户不存在
      when(mockUserService.getUserById(999)).thenReturn(null);

      // 发送请求到API
      final request = Request('GET', Uri.parse('http://localhost/users/999'));
      final response = await userApi.router.call(request);

      // 验证响应
      expect(response.statusCode, 404);

      // 验证mock服务被调用
      verify(mockUserService.getUserById(999)).called(1);
    });

    // 可以继续添加更多测试案例...
  });
}
