import 'package:mysql_client/mysql_client.dart';

class MySQLService {
  static late final MySQLConnectionPool pool;

  static Future<void> init() async {
    pool = MySQLConnectionPool(
      host: '*****',
      port: 3306,
      userName: 'root',
      password: 'NBS@2o13',
      databaseName: 'autotest',
      maxConnections: 10,
    );
  }

  static Future<void> close() async {
    await pool.close();
  }
}
