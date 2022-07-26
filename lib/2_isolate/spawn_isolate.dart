import 'dart:isolate';

import 'message.dart';

Future<SendPort> spawnIsolate() async {
  // ReceivePort позволяет общаться между изолятами
  // у него есть getter sendPort, в который можно передавать сообщения,
  // а ReceivePort будет их принимать
  final receivePort = ReceivePort();
  Isolate.spawn(isolateEntrypoint, receivePort.sendPort);
  // этот SendPort мы получили из другого изолята
  // сообщения, которые мы в него передадим, поймает ReceivePort созданный
  // в функции isolateEntrypoint
  final sendPort = await receivePort.first;
  return sendPort as SendPort;
}

// эта функция будет выполнена в другом изоляте
void isolateEntrypoint(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) async {
    if (message is Message) {
      final sendPort = message.sendPort;
      final function = message.computation;
      final argument = message.inputArgument;
      // выполняем функцию, которую нам передали в обьекте Message,
      // и передаем её в SendPort, который нам так же передали в обьекте Message
      final result = await function(argument);
      sendPort.send(result);
    }
  });
}
