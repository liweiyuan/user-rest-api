import 'dart:io';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:user_rest_api/services/user_service.dart';
import 'package:user_rest_api/api/user_api.dart';

// 配置CORS中间件
Middleware _corsMiddleware() {
  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok(
          '',
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
          },
        );
      }
      return null;
    },
    responseHandler: (Response response) {
      return response.change(
        headers: {...response.headers, 'Access-Control-Allow-Origin': '*'},
      );
    },
  );
}

void main(List<String> args) async {
  // 解析命令行参数
  final parser = ArgParser()..addOption('port', abbr: 'p', defaultsTo: '8080');

  final result = parser.parse(args);
  final port = int.parse(result['port'] as String);

  // 创建服务
  final userService = UserService();

  // 创建API
  final userApi = UserApi(userService);

  // 创建路由器
  final router = Router();

  // 挂载用户API
  router.mount('/api', userApi.router.call);

  // 添加一个简单的首页
  router.get('/', (Request request) {
    return Response.ok(
      '<html><body><h1>Dart REST API 服务器</h1>'
      '<p>使用以下端点：</p>'
      '<ul>'
      '<li>GET /api/users - 获取所有用户</li>'
      '<li>GET /api/users/:id - 获取单个用户</li>'
      '<li>POST /api/users - 创建新用户</li>'
      '<li>PUT /api/users/:id - 更新用户</li>'
      '<li>DELETE /api/users/:id - 删除用户</li>'
      '</ul></body></html>',
      headers: {'Content-Type': 'text/html'},
    );
  });

  // 创建处理管道
  final handler = Pipeline()
      .addMiddleware(logRequests()) // 日志记录
      .addMiddleware(_corsMiddleware()) // CORS支持
      .addHandler(router.call);

  // 启动服务器
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  print('服务器运行在: http://${server.address.host}:${server.port}');
}
