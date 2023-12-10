import 'dart:io';

import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';

const projectId = '[PROJECT_ID]';

Future<void> main(List<String> args) async {
  final serviceAccountJsonString =
      Platform.environment['GOOGLE_APPLICATION_CREDENTIALS'];

  FirebaseAdminApp admin;

  if (serviceAccountJsonString != null) {
    // Write the JSON string to a temporary file
    final tempFile = File('temp_service_account.json');
    await tempFile.writeAsString(serviceAccountJsonString);

    final credentials = Credential.fromServiceAccount(
      File('temp_service_account.json'),
    );

    admin = FirebaseAdminApp.initializeApp(
      projectId,
      credentials,
    );
  } else {
    final credentials = Credential.fromApplicationDefaultCredentials();

    admin = FirebaseAdminApp.initializeApp(
      projectId,
      credentials,
    );
  }

  final firebaseAuth = Auth(admin);
  final now = DateTime.now();
  final randomNumber = now.millisecondsSinceEpoch;

  final createRequest = CreateRequest(
    email: '[username]+$randomNumber@gmail.com',
    password: 'HelloWorld123',
  );

  try {
    await firebaseAuth.createUser(createRequest);
    print('success');
  } catch (e) {
    print(e);
  }
}
