import 'dart:async';
import 'dart:isolate';

// сообщение, которое будет переданно в другой изолят
class Message {
  // функция, которая будет выполнена в другом изоляте
  final FutureOr<int> Function(int) computation;
  // аргументы, с которыми выполнится computation
  final int inputArgument;
  // в этот SendPort вернется ответ после выполнения computation
  final SendPort sendPort;

  Message(
    this.computation,
    this.inputArgument,
    this.sendPort,
  );
}
