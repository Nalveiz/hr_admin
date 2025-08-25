/// Base repository interface for all data operations
abstract class BaseRepository<T, ID> {
  Future<List<T>> getAll({Map<String, dynamic>? filters});
  Future<T?> getById(ID id);
  Future<T> create(T entity);
  Future<T> update(ID id, T entity);
  Future<void> delete(ID id);
}

/// Base use case interface
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Base use case without parameters
abstract class UseCaseNoParams<Type> {
  Future<Type> call();
}

/// Generic parameters class
abstract class Params {
  const Params();
}

/// No parameters class
class NoParams extends Params {
  const NoParams();
}
