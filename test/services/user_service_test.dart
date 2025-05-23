import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:user_rest_api/models/user.dart';
import 'package:user_rest_api/services/user_service.dart';
import 'package:user_rest_api/dao/user_dao.dart';

@GenerateMocks([UserDao])
import 'user_service_test.mocks.dart';

void main() {
  late UserService userService;
  late MockUserDao mockUserDao;

  setUp(() {
    mockUserDao = MockUserDao();
    userService = UserService(userDao: mockUserDao);
  });

  group('UserService', () {
    test('获取所有用户测试', () async {
      // 设置mock行为
      when(mockUserDao.getAllUsers()).thenAnswer(
        (_) async => [
          User(id: 1, name: 'John Doe', age: 30),
          User(id: 2, name: 'Jane Smith', age: 25),
          User(id: 3, name: 'Bob Johnson', age: 35),
        ],
      );

      final users = await userService.getAllUsers();
      expect(users.length, 3);
      expect(users[0].name, 'John Doe');
      expect(users[1].name, 'Jane Smith');
      expect(users[2].name, 'Bob Johnson');

      verify(mockUserDao.getAllUsers()).called(1);
    });

    test('添加新用户测试', () async {
      final newUser = User(id: 0, name: 'Test User', age: 40);
      final expectedUser = User(id: 1, name: 'Test User', age: 40);

      when(
        mockUserDao.createUser(newUser),
      ).thenAnswer((_) async => expectedUser);

      final addedUser = await userService.addUser(newUser);
      expect(addedUser.id, 1);
      expect(addedUser.name, 'Test User');

      verify(mockUserDao.createUser(newUser)).called(1);
    });

    test('更新现有用户测试', () async {
      final updatedData = User(id: 1, name: 'Updated Name', age: 26);

      when(
        mockUserDao.updateUser(1, updatedData),
      ).thenAnswer((_) async => true);
      when(mockUserDao.getUserById(1)).thenAnswer((_) async => updatedData);

      final updatedUser = await userService.updateUser(1, updatedData);

      expect(updatedUser, isNotNull);
      expect(updatedUser!.name, 'Updated Name');
      expect(updatedUser.age, 26);

      verify(mockUserDao.updateUser(1, updatedData)).called(1);
      verify(mockUserDao.getUserById(1)).called(1);
    });

    test('更新不存在用户测试', () async {
      final nonExistentUser = User(id: 999, name: 'Nobody', age: 0);

      when(
        mockUserDao.updateUser(999, nonExistentUser),
      ).thenAnswer((_) async => false);

      final result = await userService.updateUser(999, nonExistentUser);
      expect(result, isNull);

      verify(mockUserDao.updateUser(999, nonExistentUser)).called(1);
    });

    test('删除用户测试', () async {
      when(mockUserDao.deleteUser(1)).thenAnswer((_) async => true);

      final result = await userService.deleteUser(1);
      expect(result, isTrue);

      verify(mockUserDao.deleteUser(1)).called(1);
    });

    test('删除不存在用户测试', () async {
      when(mockUserDao.deleteUser(999)).thenAnswer((_) async => false);

      final result = await userService.deleteUser(999);
      expect(result, isFalse);

      verify(mockUserDao.deleteUser(999)).called(1);
    });
  });
}
