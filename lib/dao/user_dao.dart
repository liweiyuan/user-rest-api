import '../db/db.dart';
import '../models/user.dart';

class UserDao {
  Future<List<User>> getAllUsers() async {
    final results = await MySQLService.pool.execute('SELECT * FROM person');
    return results.rows.map((row) {
      return User.fromJson({
        'id': row.colByName('id'),
        'name': row.colByName('name'),
        'age': row.colByName('age') ?? 0,
      });
    }).toList();
  }

  Future<User?> getUserById(int id) async {
    final results = await MySQLService.pool.execute(
      'SELECT * FROM person WHERE id = :id',
      {'id': id},
    );
    if (results.rows.isEmpty) return null;

    final row = results.rows.first;
    return User.fromJson({
      'id': row.colByName('id'),
      'name': row.colByName('name'),
      'age': row.colByName('age') ?? 0,
    });
  }

  Future<User> createUser(User user) async {
    final result = await MySQLService.pool.execute(
      'INSERT INTO person (name, age) VALUES (:name, :age)',
      {'name': user.name, 'age': user.age},
    );
    final id = result.lastInsertID.toInt();
    return User(id: id, name: user.name, age: user.age);
  }

  Future<bool> updateUser(int id, User user) async {
    final result = await MySQLService.pool.execute(
      'UPDATE person SET name = :name, age = :age WHERE id = :id',
      {'id': id, 'name': user.name, 'age': user.age},
    );
    return result.affectedRows > BigInt.zero;
  }

  Future<bool> deleteUser(int id) async {
    final result = await MySQLService.pool.execute(
      'DELETE FROM person WHERE id = :id',
      {'id': id},
    );
    return result.affectedRows > BigInt.zero;
  }
}
