Random number generator with or without weights.

Random bool, String, double, or other data types.

## randomInt

Similar to ```Random().nextInt``` but can add a lower bound.

Random int that is >= -3 and < 2:
```dart
int i = randomInt(-3, 2);
```

All functions can pass a particular ```Random``` object. ```onResult``` callback executes after the number is generated:

```dart
int balance = 100;

int gamble = randomInt(
  -100,
  101,
  random: Random.secure(),
  onResult: (result) {
    balance += result;
    print('Random int: $result');
    print('Current balance: $balance');
  },
);

// Random int: -5
// Current balance: 95
```

## randomDouble
```dart
double n = randomDouble(-3, -2);

double n2 = randomDouble(
  -3,
  -2,
  random: Random(1), // always the same answer since seed is given
  onResult: (result) {
    print(result);
  },
);
// -2.4214987135587918
```

## weighted, weightedList

```weighted``` returns a random element from an iterable, so elements are weighted by how many occurrences of each element:
```dart
// 3/4 chance of 1, 1/4 chance of 2
int i = weighted([1, 1, 1, 2]);

// toSet() gets rid of duplicates, so now it's 50-50
int j = weighted([1, 1, 1, 2].toSet());

int k = weighted(
  [1, 1, 1, 2],
  random: Random.secure(),
  onResult: (result) => print('Result is $result'),
);
// Result is 1
```

```weightedList``` can specify length to return a List.

(```onEachValue``` is called after generating each value, ```onFullResult``` is called once after generating the List.)

```dart
List<int> l = weightedList([1, 1, 2], length: 10);
// Example result: [1, 1, 1, 1, 2, 1, 1, 1, 1, 2]

List<String> l2 = weightedList(
  ['hello', 'world'],
  length: 5,
  random: Random.secure(),
  onEachValue: (index, value) => print("You got '$value' at index $index"),
  onFullResult: (result) => print(result),
);

/*
You got 'world' at index 0
You got 'hello' at index 1
You got 'world' at index 2
You got 'hello' at index 3
You got 'hello' at index 4
[world, hello, world, hello, hello]
*/
```

The [heart](https://pub.dev/packages/heart) package can be used to generate lists to use as arguments:
```dart
// Same as weightedList([0, 2,..., 98, 0, 2,..., 98, 1, 3,..., 99]);
List<int> l = weightedList(range(0, 100, 2) * 2 + range(1, 100, 2), length: 20);

// [10, 35, 67, 82, 2, 9, 98, 53, 72, 98, 74, 19, 73, 4, 38, 85, 53, 34, 64, 94]

```

## weightedFromMap, weightedListFromMap

Weights can be given as values in a Map.

```weightedFromMap``` returns one value:

```dart
// 1/3 chance of 0, 2/3 chance of 1
int i = weightedFromMap({0: 1, 1: 2});

// 4/9 chance of 0, 1, or 2; 5/9 chance of 3, 4, or 5
int j = weightedFromMap({randomInt(0, 3): 4, randomInt(3, 6): 5});

// This will return 'hello' since 'world' has 0 weight
String s = weightedFromMap(
  {'hello': 1, 'world': 0},
  random: Random.secure(),
  onResult: (result) {
    print(result);
  },
);
```

```weightedListFromMap``` can specify length to return a List:

```dart
int balance = 0;

List<int> l = weightedListFromMap(
  {1: 2, -1: 1},
  length: 5,
  random: Random.secure(),
  onEachValue: (index, value) {
    print('You got $value at index $index');
    balance += value;
  },
  onFullResult: (result) => print('Final balance after $result is: $balance'),
);

/*
You got 1 at index 0
You got 1 at index 1
You got -1 at index 2
You got 1 at index 3
You got -1 at index 4
Final balance after [1, 1, -1, 1, -1] is: 1
*/
```

### weightedBool

With no arguments, it gives 50/50 odds:
```dart
bool b = weightedBool();
```

With optional arguments:
```dart
int balance = 100;

// 3/5 chance of true
bool b = weightedBool(
  trueWeight: 3,
  falseWeight: 2,
  random: Random.secure(),
  onTrue: () => balance += 100,
  onFalse: () => balance -= 100,
  onResult: (result) => print('Result: $result\nBalance: $balance'),
);

/*
Result: true
Balance: 200
*/
```

### weightedString

Returns a random String from the characters in a given String. Weights are given by number of occurrences in the given String.

```dart
// 3/4 chance of 'á', 1/4 chance of 'é'
String s = weightedString('áááé'); // 'á', default length is 1
String s2 = weightedString('áéíóú', length: 10); // óáéóéáóíúí
```

Constants are given to help generate random Strings:
```dart
const kPrintableCharacters =
    ' !"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
const kPrintableCharactersWithoutSpace =
    '!"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
const kDigits = '0123456789';
const kUppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const kLowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
const kLetters = kUppercaseLetters + kLowercaseLetters;
const kAlphanumeric = kLetters + kDigits;
```

```dart
String s = weightedString(
  kPrintableCharacters,
  length: 5,
  random: Random.secure(),
  onEachCharacter: (index, c) => print('$c at index $index'),
  onFullResult: (result) => print(result),
);

/*
x at index 0
w at index 1
- at index 2
l at index 3
j at index 4
xw-lj
*/
```