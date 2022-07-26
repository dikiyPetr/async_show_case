void main() {
  print(1);

  Future(() {
    print(2);
  });

  Future.microtask(() {
    print(3);
  });

  print(4);
}
