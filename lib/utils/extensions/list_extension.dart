extension ListExtension<T> on List {
  T shift() {
    T data = first;
    removeAt(0);
    return data;
  }
}
