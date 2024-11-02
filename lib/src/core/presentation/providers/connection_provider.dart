import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_provider.g.dart';

@Riverpod(keepAlive: true)
class Connection extends _$Connection {
  @override
  bool build() {
    return false;
  }

  void setConnection(bool value) {
    state = value;
  }
}
