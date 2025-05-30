import 'dart:core';
import 'dart:math';

/// Random integer between [min], inclusive and [max], exclusive.
/// ```dart
/// int i = randomInt(-3, 5);
/// ```
///
/// If a Random object is not passed, a new Random() will be created.
/// Optional [onResult] callback runs after value is attained.
/// ```dart
/// int i = randomInt(
///   -3,
///   5,
///   random: Random.secure(),
///   onResult: (result) {
///     print('Random int is $result.');
///   },
/// );
/// ```
int randomInt(
  int min,
  int max, {
  Random? random,
  Function(int result)? onResult,
}) {
  if (min >= max) {
    throw ArgumentError("Min must be less than max.");
  }

  int result = 0;
  random ??= Random();
  result = random.nextInt(max - min) + min;

  if (onResult != null) {
    onResult(result);
  }

  return result;
}

/// Returns a random double between [min], inclusive and [max], exclusive.
/// ```dart
/// double n = randomDouble(-3, 5);
/// ```
///
/// If a Random object is not passed, a new Random() will be created.
/// Optional [onResult] callback runs after value is attained.
///
/// The following example should always return the same value
/// since Random seed is given:
/// ```dart
/// double n = randomDouble(
///     -1,
///     1,
///     random: Random(100),
///     onResult: (result) {
///       print('Random double is $result.');
///     },
///   );
/// ```
double randomDouble(
  double min,
  double max, {
  Random? random,
  Function(double result)? onResult,
}) {
  if (min > max) {
    throw ArgumentError("Min cannot be greater than max.");
  }

  double result = 0;
  random ??= Random();

  if (min == max) {
    result = min;
  } else {
    result = (max - min) * random.nextDouble() + min;
  }

  if (onResult != null) {
    onResult(result);
  }

  return result;
}

/// Returns a random element from an iterable.
/// The result is weighted by how many times the element
/// occurs.
///
/// weighted([0, 0, 3]) will return 0 with probability 2/3,
/// and 3 with probability 1/3.
///
/// Can return elements of any type.
/// If a Random object is not passed, a new Random() will be created.
/// Optional [onResult] callback runs after value is attained.
///
/// The following returns one of two lists and prints the result:
/// ```dart
/// List<int> l = weighted(
///     [
///       [0, 1],
///       [1, 2],
///     ],
///     random: Random.secure(),
///     onResult: (result) {
///       print('Random list: $result.');
///     },
///   );
/// ```
T weighted<T>(
  Iterable<T> include, {
  Random? random,
  Function(T value)? onResult,
}) {
  if (include.isEmpty) {
    throw ArgumentError("No elements to choose from.");
  }

  List<T> includeCopy = List.from(include);
  includeCopy.shuffle(random);
  T result = includeCopy.first;

  if (onResult != null) {
    onResult(result);
  }

  return result;
}

/// Returns a random boolean.
/// weightedBool() with no arguments returns true or false with
/// equal probability.
///
/// If a Random object is not passed, a new Random() will be created.
/// Optional [trueWeight] and [falseWeight] default to 1 each.
/// Optional [onTrue] and [onFalse] are run if result is
/// true or false, respectively.
/// Optional [onResult] callback runs afterward.
///
/// The following returns true with probability 2/3,
/// false with probability 1/3.
/// ```dart
/// int balance = 100;
/// bool b = weightedBool(
///   trueWeight: 2,
///   falseWeight: 1,
///   random: Random.secure(),
///   onTrue: () => balance += 100,
///   onFalse: () => balance -= 100,
///   onResult: (result) => print('Result: $result\nBalance: $balance'),
/// );
/// ```
bool weightedBool({
  int trueWeight = 1,
  int falseWeight = 1,
  Random? random,
  Function()? onTrue,
  Function()? onFalse,
  Function(bool result)? onResult,
}) {
  if (trueWeight < 0) {
    throw ArgumentError("'trueWeight' cannot be negative.");
  }
  if (falseWeight < 0) {
    throw ArgumentError("'falseWeight' cannot be negative.");
  }

  if (trueWeight == 0 && falseWeight == 0) {
    throw ArgumentError("Weights removed both possibilities.");
  }

  random ??= Random();
  int r = random.nextInt(trueWeight + falseWeight);

  bool result = r < trueWeight ? true : false;

  if (onTrue != null && result == true) {
    onTrue();
  }
  if (onFalse != null && result == false) {
    onFalse();
  }
  if (onResult != null) {
    onResult(result);
  }

  return result;
}

/// Returns a random element from the keys of a map,
/// where the values are the weights.
///
/// weightedFromMap({0: 1, 1: 2}) returns 0 with
/// probability 1/3, 1 with probability 2/3.
///
/// If a Random object is not passed, a new Random() will be created.
/// Optional [onResult] runs after value is attained:
/// ```dart
/// int i = weightedFromMap(
///     {0: 1, 1: 2},
///     random: Random.secure(),
///     onResult: (result) {
///       print('Weighted from map: $result.');
///     },
///   );
/// ```
///
/// The following returns a random integer less than 100 where even
/// numbers are weighted 11, odd numbers weighted 10:
/// ```dart
/// int j = weightedFromMap(
///     {
///       for (int element in List.generate(100, (index) => index))
///         element: element % 2 == 0 ? 11 : 10,
///     },
///     onResult: (result) {
///       print('Weighted int is $result.');
///     },
///   );
/// ```
T weightedFromMap<T>(
  Map<T, int> weights, {
  Random? random,
  Function(T result)? onResult,
}) {
  if (weights.isEmpty) {
    throw ArgumentError("No weights given.");
  }

  T? result;

  int sumWeights = 0;
  for (T key in weights.keys) {
    if (weights[key]! < 0) {
      throw ArgumentError("Weight for $key cannot be negative.");
    }
    if (weights[key]! > 0) {
      sumWeights += weights[key]!;
    }
  }

  if (sumWeights == 0) {
    throw ArgumentError("All weights are 0.");
  }

  random ??= Random();
  int randomWeight = random.nextInt(sumWeights);

  int currentWeight = 0;
  for (T t in weights.keys) {
    if (currentWeight + weights[t]! > randomWeight) {
      result = t;
      break;
    }
    currentWeight += weights[t]!;
  }

  if (onResult != null) {
    onResult(result as T);
  }

  return result as T;
}

/// Constants that can be used for [weightedString]
const kPrintableCharacters =
    ' !"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
const kPrintableCharactersWithoutSpace =
    '!"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
const kDigits = '0123456789';
const kUppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const kLowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
const kLetters = kUppercaseLetters + kLowercaseLetters;
const kAlphanumeric = kLetters + kDigits;

/// Returns random characters from a String.
/// weightedString('hello') returns 'l' with probability 2/5,
/// each other character has probability 1/5.
///
/// Can return more characters if [length] is specified.
/// weightedString('hello', length: 10) returns something like
/// 'loloeleloh'.
///
/// If a Random object is not passed, a new Random() will be created.
/// [onEachCharacter] callback runs for each
/// character in the result.
/// [onFullResult] callback runs after value is attained.
/// ```dart
/// String s = weightedString(
///   kPrintableCharacters,
///   length: 5,
///   random: Random.secure(),
///   onEachCharacter: (index, c) => print('$c at index $index'),
///   onFullResult: (result) => print(result),
/// );
/// ```
/// If Random seed is specified, the same result will be returned
/// every time, but all characters will not necessarily be the same
/// as each other.
///
/// Constants are provided to help generate random strings:
/// [kPrintableCharacters], [kPrintableCharactersWithoutSpace],
/// [kDigits], [kUppercaseLetters], [kLowercaseLetters],
/// [kLetters], [kAlphanumeric]
String weightedString(
  String include, {
  int length = 1,
  Random? random,
  Function(int index, String char)? onEachCharacter,
  Function(String result)? onFullResult,
}) {
  if (length < 0) {
    throw ArgumentError("Length cannot be negative.");
  }

  String result = '';
  if (include.isNotEmpty) {
    random ??= Random();
    int count = 0;

    while (count < length) {
      result += include[random.nextInt(include.length)];
      count++;
    }
  } else {
    result = '';
  }

  if (onEachCharacter != null) {
    for (int i = 0; i < result.length; i++) {
      onEachCharacter(i, result[i]);
    }
  }

  if (onFullResult != null) {
    onFullResult(result);
  }

  return result;
}

/// Uses [weighted] but with an extra
/// [length] parameter to return a List.
///
/// [onEachValue] executes after each value in the result
/// is generated.
/// [onFullResult] executes once after the entire result
/// is generated.
///
/// The following returns a List of 100 elements where
/// each element is 1 (probably 1/3) or 3 (probability 2/3).
/// ```dart
/// List<int> l = weightedList(
///   [1, 3, 3],
///   length: 100,
///   random: Random.secure(),
///   onEachValue: (index, value) => print('You got $value at index $index'),
///   onFullResult: (result) => print(result),
/// );
/// ```
///
/// Passing a Random with a seed will yield the same result every time,
/// but each element will not necessarily be equal to each other.
List<T> weightedList<T>(
  Iterable<T> include, {
  Random? random,
  int length = 1,
  Function(int index, T value)? onEachValue,
  Function(List<T> result)? onFullResult,
}) {
  List<T> result = [];
  if (include.isEmpty || length == 0) {
    result = [];
  } else if (length < 0) {
    throw ArgumentError("Length cannot be negative.");
  } else {
    for (int i = 0; i < length; i++) {
      T current = weighted(include, random: random);
      result.add(current);
      if (onEachValue != null) {
        onEachValue(i, current);
      }
    }
  }

  if (onFullResult != null) {
    onFullResult(result);
  }

  return result;
}

/// Uses [weightedFromMap] but with [length] parameter
/// to return a List.
///
/// [onEachValue] executes after each value in the result
/// is generated.
/// [onFullResult] executes once after the entire result
/// is generated.
///
/// The following returns a List of 100 elements, each
/// element is 1 (probability 2/3) or 3 (probability 1/3):
/// ```dart
/// List<int> l = weightedListFromMap(
///   {1: 2, 3: 1},
///   length: 100,
///   random: Random.secure(),
///   onEachValue: (index, value) => print('You got $value at index $index'),
///   onFullResult: (result) => print(result),
/// );
/// ```
///
/// Passing a Random with a seed will yield the same List every time,
/// but each element will not necessarily be equal to each other.
List<T> weightedListFromMap<T>(
  Map<T, int> weights, {
  Random? random,
  int length = 1,
  Function(int index, T value)? onEachValue,
  Function(List<T> result)? onFullResult,
}) {
  List<T> result = [];
  if (length == 0 || weights.isEmpty) {
    result = [];
  } else if (length < 0) {
    throw ArgumentError("Length cannot be negative.");
  } else {
    int sumWeights = 0;
    for (T t in weights.keys) {
      if (weights[t]! < 0) {
        throw ArgumentError("Element '$t' cannot have negative weight.");
      }
      sumWeights += weights[t]!;
    }

    if (sumWeights == 0) {
      result = [];
    } else {
      for (int i = 0; i < length; i++) {
        T current = weightedFromMap(weights, random: random);
        result.add(current);
        if (onEachValue != null) {
          onEachValue(i, current);
        }
      }
    }
  }

  if (onFullResult != null) {
    onFullResult(result);
  }

  return result;
}
