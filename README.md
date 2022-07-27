# randomness
Dart package for random strings and numbers, with weights

Random strings, numbers. RNG with weights. Cryptographically secure options.

## Getting started
Add ```randomness: ^0.1.0``` to pubspec.yaml and paste
```import 'package:randomness/randomness.dart';```

## Usage
### Random Numbers
The following are equivalent to ```Random().nextInt(5)```. The Sets ```include``` and ```exclude``` can have points, or intervals with square brackets.
```dart
Randomness.randomInt(include: {0,1,2,3,4})
Randomness.randomInt(include: {[0,4]})
Randomness.randomInt(include: {0,1,[2,4]})
Randomness.randomInt(include: {[0,100]}, exclude: {5,[6,100]})
```

default is 1 to 1000 inclusive:
```dart
Randomness.randomInt()
//681
```

### Cryptographically secure

1 through 100 inclusive, cryptographically secure:
```dart
Randomness.randomInt(include: {[1,100]}, cryptographicallySecure: true)
//30
```

random double, cryptographically secure:
```dart
Randomness.randomDouble(min: -3, max: -1, cryptographicallySecure: true)
//-1.7392379311552753
```

### Weighted probability
Give weights. 2/3 chance of 0, 1/3 chance of 1, 2, 3, or 4:
```dart
Randomness.randomInt(include: {0,1,2,3,4}, weights: {0: 2, everythingElse: 1})
```

Ignores included elements not in weights. This will always give 0:
```dart
Randomness.randomInt(include: {0,1,2,3,4}, weights: {0:1})
```




### Random Strings


Default length is 10. Default doesn't generate spaces:
```dart
Randomness.randomString()
/*
-((f)4$=r4
*/
```

Strings include numbers, uppercase, lowercase, symbols, and spaces. This will generate numbers and spaces.
```dart
Randomness.randomString(length: 100, includeSpaces: true, excludeSymbols: true, excludeUppercase: true, excludeLowercase: true)
//3828 5491 304 0065273406 9 54745452 657207928  4469 078258338317555697369931555479 28159170 32561895
```

cryptographically secure String with half A's:
```dart
Randomness.randomString(length: 50, cryptographicallySecure: true, weights: {'A': 1, everythingElse: 1})
//ACAAAAAABAAAp3litAAAAAAwAAAAAAl$AEe4IAAtAA*A#)AA6[
```




random element from List, weights may not work with certain data types.
```dart
Randomness.randomFromList([{1,2}, 'a', 3], weights: {'a': 1, everythingElse: 1}, cryptographicallySecure: true)
//a
```


Random n-digit number. Returns a String since parsing would ignore
0's at the beginning, and cannot parse very large integers.
The following gives average of half 4's, half 5, 6, 7, 8, or 9:
```dart
Randomness.randomNDigits(numberOfDigits: 100, excludeDigits: {0,1,2,3}, weights: {4:1, everythingElse:1})
//4944445978444496449444486964474547474444767454648456444448886854446774444444648654448475857444494895
```




### Some helper functions


Returns Map of occurrences of elements in a List:
```dart
countElementsInList([1, 2, 3, 1.0, 1])
//{1: {type: int, count: 2}, 1.0: {type: double, count: 1}, 2: {type: int, count: 1}, 3: {type: int, count: 1}}
countElementsInList([1, 2, 3, 1.0, 1], includeIndexes: true)
//{1: {type: int, count: 2, indexes: [0, 4]}, 1.0: {type: double, count: 1, indexes: [3]}, 2: {type: int, count: 1, indexes: [1]}, 3: {type: int, count: 1, indexes: [2]}}
```

Returns a List of all elements in a given range inclusive:
```dart
getRange([1,10])
//[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

Returns shuffled List, cryptographically secure option:
```dart
shuffleList([1, 2, 3, 1.0, 1], cryptographicallySecure: true)
//[3, 2, 1.0, 1, 1]
```


printMapElements or printListElements for each element on new line

printMapElements:
```dart
List randomNums = [];
for(int i = 0; i < 100; i++){
randomNums.add(Randomness.randomInt(include: {0,1,2,3}, weights: {0:7, 1:1, 2:1, 3:1}));
}
Map results = countElementsInList(randomNums);
printMapElements(results);
/*
0: {type: int, count: 68}
1: {type: int, count: 14}
2: {type: int, count: 13}
3: {type: int, count: 5}
* */
```

printListElements:
```dart
printListElements([1,2,3]);
/*
1
2
3
*/
```


