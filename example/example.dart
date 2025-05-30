import 'package:randomness/randomness.dart';

void main() {
  double balance = 100;

  int a = randomInt(-100, 201, onResult: (result) => balance += result);

  double b = randomDouble(-100, 200, onResult: (result) => balance += result);

  int c = weighted([100, 100, -100], onResult: (result) => balance += result);

  bool d = weightedBool(
      trueWeight: 2,
      falseWeight: 1,
      onResult: (result) => balance += result == true ? 100 : -100);

  int e = weightedFromMap({100: 2, -100: 1},
      onResult: (result) => balance += result);

  String f = weightedString('ttf',
      onFullResult: (result) => balance += result == 't' ? 100 : -100);

  List<int> g = weightedList(
    [100, 100, -100],
    length: 1,
    onEachValue: (index, value) => balance += value,
  );

  List<int> h = weightedListFromMap(
    {100: 2, -100: 1},
    length: 1,
    onEachValue: (index, value) => balance += value,
  );

  print('Results:\n$a\n$b\n$c\n$d\n$e\n$f\n$g\n$h');
  print('Final balance: $balance');
}
