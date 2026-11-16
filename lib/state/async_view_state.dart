sealed class AsyncViewState<T> {
  const AsyncViewState();
}

class LoadingState<T> extends AsyncViewState<T> {
  const LoadingState();
}

class EmptyState<T> extends AsyncViewState<T> {
  final String title;
  final String description;
  const EmptyState({required this.title, required this.description});
}

class DataState<T> extends AsyncViewState<T> {
  final T data;
  const DataState(this.data);
}
