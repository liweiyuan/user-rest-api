import 'package:test/test.dart';
import 'package:user_rest_api/models/user.dart';
import 'package:user_rest_api/services/user_service.dart';

void main() {
  group('UserService', () {
    late UserService userService;

    setUp(() {
      userService = UserService();
    });

    group('UserService', () {
      test("Test Mock data", () {
        final users = userService.getAllUsers();
        expect(users.length, 3);
        expect(users[0].name, 'John Doe');
        expect(users[1].name, 'Jane Smith');
        expect(users[2].name, 'Bob Johnson');
      });

      test('应能添加新用户', () {
        final newUser = User(
          id: 0,
          name: 'Test User',
          email: 'test@example.com',
          age: 40,
        );
        final addedUser = userService.addUser(newUser);

        expect(addedUser.id, isNot(0));
        expect(addedUser.name, 'Test User');

        final retrievedUser = userService.getUserById(addedUser.id);
        expect(retrievedUser, isNotNull);
        expect(retrievedUser?.name, 'Test User');
      });

      test('应能更新现有用户', () {
        // 首先添加一个用户
        final newUser = User(
          id: 0,
          name: 'Original Name',
          email: 'original@example.com',
          age: 25,
        );
        final addedUser = userService.addUser(newUser);

        // 然后更新该用户
        final updatedData = User(
          id: addedUser.id,
          name: 'Updated Name',
          email: 'updated@example.com',
          age: 26,
        );

        final updatedUser = userService.updateUser(addedUser.id, updatedData);

        expect(updatedUser, isNotNull);
        expect(updatedUser?.name, 'Updated Name');
        expect(updatedUser?.email, 'updated@example.com');
        expect(updatedUser?.age, 26);
      });
      test('更新不存在的用户时应返回null', () {
        final nonExistentUser = User(
          id: 999,
          name: 'Nobody',
          email: 'nobody@example.com',
          age: 0,
        );
        final result = userService.updateUser(999, nonExistentUser);
        expect(result, isNull);
      });

      test('应能删除用户', () {
        // 首先添加一个用户
        final newUser = User(
          id: 0,
          name: 'To Delete',
          email: 'delete@example.com',
          age: 30,
        );
        final addedUser = userService.addUser(newUser);

        // 确认用户存在
        expect(userService.getUserById(addedUser.id), isNotNull);

        // 删除用户
        final result = userService.deleteUser(addedUser.id);
        expect(result, isTrue);

        // 确认用户已删除
        expect(userService.getUserById(addedUser.id), isNull);
      });

      test('删除不存在的用户时应返回false', () {
        final result = userService.deleteUser(999);
        expect(result, isFalse);
      });
    });
  });
}
