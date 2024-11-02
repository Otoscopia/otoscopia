import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:otoscopia/src/core/core.dart';

part 'search_provider.g.dart';

@Riverpod(keepAlive: true)
class Search extends _$Search {
  @override
  List<SearchEntity> build() {
    return [];
  }

  void addList(List<SearchEntity> list) => state = list;
}
