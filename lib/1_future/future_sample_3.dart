void main() {
  print(1);

  Future(() {
    print(2);
  });

  Future.microtask(() {
    print(3);
    Future.microtask(() {
      print(4);
      Future.microtask(() {
        print(5);
      });
    });
  });

  print(6);
}
