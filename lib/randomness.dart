library randomness;

import 'dart:core';
import 'dart:math';
import 'package:randomness/asciiCodes.dart';

const int asciiZero = 48;
const int asciiNine = 57;

const asciiStart = 33;
const asciiEnd = 126;
const uppercaseStart = 65;
const uppercaseEnd = 90;
const lowercaseStart = 97;
const lowercaseEnd = 122;
const String everythingElse = 'everythingElse';

String asciiChar(int c) {
  return String.fromCharCode(c);
}

class Randomness {
  static int randomInt({
    bool cryptographicallySecure = false,
    Set include = const {
      [1, 1000]
    },
    Set exclude = const {},
    Map<dynamic, int> weights = const {},
  }) {
    Random r;
    if (cryptographicallySecure) {
      r = Random.secure();
    } else {
      r = Random();
    }
    List candidates = [];
    for (var v in include) {
      if (v is int) {
        candidates.add(v);
      }
      if (v is List) {
        for (int i = v[0]; i <= v[1]; i++) {
          candidates.add(i);
        }
      }
    }
    candidates = candidates.toSet().toList();
    for (var v in exclude) {
      if (v is int) {
        candidates.remove(v);
      }
      if (v is List) {
        for (int i = v[0]; i <= v[1]; i++) {
          candidates.remove(i);
        }
      }
    }

    return randomFromList(
      candidates,
      cryptographicallySecure: cryptographicallySecure,
      weights: weights,
    );
  }

  static String randomString({
    int length = 10,
    bool cryptographicallySecure = false,
    bool excludeUppercase = false,
    bool excludeLowercase = false,
    bool excludeNumbers = false,
    bool excludeSymbols = false,
    List<String> exclude = const [],
    bool includeSpaces = false,
    Map<String, int> weights = const {},
  }) {
    Random r;
    if (cryptographicallySecure) {
      r = Random.secure();
    } else {
      r = Random();
    }
    String temp = '';
    if (length < 1) {
      return temp;
    }
    List<int> candidateAscii = [];
    for (int i = includeSpaces ? asciiStart - 1 : asciiStart;
        i <= asciiEnd;
        i++) {
      candidateAscii.add(i);
    }
    if (excludeUppercase) {
      for (int i = uppercaseStart; i <= uppercaseEnd; i++) {
        candidateAscii.remove(i);
      }
    }
    if (excludeLowercase) {
      for (int i = lowercaseStart; i <= lowercaseEnd; i++) {
        candidateAscii.remove(i);
      }
    }
    if (excludeNumbers) {
      for (int i = asciiZero; i <= asciiNine; i++) {
        candidateAscii.remove(i);
      }
    }

    if (excludeSymbols) {
      List<int> symbolsAscii = [];
      for (int i = asciiStart; i <= asciiEnd; i++) {
        if (!(i >= uppercaseStart && i <= uppercaseEnd) &&
            !(i >= lowercaseStart && i <= lowercaseEnd) &&
            !(i >= asciiZero && i <= asciiNine)) {
          symbolsAscii.add(i);
        }
      }
      for (int i in symbolsAscii) {
        candidateAscii.remove(i);
      }
    }

    for (String s in exclude) {
      candidateAscii.remove(getAsciiCode(s));
    }

    Map<dynamic, int> weightsCopy = {};
    for (var v in weights.keys) {
      if (v != everythingElse) {
        weightsCopy.addAll({getAsciiCode(v): weights[v]!});
      } else {
        weightsCopy.addAll({v: weights[v]!});
      }
    }
    for (int i in getRange([1, length])) {
      temp += asciiChar(randomFromList(candidateAscii,
          cryptographicallySecure: cryptographicallySecure,
          weights: weightsCopy));
    }
    return temp;
  }

  static String randomNDigits({
    int numberOfDigits = 1,
    bool cryptographicallySecure = false,
    Set excludeDigits = const {},
    Map<dynamic, int> weights = const {},
  }) {
    String answer = '';
    if (numberOfDigits < 1) {
      return answer;
    }
    for (int i in getRange([1, numberOfDigits])) {
      answer += randomFromList(getRange([0, 9]),
              exclude: excludeDigits.toList(),
              cryptographicallySecure: cryptographicallySecure,
              weights: weights)
          .toString();
    }

    return answer;
  }

  static double randomDouble({
    cryptographicallySecure = false,
    int min = 0,
    int max = 1,
  }) {
    if (!(max > min)) {
      throw Exception('max not greater than min');
    }
    Random r;
    if (cryptographicallySecure) {
      r = Random.secure();
    } else {
      r = Random();
    }
    return r.nextDouble() * (max - min) + min;
  }

  static dynamic randomFromList(
    List items, {
    List exclude = const [],
    bool cryptographicallySecure = false,
    Map<dynamic, int> weights = const {}, //Map<index, weight>
  }) {
    Random r;
    if (cryptographicallySecure) {
      r = Random.secure();
    } else {
      r = Random();
    }

    List itemsCopy = listCopy(items);
    for (var e in exclude) {
      itemsCopy.remove(e);
    }

    if (weights.isEmpty) {
      return itemsCopy[r.nextInt(itemsCopy.length)];
    } else {
      List candidateItems = [];
      for (var key in weights.keys) {
        if (itemsCopy.contains(key) || key == everythingElse) {
          for (var w = 0; w < weights[key]!; w++) {
            candidateItems.add(key);
          }
        }
      }

      var draw = randomFromList(candidateItems,
          cryptographicallySecure: cryptographicallySecure);
      if (draw != everythingElse) {
        return draw;
      } else {
        List everythingElseCandidates = [];
        for (var i in itemsCopy) {
          if (!weights.keys.contains(i)) {
            everythingElseCandidates.add(i);
          }
        }
        return randomFromList(everythingElseCandidates,
            cryptographicallySecure: cryptographicallySecure);
      }
    }
  }
}

Map countElementsInList(List l, {bool includeIndexes = false}) {
  Map elementsSoFar = {};
  bool allNums = true;
  //{e: {'type': , 'count': , 'indexes': }}
  inputList:
  for (int i = 0; i < l.length; i++) {
    var currentElement = l[i];
    bool included = false;
    for (var e in elementsSoFar.keys) {
      //if e is Set, use setEquals
      if (currentElement.runtimeType.toString().contains('Set') &&
          currentElement.runtimeType.toString() ==
              elementsSoFar[e]['type'].toString() &&
          setEquals(currentElement, e)) {
        allNums = false;
        elementsSoFar[e]['count']++;
        if (includeIndexes) {
          elementsSoFar[e]['indexes'].add(i);
        }
        continue inputList;
      } else {
        if (currentElement.toString() == e &&
            currentElement.runtimeType == elementsSoFar[e]['type']) {
          elementsSoFar[e]['count']++;
          if (includeIndexes) {
            elementsSoFar[e]['indexes'].add(i);
          }
          continue inputList;
        }
      } //non-Sets

    }

    //if not found
    elementsSoFar.addAll({
      currentElement.runtimeType.toString().contains('Set')
          ? currentElement
          : currentElement.toString(): {
        'type': currentElement.runtimeType,
        'count': 1,
      }
    });
    if (includeIndexes) {
      elementsSoFar[currentElement.toString()].addAll({
        'indexes': [i]
      });
    }
    if (currentElement is! num) {
      allNums = false;
    }
  }

  //sort numbers
  if (allNums) {
    List<num> numElements = [];
    for (String s in elementsSoFar.keys) {
      if (s.contains('.')) {
        numElements.add(double.parse(s));
      } else {
        numElements.add(int.parse(s));
      }
    }
    numElements.sort();
    Map newElements = {};
    numElements
        .map((e) =>
            newElements.addAll({e.toString(): elementsSoFar[e.toString()]}))
        .toList();
    return newElements;
  } else {}
  return elementsSoFar;
}

bool setEquals<T>(Set<T>? a, Set<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (final T value in a) {
    if (!b.contains(value)) {
      return false;
    }
  }
  return true;
}

List<int> getRange(
  List<int> l, {
  int startIndex = 0,
  int endIndex = 1,
}) {
  List<int> range = [];
  for (int i = l[startIndex]; i <= l[endIndex]; i++) {
    range.add(i);
  }
  return range;
}

List listCopy(List l) {
  List temp = [];
  for (var v in l) {
    temp.add(v);
  }
  return temp;
}

List<dynamic> shuffleList(List list, {cryptographicallySecure = false}) {
  List listCopy = list;
  Random r;
  if (cryptographicallySecure) {
    r = Random.secure();
  } else {
    r = Random();
  }

  int count = list.length;
  while (count > 0) {
    int index = r.nextInt(count);
    listCopy.add(listCopy[index]);
    listCopy.removeAt(index);
    count--;
  }

  return listCopy;
}

void printMapElements(Map m) {
  for (var v in m.keys) {
    print('$v: ${m[v]}');
  }
}

void printListElements(List l) {
  for (var v in l) {
    print(v);
  }
}
