enum RepositoryStateType {
  loading,
  data,
  empty,
  stale,
  unavailable,
  validationFailure,
  authorizationFailure,
  error,
}

class RepositoryState<T> {
  const RepositoryState(this.type, {this.data, this.message});

  final RepositoryStateType type;
  final T? data;
  final String? message;

  const RepositoryState.loading() : this(RepositoryStateType.loading);
  const RepositoryState.data(T value)
      : this(RepositoryStateType.data, data: value);
  const RepositoryState.empty() : this(RepositoryStateType.empty);
  const RepositoryState.unavailable([String? message])
      : this(RepositoryStateType.unavailable, message: message);
  const RepositoryState.error(String message)
      : this(RepositoryStateType.error, message: message);
}
