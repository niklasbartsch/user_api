import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final firebaseAuth = context.read<Auth>();

  final now = DateTime.now();
  final randomNumber = now.millisecondsSinceEpoch;

  try {
    await firebaseAuth.createUser(
      CreateRequest(
        email: '[username]+$randomNumber@gmail.com',
        password: 'HelloWorld123',
      ),
    );
    return Response(body: 'Hello, world!');
  } catch (e) {
    return Response(
      body: 'Error: $e',
      statusCode: 500,
    );
  }
}
