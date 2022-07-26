void main() {
  print(1);

  Future(() {
    print(2);
  });

  print(3);
}