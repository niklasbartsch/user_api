import 'dart:io';

import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_frog/dart_frog.dart';

late FirebaseAdminApp admin;
late Firestore firestore;
late Auth firebaseAuth;

const projectId = '[PROJECT_ID]';

Future<void> init(InternetAddress ip, int port) async {
  // Read the service account JSON from the environment variable
  final serviceAccountJsonString =
      Platform.environment['GOOGLE_APPLICATION_CREDENTIALS'];

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

  firestore = Firestore(admin);
  firebaseAuth = Auth(admin);
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final newHandler = handler
      .use(provider<FirebaseAdminApp>((context) => admin))
      .use(provider<Auth>((context) => firebaseAuth))
      .use(provider<Firestore>((context) => firestore));

  return serve(newHandler, ip, port);
}
