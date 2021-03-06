/// This example demonstrates usage for a Dart command line application.
///
/// For details of how to use this package in Flutter, see
/// https://flutter.dev/docs/development/data-and-backend/google-apis

import 'package:firebaseapis/firebaseremoteconfig/v1.dart' as remote_config;
import 'package:firebaseapis/firebaserules/v1.dart' as firebase_rules;
import 'package:firebaseapis/identitytoolkit/v1.dart' as firebase_auth;
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<void> main() async {
  final authClient = await auth.clientViaApplicationDefaultCredentials(scopes: [
    firebase_rules.FirebaseRulesApi.firebaseScope,
    // or read only
    // firebase_rules.FirebaseRulesApi.firebaseReadonlyScope,

    firebase_auth.IdentityToolkitApi.firebaseScope,

    remote_config.FirebaseRemoteConfigApi.cloudPlatformScope,
  ]);

  // // or
  // final authClient =
  //     auth.clientViaApiKey('API KEY GOES HERE');

  // // or
  // final authClient = await auth.clientViaServiceAccount(
  //   auth.ServiceAccountCredentials.fromJson(
  //     r'''
  //          YOUR JSON HERE
  //       ''',
  //   ),
  //   [
  //     remote_config.FirebaseRemoteConfigApi.cloudPlatformScope,
  //   ],
  // );

  final fr = firebase_rules.FirebaseRulesApi(authClient);
  final rules = await fr.projects.rulesets.list('projects/<your-project-id>');

  print(rules.rulesets?.first.name);
  print(rules.rulesets?.first.source?.files?.first.content);

  final rc = remote_config.FirebaseRemoteConfigApi(authClient);
  final config =
      await rc.projects.getRemoteConfig('projects/<your-project-id>');
  print(config.parameters);
  print(config.parameters?.values.first.defaultValue);
  print(config.parameters?.values.first.description);
  print(config.parameters?.values.first.valueType);

  final fa = firebase_auth.IdentityToolkitApi(authClient);
  final users = await fa.accounts
      .lookup(firebase_auth.GoogleCloudIdentitytoolkitV1GetAccountInfoRequest(
    localId: ['<your-user-id>'],
  ));
  print(users.users?.first.localId);
  print(users.users?.first.email);
  authClient.close();
}
