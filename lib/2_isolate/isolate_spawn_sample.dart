import 'dart:async';
import 'dart:isolate';

import 'message.dart';
import 'spawn_isolate.dart';

Future<void> main() async {
  // создаем изолят и получаем SendPort для связи с ним
  final sendPort = await spawnIsolate();

  // в этот ReceivePort вернется результат выполнения Message
  final receivePort = ReceivePort();
  // передаем Message для исполнения в другой изолят и указываем sendPort,
  // в который нужно вернуть ответ
  sendPort.send(Message(computation, 1, receivePort.sendPort));
  // дожидаемся ответа
  final result = await receivePort.first;
  print(result);
}

Future<int> computation(int number) async {
  // Представим, что тут сложный код, который мы не хотим выполнять в главном изоляте
  // Например, парсинг большого json
  return number + 1;
}
