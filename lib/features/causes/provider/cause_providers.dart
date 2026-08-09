import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../data/cause_api.dart';
import '../data/cause_repository.dart';
import '../model/cause.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = createDio();
  ref.onDispose(dio.close);
  return dio;
});

final causeApiProvider = Provider<CauseApi>(
  (ref) => CauseApi(ref.watch(dioProvider)),
);

final causeRepositoryProvider = Provider<CauseRepository>(
  (ref) => RemoteCauseRepository(ref.watch(causeApiProvider)),
);

// Riverpod retries failed providers on its own; recovery here is the retry button.
final causeListProvider = AsyncNotifierProvider<CauseListNotifier, List<Cause>>(
  CauseListNotifier.new,
  retry: (_, _) => null,
);

class CauseListNotifier extends AsyncNotifier<List<Cause>> {
  @override
  Future<List<Cause>> build() => ref.watch(causeRepositoryProvider).getCauses();

  Future<void> refresh() async {
    state = await AsyncValue.guard(ref.read(causeRepositoryProvider).getCauses);
  }

  Future<void> retry() async {
    state = const AsyncValue.loading();
    await refresh();
  }
}
