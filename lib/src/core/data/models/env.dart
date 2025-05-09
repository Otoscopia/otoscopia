import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: "SENTRY_DSN", obfuscate: true)
  static final String sentryDsn = _Env.sentryDsn;

  @EnviedField(varName: "APPWRITE_CLIENT", obfuscate: true)
  static final String appwriteClient = _Env.appwriteClient;

  @EnviedField(varName: "APPWRITE_PROJECT", obfuscate: true)
  static final String appwriteProject = _Env.appwriteProject;

  @EnviedField(varName: "APPWRITE_INJECTOR", obfuscate: true)
  static final String appwriteInjector = _Env.appwriteInjector;

  @EnviedField(varName: "APPWRITE_USERS", obfuscate: true)
  static final String users = _Env.users;

  @EnviedField(varName: "APPWRITE_DATABASE", obfuscate: true)
  static final String database = _Env.database;
}
