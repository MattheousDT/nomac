import 'dart:math';

extension NomacListExtension<T> on List<T> {
  T random() {
    final _random = Random();
    return this[_random.nextInt(length)];
  }
}
