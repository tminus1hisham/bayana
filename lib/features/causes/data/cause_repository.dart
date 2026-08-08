import '../model/cause.dart';
import 'cause_api.dart';

abstract class CauseRepository {
  Future<List<Cause>> getCauses();
}

class RemoteCauseRepository implements CauseRepository {
  const RemoteCauseRepository(this._api);

  final CauseApi _api;

  @override
  Future<List<Cause>> getCauses() => _api.fetchCauses();
}
