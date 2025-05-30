/// Helper functions used for extension methods.
/// See heart.dart for more extensive documentation.
library;

import 'dart:math' show min, Random;

import 'package:collection/collection.dart' show DeepCollectionEquality;

/// Increment or decrement Strings, used for ^ operator.
String incrementString(String s, int n) {
  if (s.isEmpty) {
    return '';
  }

  List<int> codes = List.from(s.codeUnits);
  for (int i = 0; i < s.length; i++) {
    codes[i] += n;
  }
  return String.fromCharCodes(codes);
}

/// Insert a String between other Strings and concatenate.
String intercalateString(String sub, Iterable<String> original, [int? count]) {
  List<List<int>> originalCopy = [];
  for (String s in original) {
    originalCopy.add(s.codeUnits);
  }

  List<int> subCopy = sub.codeUnits;

  return chrs(intercalateList(subCopy, originalCopy, count));
}

/// Insert element between other elements and concatenate.
List<T> intercalateList<T>(Iterable<T> sub, Iterable<Iterable<T>> original,
    [int? count]) {
  if (original.length <= 1 || sub.isEmpty || (count != null && count <= 0)) {
    return concatLists(original);
  }

  List<List<T>> originalLists = [];
  for (var v in original) {
    originalLists.add(List.from(v));
  }
  List<T> subCopy = List.from(sub);

  int maxOccurrences =
      min(count ?? originalLists.length - 1, originalLists.length - 1);
  List<T> result = [];
  while (maxOccurrences > 0) {
    result += originalLists.first + subCopy;
    originalLists.removeAt(0);
    maxOccurrences--;
  }

  for (List<T> remaining in originalLists) {
    result += remaining;
  }

  return result;
}

/// Count number of occurrences in an iterable.
int countList<T>(Iterable<T> it, T element) {
  int count = 0;
  for (var v in it) {
    if (deepEquals(v, element)) {
      count++;
    }
  }
  return count;
}

/// Count number of occurrences in a String.
int countString(String sub, String original) {
  return indicesString(original, sub).length;
}

/// Split a String into a List of characters.
List<String> letters(String s, bool keepWhitespace) {
  if (s.isEmpty) {
    return [];
  }
  if (keepWhitespace) {
    return s.split('');
  }

  // ignore whitespace
  return letters((concatStrings(words(s))), true);
}

/// Count characters with or without whitespace.
int letterCount(String original, bool keepWhitespace) {
  return letters(original, keepWhitespace).length;
}

/// Returns a List of Lists by adding one element at a time.
List<List<T>> initsList<T>(Iterable<T> it) {
  if (it.isEmpty) {
    return [[]];
  }
  List<List<T>> result = [[]];
  List<T> l = List.from(it);
  for (int i = 0; i < l.length; i++) {
    result.add(l.sublist(0, i + 1));
  }
  return result;
}

/// Returns a List of Strings by adding one character at a time.
List<String>? initsString(String s) {
  if (s.isEmpty) {
    return [''];
  }

  List<String> result = [''];
  List<int> codes = s.codeUnits;
  for (int i = 0; i < codes.length; i++) {
    result.add(String.fromCharCodes(codes.sublist(0, i + 1)));
  }
  return result;
}

/// Returns last character.
String? lastString(String s) {
  if (s.isEmpty) {
    return null;
  }

  return s.substring(s.length - 1, s.length);
}

/// Returns first element.
T? headList<T>(Iterable<T> it) {
  if (it.isEmpty) {
    return null;
  }
  return it.first!;
}

/// Returns first character.
String? headString(String s) {
  if (s.isEmpty) {
    return null;
  }
  return s.substring(0, 1);
}

/// Returns everything but the first element.
List<T>? tailList<T>(Iterable<T> it) {
  if (it.isEmpty) {
    return null;
  }
  List<T> copy = List.from(it);
  copy.removeAt(0);
  return copy;
}

/// Returns everything but the first character.
String? tailString(String s) {
  if (s.isEmpty) {
    return null;
  }
  List<int> codes = List.from(s.codeUnits);
  codes.removeAt(0);
  return String.fromCharCodes(codes);
}

/// Returns everything but first element.
List<List<T>> tailsList<T>(Iterable<T> l) {
  if (l.isEmpty) {
    return [[]];
  }
  List<List<T>> result = [];
  var copy = List.from(l);
  for (int i = 0; i < l.length; i++) {
    result.add(List.from(copy));
    copy.removeAt(0);
  }

  return result + [[]];
}

/// Returns a list of lists by removing one character
/// at a time.
List<String> tailsString(String s) {
  List<int> codes = List.from(s.codeUnits);
  List<String> result = [];
  for (int i = 0; i < s.length; i++) {
    result.add(String.fromCharCodes(codes));
    codes.removeAt(0);
  }
  return result + [''];
}

/// To compare Strings by code units.
bool greaterThanListNum<num>(Iterable<num> it1, Iterable<num> it2) {
  if (deepEquals(it1, it2)) {
    return false;
  }

  List<num> l1 = List.from(it1);
  List<num> l2 = List.from(it2);
  for (int i = 0; i < min(it1.length, it2.length); i++) {
    if (l1[i] == l2[i]) {
      continue;
    }
    if (double.parse(l1[i].toString()) > double.parse(l2[i].toString())) {
      return true;
    } else {
      return false;
    }
  }
  if (l1.length > l2.length) {
    return true;
  }
  return false;
}

/// For > and < operators for Iterables
bool greaterThanIterable<T>(Iterable<T> it1, Iterable<T> it2) {
  if (!(it1.first is num && it2.first is num) &&
      !(it1.first is String && it2.first is String) &&
      !(it1.first is Iterable && it2.first is Iterable)) {
    return false;
  }

  if (deepEquals(it1, it2)) {
    return false;
  }

  int minLength = min(it1.length, it2.length);
  List<T> l1 = List.from(it1);
  List<T> l2 = List.from(it2);
  for (int i = 0; i < minLength; i++) {
    if (!(l1[i] is num && l2[i] is num) &&
        !(l1[i] is String && l2[i] is String) &&
        !(l1[i] is Iterable && l2[i] is Iterable)) {
      return false;
    }
    if (l1[i] is String && l2[i] is String) {
      if (greaterThanString(l1[i].toString(), l2[i].toString())) {
        return true;
      } else {
        continue;
      }
    }
    if (l1[i] is num && l2[i] is num) {
      if (double.parse(l1[i].toString()) > double.parse(l2[i].toString())) {
        return true;
      } else {
        continue;
      }
    } else {
      if (deepEquals(l1[i] as Iterable, l2[i] as Iterable)) {
        continue;
      } else {
        return greaterThanIterable(l1[i] as Iterable, l2[i] as Iterable);
      }
    }
  }

  return (l1.length > l2.length);
}

/// Compare Strings by code units
bool greaterThanString(String s1, String s2) {
  return greaterThanListNum(s1.codeUnits, s2.codeUnits);
}

/// Compare Strings by code units
bool lessThanString(String s1, String s2) {
  if (s1 == s2) {
    return false;
  } else {
    return !greaterThanString(s1, s2);
  }
}

/// Remove all whitespace from a String
String removeWhitespace(String s) {
  if (s.isEmpty) {
    return '';
  }
  return concatStrings(words(s));
}

/// Split string into two.
List<String> splitAtString(int n, String s) {
  if (n <= 0) {
    return ['', s];
  }
  if (n >= s.length) {
    return [s, ''];
  }
  return [s.substring(0, n), s.substring(n, s.length)];
}

/// Split iterable into two.
List<List<T>> splitAtList<T>(int n, Iterable<T> it) {
  List<T> l = List.from(it);
  if (n <= 0) {
    return [[], l];
  }
  if (n >= l.length) {
    return [l, []];
  }
  return [l.sublist(0, n), l.sublist(n, l.length)];
}

/// Return a shuffled List.
List<T> shuffledList<T>(Iterable<T> it, Random? random) {
  List<T> copy = List.from(it);
  copy.shuffle(random);
  return copy;
}

/// Return a shuffled String.
String shuffledString(String s, Random? random) {
  List<int> codes = List.from(s.codeUnits);
  return String.fromCharCodes(shuffledList(codes, random));
}

/// Join two iterables by taking turns.
List<T> interleaveList<T>(Iterable<T> it1, Iterable<T> it2) {
  List<T> copy1 = List.from(it1);
  List<T> copy2 = List.from(it2);
  List<T> result = [];

  int minLength = min(copy1.length, copy2.length);
  for (int i = 0; i < minLength; i++) {
    result
      ..add(copy1[i])
      ..add(copy2[i]);
  }
  return result += copy1.sublist(minLength) + copy2.sublist(minLength);
}

/// Join two Strings by taking turns.
String interleaveString(String s1, String s2) {
  return String.fromCharCodes(interleaveList(s1.codeUnits, s2.codeUnits));
}

/// Split in half, interleave second half first.
List<T> riffleInList<T>(Iterable<T> it) {
  if (it.isEmpty) {
    return [];
  }
  return interleaveList(it.toList().sublist(it.length ~/ 2),
      it.toList().sublist(0, it.length ~/ 2));
}

/// Split in half, interleave together.
List<T> riffleOutList<T>(Iterable<T> it) {
  if (it.isEmpty) {
    return [];
  }
  return interleaveList(it.toList().sublist(0, (it.length / 2).round()),
      it.toList().sublist((it.length / 2).round()));
}

/// Split in half, interleave second half first.
String riffleInString(String s) {
  if (s.isEmpty) {
    return '';
  }
  return String.fromCharCodes(riffleInList(s.codeUnits));
}

/// Split in half, interleave together.
String riffleOutString(String s) {
  if (s.isEmpty) {
    return '';
  }
  return String.fromCharCodes(riffleOutList(s.codeUnits));
}

/// Group consecutive elements together if they meet criteria.
List<List<T>> groupByList<T>(
    bool Function(T a, T b) groupFunction, Iterable<T> it) {
  List<T> l = List.from(it);
  if (l.isEmpty) {
    return [];
  }
  if (l.length == 1) {
    return [l];
  }
  List<List<T>> groups = [];
  List<T> currentGroup = [l.first];
  for (int i = 1; i < l.length; i++) {
    if (groupFunction(l[i - 1], l[i])) {
      currentGroup.add(l[i]);
      if (i == l.length - 1) {
        groups.add(currentGroup);
      }
    } else {
      groups.add(currentGroup);
      currentGroup = [l[i]];
      if (i == l.length - 1) {
        groups.add(currentGroup);
      }
      continue;
    }
  }
  return groups;
}

/// Group consecutive equal elements together.
List<List<T>> groupList<T>(Iterable<T> it) {
  List<T> l = List.from(it);
  return groupByList((a, b) => deepEquals(a, b), l);
}

/// Group characters together if they meet criteria.
List<String> groupByString(
    bool Function(String a, String b) groupFunction, String s) {
  if (s.isEmpty) {
    return [];
  }
  List<String> groups = [];
  String currentGroup = s.substring(0, 1);
  for (int i = 1; i < s.length; i++) {
    if (groupFunction(s.substring(i - 1, i), s.substring(i, i + 1))) {
      currentGroup += (s.substring(i, i + 1));
      if (i == s.length - 1) {
        groups.add(currentGroup);
      }
    } else {
      groups.add(currentGroup);
      currentGroup = s.substring(i, i + 1);
      if (i == s.length - 1) {
        groups.add(currentGroup);
      }
      continue;
    }
  }
  return groups;
}

/// Group consecutive characters together if they are equal.
List<String> groupString(String s) {
  return groupByString((a, b) => a == b, s);
}

/// Check if characters of a String are uppercase.
bool isUpperCase(String s, bool ignoreSymbols) {
  if (ignoreSymbols) {
    return s.toUpperCase() == s;
  } else {
    if (s.isEmpty) {
      return false;
    }
    for (int i = 0; i < s.length; i++) {
      String current = s.substring(i, i + 1);
      //return false for symbols
      if (current.toUpperCase() == current.toLowerCase()) {
        return false;
      } else if (current != current.toUpperCase()) {
        return false;
      }
    }

    return true;
  }
}

/// Check if characters of a String are lowercase.
bool isLowerCase(String s, bool ignoreSymbols) {
  if (ignoreSymbols) {
    return s.toLowerCase() == s;
  } else {
    if (s.isEmpty) {
      return false;
    }
    for (int i = 0; i < s.length; i++) {
      String current = s.substring(i, i + 1);
      //return false for symbols
      if (current.toUpperCase() == current.toLowerCase()) {
        return false;
      } else if (current != current.toLowerCase()) {
        return false;
      }
    }

    return true;
  }
}

/// Drop first n elements.
List<T> dropList<T>(int n, Iterable<T> l) {
  if (l.isEmpty || n >= l.length) {
    return [];
  }
  if (n <= 0) {
    return l.toList();
  }
  return l.toList().sublist(n);
}

/// Drop first n characters.
String dropString(int n, String s) {
  if (n <= 0) {
    return s;
  }
  if (s.isEmpty || n >= s.length) {
    return '';
  }
  return s.substring(n);
}

/// Drop first n characters that meet criteria.
String dropWhileString(bool Function(String sub) dropFunction, String s) {
  for (int i = 0; i < s.length; i++) {
    if (!dropFunction(s.substring(i, i + 1))) {
      return s.substring(i, s.length);
    }
  }
  return '';
}

/// Drop first n elements that meet criteria.
List<T> dropWhileList<T>(bool Function(T sub) dropFunction, Iterable<T> it) {
  if (it.isEmpty) {
    return [];
  }
  List<T> l = List.from(it);
  for (int i = 0; i < l.length; i++) {
    if (!dropFunction(l[i])) {
      return l.sublist(i, l.length);
    }
  }
  return [];
}

/// Sort string by character codes.
String sortedString(String s) {
  List<int> chars = List.from(s.codeUnits);
  chars.sort();
  return String.fromCharCodes(chars);
}

/// Sort String in descending order.
String reversedSortedString(String s) {
  List<int> chars = List.from(s.codeUnits);
  chars.sort();
  return String.fromCharCodes(chars.reversed);
}

/// Regular sorted list.
List<int> ascendingListInt(Iterable<int> it) {
  List<int> copy = List.from(it);
  copy.sort();
  return copy;
}

/// Regular sorted list.
List<double> ascendingListDouble(Iterable<num> it) {
  List<double> copy = [];
  for (num n in it) {
    copy.add(n.toDouble());
  }
  copy.sort();
  return copy;
}

/// Regular sorted list.
List<String> ascendingListString(Iterable<String> it) {
  List<String> copy = List.from(it);
  copy.sort();
  return copy;
}

/// Reversed sorted list.
List<int> descendingListInt(Iterable<int> it) {
  try {
    return ascendingListInt(it).reversed.toList();
  } catch (e) {
    return it.toList();
  }
}

/// Reversed sorted list.
List<double> descendingListDouble(Iterable<num> it) {
  return ascendingListDouble(it).reversed.toList();
}

/// Reversed sorted list.
List<String> descendingListString(Iterable<String> it) {
  try {
    return ascendingListString(it).reversed.toList();
  } catch (e) {
    return it.toList();
  }
}

/// Sum elements.
sumDouble(Iterable<num> l) {
  double result = 0;

  for (num n in l) {
    result += n;
  }

  return result;
}

/// Sum elements.
sumInt(Iterable<int> l) {
  int result = 0;

  for (int n in l) {
    result += n;
  }

  return result;
}

/// Multiply all elements.
double productDouble(Iterable<num> l) {
  if (l.isEmpty) {
    return 0;
  }
  double result = 1;
  for (num n in l) {
    result *= n;
  }
  return result.toDouble();
}

/// Multiply all elements.
int productInt(Iterable<int> l) {
  if (l.isEmpty) {
    return 0;
  }
  int result = 1;
  for (int n in l) {
    result *= n;
  }
  return result;
}

/// Average (mean) of numbers.
double listAverage(Iterable<num> it) {
  if (it.isEmpty) {
    return 0;
  }
  double result = 0;
  for (num n in it) {
    result += n.toDouble();
  }
  return result / it.length;
}

/// String from average of character codes.
String averageString(String s) {
  return String.fromCharCode(listAverage(s.codeUnits).round());
}

/// Combine Strings into one.
String concatStrings(Iterable<String> l) {
  String result = '';

  for (String s in l) {
    result += s;
  }

  return result;
}

/// Combine lists into one.
List<T> concatLists<T>(Iterable<Iterable<T>> lists) {
  if (lists.isEmpty) {
    return [];
  }
  if (lists.length == 1) {
    return lists.first.toList();
  }
  List<T> result = [];
  for (Iterable<T> l in lists) {
    result += l.toList();
  }
  return result;
}

/// Remove duplicate characters.
String stringNub(String s, String? charactersToNub) {
  if (charactersToNub != null && charactersToNub.isEmpty) {
    return s;
  }
  List<int> copy = s.codeUnits;
  List<int> chars = charactersToNub != null ? charactersToNub.codeUnits : [];
  if (chars.isEmpty) {
    return String.fromCharCodes(s.codeUnits.toSet().toList());
  } else {
    return String.fromCharCodes(listNub(copy, chars));
  }
}

/// Remove duplicate elements.
List<T> listNub<T>(Iterable<T> original, [Iterable<T>? itemsToNub]) {
  if (original.isEmpty) {
    return [];
  }
  List<T> result = [];
  for (var v in original) {
    // Add v if it's not in result, then continue
    if (!deepContains(result, v)) {
      result.add(v);
      continue;
    }
    // v already in result

    // add again if not in the nub list
    if (itemsToNub != null && !deepContains(itemsToNub, v)) {
      result.add(v);
    }
  }

  return result;
}

/// Reversed, return List.
List<T> backwardsList<T>(Iterable<T> l) {
  return l.isEmpty ? [] : l.toList().reversed.toList();
}

/// Reverse a String.
String backwardsString(String s) {
  return s.isEmpty ? '' : String.fromCharCodes(backwardsList(s.codeUnits));
}

/// Convert all elements to Strings.
List<String> toStringList<T>(Iterable<T> l) {
  List<String> result = [];

  for (var v in l) {
    result.add(v.toString());
  }

  return result;
}

/// Decimal form. Used for [words].
const List<int> kWhitespaceCodes = [
  9,
  10,
  11,
  12,
  13,
  32,
  133,
  160,
  5760,
  8192,
  8193,
  8194,
  8195,
  8196,
  8197,
  8198,
  8199,
  8200,
  8201,
  8202,
  8232,
  8233,
  8239,
  8287,
  12288
];

/// Separate a String into a List of words.
List<String> words(String original) {
  if (original.isEmpty ||
      listSubtractAll(original.codeUnits, kWhitespaceCodes).isEmpty) {
    return [];
  }
  if (listIntersect(kWhitespaceCodes, original.codeUnits).isEmpty) {
    return [original];
  }

  List<String> result = [];

  String currentWord = '';
  for (int i = 0; i < original.length; i++) {
    String currentChar = original.substring(i, i + 1);
    int currentCode = original.substring(i, i + 1).codeUnits.first;
    if (!kWhitespaceCodes.contains(currentCode)) {
      currentWord += currentChar;
    } else {
      if (currentWord.isNotEmpty) {
        result.add(currentWord);
        currentWord = '';
      }
      continue;
    }
  }
  //add last word
  if (currentWord.isNotEmpty) {
    result.add(currentWord);
  }

  return result;
}

/// Combines Strings into one with spaces in between.
String unwords(Iterable<String> listOfWords) {
  if (listOfWords.isEmpty) {
    return '';
  }
  String result = '';
  for (String word in listOfWords) {
    result += ('$word ');
  }
  //remove space at the end
  result = result.replaceRange(result.length - 1, result.length, '');
  return result;
}

/// Count number of words separated by whitespace.
int wordCount(String s) {
  return s.isEmpty ? 0 : words(s).length;
}

/// Delete all occurrences, or replace with [to].
List<T> replaceAllList<T>(Iterable<T> it, T from, [T? to]) {
  if (it.isEmpty) {
    return [];
  }
  List<T> result = List.from(it);
  List<int> indicesToReplace = [];

  for (int i = 0; i < result.length; i++) {
    if (deepEquals(result[i], from)) {
      indicesToReplace.add(i);
    }
  }

  for (int i in backwardsList(indicesToReplace)) {
    to == null ? result.removeAt(i) : result[i] = to;
  }

  return result;
}

/// Delete first occurrence, or replace with [to]
List<T> replaceList<T>(Iterable<T> it, bool replaceAll, T from, [dynamic to]) {
  if (it.isEmpty) {
    return [];
  }
  if (to is Iterable && to.isEmpty) {
    return replaceList(it, replaceAll, from);
  }

  if (to != null && to is! List<T> && to is! T) {
    throw ArgumentError('Replacement value must be $T or List<$T>.');
  }

  List<int> indicesToReplace = [];
  List<T> copy = List.from(it);
  for (int i = 0; i < it.length; i++) {
    if (deepEquals(copy[i], from)) {
      indicesToReplace.add(i);
      if (!replaceAll) {
        break;
      }
    }
  }

  if (to is Iterable<T>) {
    List<T> result = List.from(it);
    for (int i in backwardsList(indicesToReplace)) {
      result.removeAt(i);
      for (T j in backwardsList(to)) {
        result.insert(i, j);
      }
    }

    return result;
  }

  List<T> result = List.from(it);
  for (int i in backwardsList(indicesToReplace)) {
    to == null ? result.removeAt(i) : result[i] = to;
  }

  return result;
}

/// Get new characters from [input].
String unionString(String original, String input) {
  return String.fromCharCodes(unionList(original.codeUnits, input.codeUnits));
}

/// Get new elements from [input]
List<T> unionList<T>(Iterable<T> original, Iterable<T> input) {
  List<T> l1 = List.from(original);
  List<T> l2 = List.from(input);
  List<T> result = List.from(l1);
  for (T element in l2) {
    if (!result.contains(element)) {
      result.add(element);
    }
  }

  return result;
}

/// Keep only characters from [input]
String stringIntersection(String original, String input) {
  return String.fromCharCodes(
      listIntersect(original.codeUnits, input.codeUnits));
}

/// Keep only elements from [input]
List<T> listIntersect<T>(Iterable<T> original, Iterable<T> input) {
  List<T> l1 = List.from(original);
  List<T> l2 = List.from(input);
  List<T> result = [];
  for (T v in l1) {
    if (deepContains(l2, v)) {
      result.add(v);
    }
  }
  return result;
}

/// Generate a List of integers
///
/// Deprecated because [nums] with one argument does not include
/// that number in the result, but multiple arguments is inclusive,
/// so it might be confusing.
///
/// Use [range] or [inclusive] instead.
@Deprecated("Use 'range' or 'inclusive instead of 'nums'")
List<int> nums(int a, [int? b, int? step]) {
  // if step==null
  List<int> numList(int a, [int? b]) {
    if (b != null) {
      if (b >= a) {
        return List.generate(b - a + 1, (index) => index + a);
      } else {
        return List.generate(a - b + 1, (index) => index + b).reversed.toList();
      }
    } else {
      if (a < 0) {
        return List.generate(-a, (index) => -index).reversed.toList();
      } else {
        return List.generate(a, (index) => index);
      }
    }
  }

  if (b == null && step == null) {
    return (numList(a));
  }
  if (b != null && step == null) {
    return numList(a, b);
  } else {
    if (step! <= 0) {
      throw ArgumentError('step must be greater than 0');
    }

    List<int> result = [];
    if (b! >= a) {
      for (int i = a; i <= b; i += step) {
        result.add(i);
      }
    } else {
      for (int i = a; i >= b; i -= step) {
        result.add(i);
      }
    }
    return result;
  }
}

/// Range of integers
List<int> range(int a, [int? b, int? step]) {
  // Only one argument given
  if (b == null) {
    return a >= 0
        ? List.generate(a, (index) => index)
        : List.generate(-a, (index) => index + a + 1);
  }

  List<int> result = [];

  // Multiple arguments
  if (a < b) {
    if (step != null && step <= 0) {
      throw ArgumentError('step must be positive if beginning < end');
    }
    for (int i = a; i < b; i += step ?? 1) {
      result.add(i);
    }
    return result;
  }
  if (a > b) {
    if (step != null && step >= 0) {
      throw ArgumentError('step must be negative if beginning > end');
    }
    for (int i = a; i > b; i += step ?? -1) {
      result.add(i);
    }
    return result;
  }

  // a = b
  return [];
}

/// Inclusive range of integers
List<int> inclusive(int a, [int? b, int? step]) {
  // Only one argument
  if (b == null) {
    return a >= 0
        ? List.generate(a + 1, (index) => index)
        : List.generate(-a + 1, (index) => index + a);
  }

  // Avoid ArgumentError when a = b
  if (a == b) {
    return [a];
  }

  List<int> result = [];
  if (a < b) {
    if (step != null && step <= 0) {
      throw ArgumentError('step must be positive if beginning < end');
    }
    for (int i = a; i <= b; i += step ?? 1) {
      result.add(i);
    }
    return result;
  }
  if (a > b) {
    if (step != null && step >= 0) {
      throw ArgumentError('step must be negative if beginning > end');
    }
    for (int i = a; i >= b; i += step ?? -1) {
      result.add(i);
    }
    return result;
  }

  return result;
}

/// Uses [range] and character codes.
String rangeString(String a, [String? b, int? step]) {
  if (a.length != 1 || (b != null && b.length != 1)) {
    throw ArgumentError('Strings must have exactly 1 character');
  }

  return chrs(range(a.codeUnits.first, b?.codeUnits.first, step));
}

/// Uses [inclusive] and character codes.
String inclusiveString(String a, [String? b, int? step]) {
  if (a.length != 1 || (b != null && b.length != 1)) {
    throw ArgumentError('Strings must have exactly 1 character');
  }

  return chrs(inclusive(a.codeUnits.first, b?.codeUnits.first, step));
}

/// Check if any characters meet criteria
bool stringAny(bool Function(String sub) anyFunction, String s) {
  if (s.isEmpty) {
    return false;
  }
  for (int i in s.codeUnits) {
    if (anyFunction(String.fromCharCode(i))) {
      return true;
    }
  }
  return false;
}

/// Check if every character meets criteria
bool stringEvery(bool Function(String element) allFunction, String s) {
  if (s.isEmpty) {
    return false;
  }
  for (int i in s.codeUnits) {
    if (!allFunction(String.fromCharCode(i))) {
      return false;
    }
  }
  return true;
}

/// Only keep characters that meet criteria
String filterString(bool Function(String sub) filterFunction, String original) {
  if (original.isEmpty) {
    return '';
  }
  List<String> copy = letters(original, true);
  for (String letter in listNub(letters(original, true))) {
    if (!filterFunction(letter)) {
      copy.removeWhere((element) => element == letter);
    }
  }

  return concatStrings(copy);
}

/// Only keep elements that meet criteria
List<T> filterList<T>(
    bool Function(T sub) filterFunction, Iterable<T> original) {
  if (original.isEmpty) {
    return [];
  }

  List<T> copy = List.from(original);
  for (T v in listNub(original)) {
    if (!filterFunction(v)) {
      copy.removeWhere((element) => element == v);
    }
  }

  return copy;
}

/// Get character from character code
String chr(int code) {
  return String.fromCharCode(code);
}

/// Get a String from character codes
String chrs(Iterable<int> characterCodes) {
  return String.fromCharCodes(characterCodes);
}

/// Insert an element between other elements
List<T> intersperseList<T>(T v, Iterable<T> it) {
  List<T> l = List.from(it);
  if (l.length <= 1) {
    return l;
  }

  List<T> result = [l.first];
  for (int i = 1; i < l.length; i++) {
    result
      ..add(v)
      ..add(l[i]);
  }

  return result;
}

/// Insert character between other characters
String intersperseString(String i, String original) {
  if (original.length <= 1) {
    return original;
  }

  return intercalateString(i, letters(original, true));
}

/// Subtract characters one at at ime from [charsToDelete]
String stringSubtract(String original, String charsToDelete) {
  if (original.isEmpty) {
    return '';
  }
  if (charsToDelete.isEmpty) {
    return original;
  }

  List<int> originalCodes = original.codeUnits;
  List<int> deleteCodes = charsToDelete.codeUnits;
  return String.fromCharCodes(
    listSubtract(originalCodes, deleteCodes),
  );
}

/// Subtract all characters that are in [charsToDelete]
String stringSubtractAll(String original, String charsToDelete) {
  if (original.isEmpty) {
    return '';
  }
  if (charsToDelete.isEmpty) {
    return original;
  }

  List<int> originalCodes = original.codeUnits;
  List<int> deleteCodes = charsToDelete.codeUnits;
  return String.fromCharCodes(
    listSubtractAll(originalCodes, deleteCodes),
  );
}

/// Subtract elements one at a time
List<T> listSubtract<T>(Iterable<T> original, Iterable<T> sublist) {
  List<T> result = List.from(original);

  for (T v in sublist) {
    for (int i = 0; i < List.from(result).length; i++) {
      if (deepEquals(v, result[i])) {
        result.removeAt(i);
        break;
      }
    }
  }

  return result;
}

/// Subtract all elements that are in [sublist]
List<T> listSubtractAll<T>(Iterable<T> original, Iterable<T> sublist) {
  if (original.isEmpty) {
    return [];
  }
  List<T> result = List.from(original);

  for (T v in listNub(sublist)) {
    result.removeWhere((element) => deepEquals(element, v));
  }

  return result;
}

/// List of every index of [sub] in [original]
@Deprecated("Use 'indicesString'")
List<int> elemIndicesString(String sub, String original) {
  if (sub.isEmpty || original.isEmpty) {
    return [];
  }
  List<int> result = [];

  for (int i = 0; i < original.length; i++) {
    if (original.substring(i).startsWith(sub)) {
      result.add(i);
    }
  }

  return result;
}

/// List of every index of [sub] in [original]
List<int> indicesString(String original, String sub, {bool exclusive = false}) {
  return indicesList(original.codeUnits, sub.codeUnits, exclusive: exclusive);
}

/// List of every index of [element] in [original]
@Deprecated("Use 'indicesList'")
List<int> elemIndicesList<T>(T element, Iterable<T> original) {
  List<T> originalCopy = List.from(original);
  List<int> result = [];

  for (int i = 0; i < originalCopy.length; i++) {
    if (deepEquals(originalCopy[i], element)) {
      result.add(i);
    }
  }

  return result;
}

/// Find occurrences of a sublist in a list.
/// 'elemIndicesList' checks for individual elements and not a sublist.
List<int> indicesList<T>(Iterable<T> original, Iterable<T> sublist,
    {bool exclusive = false}) {
  if (sublist.isEmpty) {
    return inclusive(original.length);
  } else if (original.isEmpty) {
    return [];
  }

  List<T> originalCopy = List.from(original);
  List<T> subCopy = List.from(sublist);

  int maxIndex = originalCopy.length - subCopy.length;

  List<int> result = [];

  int currentIndex = 0;
  while (currentIndex <= maxIndex) {
    if (startsWithList(originalCopy.sublist(currentIndex), subCopy)) {
      result.add(currentIndex);
      currentIndex += exclusive ? subCopy.length : 1;
    } else {
      currentIndex++;
    }
  }

  return result;
}

/// Insert an element before the first element that is greater or equal
insertInOrder(num n, Iterable original) {
  bool returnListInt = true;
  if (original is List<num> && original is! List<int>) {
    returnListInt = false;
  } else if (n is! int) {
    returnListInt = false;
  } else {
    for (var v in original) {
      if (v is! int) {
        returnListInt = false;
        break;
      }
    }
  }

  var originalCopy = returnListInt ? <int>[] : <double>[];
  var result = returnListInt ? <int>[] : <double>[];
  if (returnListInt) {
    originalCopy =
        result = original.map((element) => element.toInt() as int).toList();
  } else {
    originalCopy = result =
        original.map((element) => element.toDouble() as double).toList();
  }

  for (int i = 0; i < originalCopy.length; i++) {
    if ((originalCopy[i]) >= n) {
      result.insert(i, returnListInt ? n.toInt() : n.toDouble());
      return returnListInt
          ? result.map((element) => element.toInt()).toList()
          : result.map((element) => element.toDouble()).toList();
    }
  }
  result.add(returnListInt ? n.toInt() : n.toDouble());
  return result;
}

/// Insert a character before the first greater character
String insertInOrderString(String sub, String original) {
  if (sub.isEmpty) {
    return original;
  }
  if (original.isEmpty) {
    return sub;
  }

  List<int> originalCodes = original.codeUnits;
  List<int> subCodes = sub.codeUnits;
  if (subCodes.first <= originalCodes.first) {
    return String.fromCharCodes(subCodes + originalCodes);
  }

  for (int code in original.codeUnits) {
    if (code >= subCodes.first) {
      int index = originalCodes.indexOf(code);
      return String.fromCharCodes(originalCodes.sublist(0, index) +
          subCodes +
          originalCodes.sublist(index));
    }
  }

  return String.fromCharCodes(originalCodes + subCodes);
}

/// Repeat elements of a list [n] times
List<T> cycleList<T>(int n, Iterable<T> it) {
  List<T> l = List.from(it);
  if (n <= 0) {
    return [];
  }

  List<T> result = [];
  for (int j = 0; j < n; j++) {
    for (int i = 0; i < l.length; i++) {
      result.add(l[i]);
    }
  }

  return result;
}

/// Multiply elements together
num productOfElements(Iterable<num> l) {
  num result = 1;
  for (num n in l) {
    result *= n;
  }
  return result;
}

/// Check for equality of multiple data types, including nested iterables.
bool deepEquals(Object? e1, Object? e2) {
  return const DeepCollectionEquality().equals(e1, e2);
}

/// Uses [deepEquals] to check if iterable contains a given element.
bool deepContains(Iterable l, var v) {
  for (var item in l) {
    if (deepEquals(v, item)) {
      return true;
    }
  }

  return false;
}

/// Combine list elements into pairs
List<List<T>> zipList<T>(Iterable<Iterable<T>> it) {
  List<List<T>> result = [];

  int minLength = 0;
  for (Iterable<T> v in it) {
    if (v.isEmpty) {
      return [];
    }

    minLength = minLength == 0 ? v.length : min(minLength, v.length);
  }

  for (int j = 0; j < minLength; j++) {
    List<T> current = [];
    for (int i = 0; i < it.length; i++) {
      current.add(List.from(it.toList()[i])[j]);
    }
    result.add(current);
  }

  return result;
}

/// Combine elements of two iterables into pairs and
/// perform a function between them.
List zip2<T>(Iterable<Iterable<T>> it, dynamic Function(T a, T b) zipFunction) {
  if (it.length != 2) {
    throw ArgumentError('Needs 2 iterables but found ${it.length}');
  }
  List result = [];

  for (var v in zipList(it)) {
    List<T> copy = List.from(v);
    result.add(zipFunction(copy[0], copy[1]));
  }

  return result;
}

/// Combine elements of three iterables into pairs
/// and perform a function between them.
zip3<T>(Iterable<Iterable<T>> it, dynamic Function(T a, T b, T c) zipFunction) {
  if (it.length != 3) {
    throw ArgumentError('Needs 3 iterables but found ${it.length}');
  }
  List result = [];

  for (var v in zipList(it)) {
    List<T> copy = List.from(v);
    result.add(zipFunction(copy[0], copy[1], copy[2]));
  }

  return result;
}

/// Combine elements of four iterables into pairs
/// and perform a function between them.
zip4<T>(Iterable<Iterable<T>> it,
    dynamic Function(T a, T b, T c, T d) zipFunction) {
  if (it.length != 4) {
    throw ArgumentError('Needs 4 iterables but found ${it.length}');
  }
  List result = [];

  for (var v in zipList(it)) {
    List<T> copy = List.from(v);
    result.add(zipFunction(copy[0], copy[1], copy[2], copy[3]));
  }

  return result;
}

/// Get all the characters after a given substring
String? afterString(String original, String sub, [int skip = 0]) {
  List<int>? listResult = afterList(original.codeUnits, sub.codeUnits, skip);
  return listResult == null ? null : chrs(listResult);
}

/// Return elements after a given sublist
List<T>? afterList<T>(Iterable<T> original, Iterable<T> sub, [int skip = 0]) {
  List<T> originalCopy = List.from(original);
  List<T> subCopy = List.from(sub);

  if (skip < 0) {
    return originalCopy;
  }

  int maxOccurrences = originalCopy.length - subCopy.length + 1;
  if ((original.isEmpty && sub.isNotEmpty) || skip >= maxOccurrences) {
    return null;
  }

  if (sub.isEmpty) {
    return originalCopy.sublist(skip);
  }

  int skipCopy = skip;
  for (int currentIndex = 0; currentIndex < maxOccurrences; currentIndex++) {
    if (deepEquals(
        originalCopy.sublist(currentIndex, currentIndex + subCopy.length),
        subCopy)) {
      if (skipCopy == 0) {
        return originalCopy.sublist(currentIndex + subCopy.length);
      } else {
        skipCopy--;
      }
    }
  }

  return null;
}

/// Get all the characters before a substring
String? beforeString(String original, String sub, [int skip = 0]) {
  List<int>? listResult = beforeList(original.codeUnits, sub.codeUnits, skip);
  return listResult == null ? null : chrs(listResult);
}

/// Return elements before a given sublist
List<T>? beforeList<T>(Iterable<T> original, Iterable<T> sub, [int skip = 0]) {
  if (skip < 0) {
    return [];
  }
  if (original.isEmpty && sub.isNotEmpty) {
    return null;
  }

  List<T> originalCopy = List.from(original);
  List<T> subCopy = List.from(sub);
  int maxOccurrences = originalCopy.length - subCopy.length + 1;

  int skipCopy = skip;
  for (int currentIndex = 0; currentIndex < maxOccurrences; currentIndex++) {
    if (deepEquals(
        originalCopy.sublist(currentIndex, currentIndex + subCopy.length),
        subCopy)) {
      if (skipCopy == 0) {
        return originalCopy.sublist(0, currentIndex);
      } else {
        skipCopy--;
      }
    }
  }

  return null;
}

/// Equivalent to String .startsWith
bool startsWithList(Iterable original, Iterable sub) {
  if (sub.length > original.length) {
    return false;
  }
  return sub.isEmpty ||
      deepEquals(List.from(original).sublist(0, sub.length), List.from(sub));
}

/// Convert each element to List
List<List<T>> toLists<T>(Iterable<T> it) {
  List<List<T>> result = [];

  for (T element in it) {
    result.add([element]);
  }

  return result;
}

/// Replace one sublist with another, any or all occurrences.
List<T> replaceCountList<T>(Iterable<T> original, Iterable<T> from,
    [Iterable<T> to = const [], int? count]) {
  List<T> originalCopy = List.from(original);
  List<T> fromCopy = List.from(from);
  List<T> toCopy = List.from(to);
  if (count != null && count <= 0) {
    return originalCopy;
  }

  List<int> replaceIndices =
      indicesList(originalCopy, fromCopy, exclusive: true);

  if (replaceIndices.isEmpty) {
    return originalCopy;
  }

  if (count != null) {
    replaceIndices =
        replaceIndices.sublist(0, min(count, replaceIndices.length));
  }

  List<T> result = originalCopy.sublist(0, replaceIndices.first);
  for (int i = 0; i < replaceIndices.length; i++) {
    if (i == replaceIndices.length - 1) {
      result += toCopy +
          originalCopy.sublist(
              replaceIndices[i] + fromCopy.length, originalCopy.length);
    } else {
      result += toCopy +
          originalCopy.sublist(
              replaceIndices[i] + fromCopy.length, replaceIndices[i + 1]);
    }
  }

  return result;
}

/// Replace a substring with another, any or all occurrences
String replaceCountString(String original, String from,
    [String to = '', int? count]) {
  return chrs(replaceCountList(
      original.codeUnits, from.codeUnits, to.codeUnits, count));
}
