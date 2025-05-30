/// Extension methods, with extra functions below
library;

import 'dart:math';

import 'src/helper.dart' as h;

/// Compare dynamic iterables with deepEquals
extension HeartIterable on Iterable {
  ///Compare element by element.
  ///
  /// [1, 2, 3] > [1, 1, 5] returns true because 2 > 1.
  ///
  /// ['b', 1] > ['a', 1] returns true because 'b' > 'a'
  /// by [>] operator in [HeartString]
  ///
  /// [0, 0, 1] > [1, 1, 0] returns false.
  ///
  /// Also returns false if elements cannot be compared.
  bool operator >(Iterable it) {
    return h.greaterThanIterable(this, it);
  }

  ///Compare element by element.
  ///
  /// [1, 1, 2] >= [1, 1, 2] returns true.
  ///
  /// ['b', 1] >= ['a', 1] returns true.
  ///
  /// Returns false if elements cannot be compared.
  bool operator >=(Iterable it) {
    return h.greaterThanIterable(this, it) || h.deepEquals(this, it);
  }

  ///Compare element by element.
  ///
  /// [1, 2, 1] < [1, 1, 2] returns false.
  ///
  /// ['b', 1] < ['a', 1] returns false.
  ///
  /// Returns false if elements cannot be compared.
  bool operator <(Iterable it) {
    return h.greaterThanIterable(it, this);
  }

  ///Compare element by element.
  ///
  /// [1, 2, 1] <= [1, 1, 2] returns false.
  ///
  /// ['a', 1] <= ['b', 1] returns false.
  ///
  /// Returns false if elements cannot be compared.
  bool operator <=(Iterable it) {
    return h.greaterThanIterable(it, this) || h.deepEquals(it, this);
  }

  /// Returns true if iterable contains [element].
  ///
  /// By default, Dart does not check for nested iterables.
  /// [[1,2], [3,4]].contains([1,2]) returns false, however
  ///
  /// [[1,2], [3,4]].deepContains([1,2]) returns true.
  ///
  bool deepContains(var element) {
    return h.deepContains(this, element);
  }

  /// Count number of occurrences in an iterable,
  /// using [deepEquals].
  ///
  /// [1, 2, 1].count(1) returns 2.
  ///
  /// [1, 2, {1, 2}].count({1, 2}) returns 1.
  int count(var element) {
    return h.countList(this, element);
  }
}

/// Extension methods that maintain types.
extension HeartIterableE<E> on Iterable<E> {
  /// Repeat elements n times.
  ///
  /// [1, 2] * 3 returns [1, 2, 1, 2, 1, 2]
  List<E> operator *(int n) {
    return h.cycleList(n, this);
  }

  /// Finds each index where element occurs.
  ///
  /// [1, 2, 1, 2, 1].elemIndices(1) returns [0, 2, 4].
  ///
  /// Uses [deepEquals] for nested iterables:
  /// [[1,2],[3,4]].elemIndices([1,2]) returns [0].
  @Deprecated("Use 'indices' and wrap element in square brackets")
  List<int> elemIndices(E element) {
    return h.elemIndicesList(element, this);
  }

  /// Finds each index where sublist occurs.
  /// Deprecated 'elemIndices' only searched for
  /// one element and not sublist.
  ///
  /// [1, 2, 1, 2, 1].indices([1]) returns [0, 2, 4].
  /// [1, 2, 1, 2, 1].indices([1, 2]) returns [0, 2].
  ///
  /// Uses [deepEquals] for nested iterables:
  /// [[1,2],[3,4]].indices([[1,2]]) returns [0].
  List<int> indices(Iterable<E> sublist, {bool exclusive = false}) {
    return h.indicesList(this, sublist, exclusive: exclusive);
  }

  /// Converts all elements to Strings.
  ///
  /// [1, 2, 3].toStringList() returns ['1','2','3'].
  List<String> toStringList() {
    return h.toStringList(this);
  }

  /// Returns the first element.
  ///
  /// Similar to .first, but returns null if there
  /// are no elements instead of throwing exception.
  E? head() {
    return h.headList(this);
  }

  /// Returns a List of Lists by adding one element at a time,
  /// starting from the beginning.
  ///
  /// [1,2,3,4].inits = [[], [1], [1, 2], [1, 2, 3], [1, 2, 3, 4]]
  ///
  /// [].inits() returns [[]].
  List<List<E>> inits() {
    return h.initsList(this);
  }

  /// Removes the first element, keeps the "tail".
  ///
  /// [1, 2, 3].tail() returns [2, 3].
  ///
  /// [1].tail() returns [].
  ///
  /// [].tail() returns null.
  List<E>? tail() {
    return h.tailList(this);
  }

  /// Returns a List of Lists by removing one element at a time,
  /// starting from the beginning.
  ///
  /// [1,2,3].tails() = [[1, 2, 3], [2, 3], [3], []].
  ///
  /// [].tails() returns [[]].
  List<List<E>> tails() {
    return h.tailsList(this);
  }

  /// Inserts an element in between each element.
  ///
  /// [1, 2, 3].intersperse(0) returns [1, 0, 2, 0, 3].
  ///
  /// [1].intersperse(0) returns [1].
  List<E> intersperse(E element) {
    return h.intersperseList(element, this);
  }

  /// Splits into two Lists after first n elements.
  ///
  /// [1,2,3].splitAt(1) = [[1],[2,3]].
  ///
  /// If n<=0, returns [[], this].
  ///
  /// If n>= this.length, returns [this, []].
  ///
  /// [1,2,3].splitAt(4) = [[1, 2, 3], []].
  List<List<E>> splitAt(int n) {
    return h.splitAtList(n, this);
  }

  /// Items are in the same sublist if they are equal
  /// to the one next to it.
  ///
  /// [1, 2, 3, 3, 1].group() returns [[1], [2], [3, 3], [1]].
  ///
  /// [1].group() returns [[1]]
  /// Equivalent to .groupBy((a,b) => deepEquals(a,b)).
  List<List<E>> group() {
    return h.groupList(this);
  }

  /// Items are in the same sublist if they meet the criteria
  /// that compares consecutive elements.
  ///
  /// [1, 2, 3, 2, 1].groupBy((a, b) => a < b) returns
  /// [[1, 2, 3], [2], [1]]. In this example, items are in the same sublist
  /// if they are less than the next one i.e. a < b.
  List<List<E>> groupBy(bool Function(dynamic a, dynamic b) groupFunction) {
    return h.groupByList(groupFunction, this);
  }

  /// Returns a shuffled List.
  ///
  /// Dart's shuffle() method is void.
  ///
  /// Can specify a Random:
  /// ```dart
  /// List<int> l = [1, 2, 3].shuffled(Random.secure());
  /// ```
  List<E> shuffled([Random? random]) {
    return h.shuffledList(this, random);
  }

  /// Removes first n elements.
  ///
  /// Similar to .sublist(), but won't give exception for
  /// invalid n. Returns empty List instead.
  List<E> drop(int n) {
    return h.dropList(n, this);
  }

  /// Removes elements until criteria not met.
  ///
  /// [1, 2, 3, 2, 1].dropWhile((element) => element < 3)
  /// returns [3, 2, 1]
  List<E> dropWhile(bool Function(E sub) dropFunction) {
    return h.dropWhileList(dropFunction, this);
  }

  /// Removes duplicates by using [deepEquals].
  ///
  /// [1, 1, 2, 2, 3, 3].nub() returns [1, 2, 3].
  ///
  /// Optional parameter means .nub() will only
  /// apply to those elements.
  ///
  /// [1, 1, 2, 2, 3, 3].nub([1, 3]) returns [1, 2, 2, 3]
  ///
  /// [[1,2], [1,2]].nub() returns [[1,2]]
  List<E> nub([Iterable<E>? it]) {
    return h.listNub(this, it);
  }

  /// Adds elements from input that aren't in original value.
  ///
  /// [1, 2, 3].union([2, 3, 4, 4]) returns [1, 2, 3, 4]
  ///
  /// Doesn't remove duplicates in original value, but doesn't add
  /// duplicates from input value,
  ///
  /// Can use .nub() to remove duplicates,
  /// and can concatenate normally to keep duplicates.
  List<E> union(Iterable<E> l) {
    return h.unionList(this, l);
  }

  /// Keeps all values that are also in input String,
  /// using [deepEquals].
  ///
  /// [1, 1, 2, 2].intersect([1, 3, 5]) returns [1, 1].
  ///
  /// Doesn't remove duplicates in original value, but doesn't add
  /// duplicates from input value.
  /// Can use .nub() to remove duplicates.
  ///
  /// [[1,2], 2, 3].intersect([[1,2]]) returns [[1,2]].
  ///
  List<E> intersect(Iterable<E> input) {
    return h.listIntersect(this, input);
  }

  /// Removes elements one at a time, using [deepEquals].
  ///
  /// [1, 2, 3, 1].subtract([1]) returns [2, 3, 1].
  ///
  /// [1, 2, 3, 1].subtract([1, 1]) returns [2, 3].
  ///
  /// [{1,2}, {1,2}, [3,4]].subtract([{1,2}])
  /// returns [{1,2}, [3,4]].
  List<E> subtract(Iterable<E> sublist) {
    return h.listSubtract(this, sublist);
  }

  /// Removes all elements if they are in [sublist].
  ///
  /// [1, 2, 3, 1, 2, 3].subtractAll([1, 2]) returns [3, 3].
  ///
  /// [{1,2}, {1,2}, [3,4]].subtractAll([{1,2}])
  /// returns [[3,4]], uses [deepEquals].
  List<E> subtractAll(Iterable<E> sublist) {
    return h.listSubtractAll(this, sublist);
  }

  /// Similar to .replaceFirst for Strings.
  ///
  /// [1, 1, 2, 3].replaceFirst(1, 99) returns [99, 1, 2, 3].
  ///
  /// [1, 1, 2, 3].replaceFirst(1, [99,100]) returns [99, 100, 1, 2, 3].
  ///
  /// [1, 1, 2, 3].replaceFirst(1) returns [1, 2, 3].
  @Deprecated('''Use 'replace' instead.
      [2, 2, 2].replaceFirst(2) = [2, 2, 2].replace([2], [], 1).
      This can also be used to replace a sublist instead of one element''')
  List<E> replaceFirst(E from, [dynamic to]) {
    return h.replaceList(this, false, from, to);
  }

  /// Similar to .replaceAll for Strings.
  ///
  /// [1, 1, 2, 3].replaceAll(1, 99) returns [99, 99, 2, 3].
  ///
  /// [1, 1, 2, 3].replaceAll(1, [99, 100]) returns
  /// [99, 100, 99, 100, 2, 3].
  ///
  /// [1, 1, 2, 3].replaceAll(1) returns [2, 3].
  @Deprecated("Use 'replace' instead, wrap element in square brackets")
  List<E> replaceAll(E from, [dynamic to]) {
    return h.replaceList(this, true, from, to);
  }

  /// Successor to 'replaceFirst' and 'replaceAll'
  /// [1, 1, 1].replace([1], [3]) returns [3, 3, 3]
  /// [1, 1, 1, 1].replace([1, 1], [3]) returns [3, 3]
  ///
  /// Optional [count] replaces that many occurrences:
  /// [1, 1, 1].replace([1], [3], 1) returns [3, 1, 1]
  /// [1, 1, 1].replace([1], [], 1) returns [1, 1]
  ///
  /// High [count] does not add more elements:
  /// [1, 1, 1].replace([1], [2], 100) returns [2, 2, 2]
  /// Negative [count] returns the same:
  /// [1, 1, 1].replace([1], [2], -100) returns [1, 1, 1]
  ///
  /// Replacing empty list inserts sublist before and after each element:
  /// [1, 1, 1].replace([], [2]) returns [2, 1, 2, 1, 2, 1, 2]
  /// [1, 1, 1].replace([], [2], 2) returns [2, 1, 2, 1, 1]
  /// [].replace([], [1]) returns [1]
  List<E> replace(Iterable<E> from, [Iterable<E> to = const [], int? count]) {
    return h.replaceCountList(this, from, to, count);
  }

  /// Removes elements that don't meet criteria.
  ///
  /// [1, 2, 3, 3].filter((element) => element < 3)
  /// returns [1, 2].
  ///
  /// ['a1', 'a2', 'b1', 'b2'].filter((sub) => sub.startsWith('a'))
  /// returns ['a1', 'a2'].
  List<E> filter(bool Function(E element) filterFunction) {
    return h.filterList(filterFunction, this);
  }

  /// Reverses and returns a List.
  List<E> backwards() {
    return h.backwardsList(this);
  }

  /// Combines elements by taking turns.
  /// First element in original iterable is the first element of the result.
  ///
  /// [1, 2, 3].interleave([4, 5, 6])
  /// returns [1, 4, 2, 5, 3, 6].
  ///
  /// Excess elements are added to the end.
  ///
  /// [1, 2, 3].interleave([4])
  /// returns [1, 4, 2, 3]
  List<E> interleave(Iterable<E> it) {
    return h.interleaveList(this, it);
  }

  /// Splits into two and uses [interleave] to combine,
  /// second half first.
  ///
  /// [1, 2, 3, 4, 5, 6].riffleIn() returns
  /// [4, 1, 5, 2, 6, 3]
  ///
  /// Odd number of elements:
  /// [1, 2, 3, 4, 5].riffleIn() returns [3, 1, 4, 2, 5]
  List<E> riffleIn() {
    return h.riffleInList(this);
  }

  /// Splits into two and uses [interleave] to combine.
  ///
  /// [1, 2, 3, 4, 5, 6].riffleOut() returns
  /// [1, 4, 2, 5, 3, 6].
  ///
  /// Odd number of elements:
  /// [1, 2, 3, 4, 5].riffleOut() returns [1, 4, 2, 5, 3]
  List<E> riffleOut() {
    return h.riffleOutList(this);
  }

  /// Returns everything after a given sublist:
  /// [1, 2, 3].after([1]) returns [2, 3]
  /// [1, 2, 3].after([1, 2]) returns [3]
  /// [1, 2, 3].after([]) returns [1, 2, 3]
  ///
  /// /// Works for nested iterables:
  /// [{1: 2}, {3: 4}].after([{1: 2}]) returns [{3: 4}]
  ///
  /// Optional [skip] skips that many occurrences:
  /// [1, 2, 1, 2, 3].after([1], skip: 1) returns [2, 3]
  ///
  /// Returns null if [sublist] is not present, unless [skip] is negative:
  /// [1, 2, 3].after([100]) returns null
  /// Negative [skip] returns original:
  /// [1, 2, 3].after([100], skip: -1) returns [1, 2, 3]
  ///
  /// Empty sublist returns everything after
  /// the first [skip] elements:
  /// [1, 1, 1].after([], skip: 2) returns [1]
  /// [1, 1, 1].after([], skip: 3) returns []
  ///
  /// Returns null if all occurrences are skipped:
  /// [1, 2, 3, 3].after([3], skip: 2) returns null
  /// [1, 1, 1].after([], skip: 4) returns null
  List<E>? after(Iterable<E> sublist, {int skip = 0}) {
    return h.afterList(this, sublist, skip);
  }

  /// Returns everything before a given sublist:
  /// [1, 2, 3, 3].before([3]) returns [1, 2]
  /// [1, 2, 3, 3].before([3, 3]) returns [1, 2]
  /// [1, 2, 3, 3].before([1]) returns []
  /// [1, 2, 3, 3].before([]) returns []
  ///
  /// Works for nested iterables:
  /// [{1: 2}, {3: 4}].before([{3: 4}]) returns [{1: 2}]
  ///
  /// Optional [skip] skips that many occurrences:
  /// [1, 2, 3, 3].before([3], skip: 1) returns [1, 2, 3]
  ///
  /// Returns null if [sublist] is not present, unless [skip] is negative:
  /// [1, 2, 3].before([5, 6]) returns null
  /// Negative [skip] returns empty:
  /// [1, 2, 3].before([5, 6], skip: -1) returns []
  ///
  /// Returns first [skip] elements when sublist is empty:
  /// [1, 2, 3, 4].before([], skip: 4) returns [1, 2, 3, 4]
  ///
  /// Returns null if all occurrences are skipped:
  /// [1, 2, 3, 3].before([3], skip: 2) returns null
  /// [1, 2, 3, 4].before([], skip: 5) returns null
  List<E>? before(Iterable<E> sublist, {int skip = 0}) {
    return h.beforeList(this, sublist, skip);
  }

  /// Equivalent to Dart's .startsWith for String
  /// [1, 2, 3].startsWith([1]) returns true
  /// [1, 2, 3].startsWith([1, 2]) returns true
  /// [1, 2, 3].startsWith([3]) returns false
  ///
  /// Empty [sublist] returns true the same way
  /// .startsWith('') returns true for String:
  /// [1, 2, 3].startsWith([]) returns true
  bool startsWith(Iterable<E> sublist) {
    return h.startsWithList(this, sublist);
  }
}

/// Extension methods that maintain types for nested iterables.
extension HeartIterableIterable<E> on Iterable<Iterable<E>> {
  /// Inserts an iterable in between iterables and
  /// concatenates the result.
  ///
  /// [[1, 2], [3, 4], [5, 6]].intercalate([0, 0])
  /// returns [1, 2, 0, 0, 3, 4, 0, 0, 5, 6].
  List<E> intercalate(Iterable<E> input, {int? count}) {
    return h.intercalateList(input, this, count);
  }

  /// Concatenate nested iterables.
  ///
  /// Creates a new List with all the elements combined.
  ///
  /// [[1, 2], [3, 4]].concat() returns [1, 2, 3, 4]
  List<E> concat() {
    return h.concatLists(this);
  }
}

/// Extension methods for collection of nums.
/// These methods will be used when a list has both ints and doubles.
extension HeartIterableNum on Iterable<num> {
  /// Adds all the elements of a list.
  ///
  /// [1, 2.2, 3.3].sum() returns 6.6
  double sum() {
    return h.sumDouble(this);
  }

  /// Multiplies all numbers of a list together.
  /// [1, 2, 3.0].product() returns 6.0
  double product() {
    return h.productDouble(this);
  }

  /// Returns the average of all numbers in a list
  /// [1, 2, 3.0].average() returns 2.0
  double average() {
    return h.listAverage(this);
  }

  /// Inserts [value] before the first element that is greater or equal.
  ///
  /// [3, 1.1, 2.2].insertInOrder(1) returns [1.0, 3.0, 1.1, 2.2]
  ///
  /// Does not sort.
  /// Can use .ascending() or .descending() to sort.
  List<double> insertInOrder(num value) {
    return h.insertInOrder(value, this);
  }

  /// Returns a List using Dart's sort() method.
  ///
  /// Dart's sort() method by itself is void.
  ///
  /// [1, 0.1, 3.1].ascending() returns [0.1, 1.0, 3.1]
  List<double> ascending() {
    return h.ascendingListDouble(this);
  }

  /// Returns a List that is the reverse of Dart's sort() method.
  ///
  /// Dart's sort() method by itself is void.
  ///
  /// [1, 0.1, 3.1].descending() returns [3.1, 1.0, 0.1]
  List<double> descending() {
    return h.descendingListDouble(this);
  }
}

/// Extension methods for collection of doubles
extension HeartIterableDouble on Iterable<double> {
  /// Adds all the elements
  ///
  /// [1.1, 2.2, 3.3].sum() returns 6.6
  double sum() {
    return h.sumDouble(this);
  }

  /// Multiplies all numbers of a list together.
  /// [2.0, 3.0, 5.0].product() returns 30.0
  double product() {
    return h.productDouble(this);
  }

  /// Returns the average of all numbers in a list.
  /// [2.0, 3.0, 5.0].average() returns 3.333333...
  double average() {
    return h.listAverage(this);
  }

  /// Inserts [value] before the first element that is greater or equal.
  ///
  /// [0.0, 5.5, 4.4].insertInOrder(1) returns [0.0, 1.0, 5.5, 4.4]
  ///
  /// Does not sort.
  /// Can use .ascending() or .descending() to sort.
  List<double> insertInOrder(num value) {
    return h.insertInOrder(value, this);
  }

  /// Returns a List using Dart's sort() method.
  ///
  /// Dart's sort() method by itself is void.
  ///
  /// [1.1, 0.1, 3.1].ascending() returns [0.1, 1.1, 3.1].
  List<double> ascending() {
    return h.ascendingListDouble(this);
  }

  /// Returns a List that is the reverse of Dart's sort() method.
  ///
  /// Dart's sort() method by itself is void.
  ///
  /// [1.1, 0.1, 3.1].descending() returns [3.1, 1.1, 0.1].
  List<double> descending() {
    return h.descendingListDouble(this);
  }
}

/// Extension methods for collection of integers
extension HeartIterableInt on Iterable<int> {
  /// Adds all the elements
  ///
  /// [1, 2, 3].sum() returns 6
  int sum() {
    return h.sumInt(this);
  }

  /// Multiplies all numbers of a list together.
  /// [2, 3, 5].product() returns 30
  int product() {
    return h.productInt(this);
  }

  /// Returns the average of all entries.
  /// Result is a double even though entries are ints.
  /// [1, 10].average() returns 5.5
  double average() {
    return h.listAverage(this);
  }

  /// Inserts [value] before the first element that is greater or equal.
  ///
  /// [0, 5, 3].insertInOrder(4) returns [0, 4, 5, 3]
  ///
  /// Does not sort.
  /// Can use .ascending() or .descending() to sort.
  List<int> insertInOrder(int value) {
    return h.insertInOrder(value, this);
  }

  /// Returns a List using Dart's sort() method.
  ///
  /// Dart's sort() method by itself is void.
  ///
  /// [1, 0, 3].ascending() returns [0, 1, 3].
  List<int> ascending() {
    return h.ascendingListInt(this);
  }

  /// Returns a List that is the reverse of Dart's sort() method.
  ///
  /// Dart's sort() method by itself is void.
  ///
  /// [1, 0, 3].descending() returns [3, 1, 0].
  List<int> descending() {
    return h.descendingListInt(this);
  }

  /// Returns a String from character codes.
  String chrs() {
    return h.chrs(this);
  }
}

/// Extension methods for collection of Strings
extension HeartIterableString on Iterable<String> {
  /// Combines Strings with [substring] in between them.
  ///
  /// ['one', 'two', 'three'].intercalate('-')
  /// returns 'one-two-three'.
  ///
  /// Optional [count] parameter only adds that many times:
  /// ['one', 'two', 'three'].intercalate('-', count: 1)
  /// returns 'one-twothree'
  String intercalate(String s, {int? count}) {
    return h.intercalateString(s, this, count);
  }

  /// Combines Strings into one.
  ///
  /// ['h', 'i'].concat() returns 'hi'
  String concat() {
    return h.concatStrings(this);
  }

  /// Combines separate Strings into one String, separated by spaces.
  ///
  /// ['hello','world'].unwords() returns 'hello world'
  String unwords() {
    return h.unwords(this);
  }

  /// Returns a List using Dart's sort() method.
  ///
  /// Dart's sort() method by itself is void.
  ///
  /// ['bravo', 'alpha', 'charlie'].ascending()
  /// returns ['alpha', 'bravo', 'charlie'].
  List<String> ascending() {
    return h.ascendingListString(this as List<String>);
  }

  /// Returns the reverse of Dart's sort() method.
  ///
  /// Dart's sort() method by itself is void.
  ///
  /// ['bravo', 'alpha', 'charlie'].descending()
  /// returns ['charlie', 'bravo', 'alpha'].
  List<String> descending() {
    return h.descendingListString(this as List<String>);
  }
}

/// Extension methods for Strings
extension HeartString on String {
  /// Increase each character by n code units.
  ///
  /// 'abc' ^ 1 returns 'bcd'.
  ///
  /// 'bcd' ^ (-1) returns 'abc'.
  String operator ^(int n) {
    return h.incrementString(this, n);
  }

  /// Average character based on character codes.
  /// 'abc'.average() returns 'b'.
  String average() {
    return h.averageString(this);
  }

  /// Sort a String based on character codes
  ///
  /// 'Hello, World!'.ascending() = ' !,HWdellloor'
  String ascending() {
    return h.sortedString(this);
  }

  /// Sort a String based on character codes in reverse order
  ///
  /// 'Hello, World!'.descending() = 'roollledWH,! '
  String descending() {
    return h.reversedSortedString(this);
  }

  /// By default, returns true if String contains no lowercase letters.
  ///
  /// (ignoreSymbols: false) will return false for any spaces,
  /// symbols, empty Strings, etc.
  ///
  /// 'HELLO WORLD'.isUpperCase() returns true;
  ///
  /// 'HELLO WORLD'.isUpperCase(ignoreSymbols: false)
  /// returns false because of space.
  ///
  /// 'Á'.isUpperCase(ignoreSymbols: false) returns true.
  /// Accented letters don't count as symbols.
  ///
  /// Empty String returns false if ignoreSymbols is false.
  bool isUpperCase({bool ignoreSymbols = true}) {
    return h.isUpperCase(this, ignoreSymbols);
  }

  /// By default, returns true if String contains no uppercase letters.
  ///
  /// (ignoreSymbols: false) will return false for any spaces,
  /// symbols, empty Strings, etc.
  ///
  /// 'hello world'.isLowerCase() returns true;
  ///
  /// 'hello world'.isLowerCase(ignoreSymbols: false) returns false.
  ///
  /// 'á'.isLowerCase(ignoreSymbols: false) returns true.
  /// Accented letters don't count as symbols.
  ///
  /// Empty String returns false if ignoreSymbols is false.
  bool isLowerCase({ignoreSymbols = true}) {
    return h.isLowerCase(this, ignoreSymbols);
  }

  /// Splits after n characters, returns a List of substrings
  ///
  /// 'hello'.splitAt(3) = ['hel', 'lo']
  ///
  /// Returns ['', this] for n<=0.
  /// 'hello'.splitAt(0) = ['', 'hello']
  ///
  /// Returns [this, ''] for n >= this.length
  /// 'hello'.splitAt(13) = ['hello', '']
  List<String> splitAt(int n) {
    return h.splitAtString(n, this);
  }

  /// Remove all whitespace from a String.
  ///
  /// .trim() only removes whitespace at beginning or end.
  ///
  /// 'hello world'.removeWhitespace()
  /// returns 'helloworld'.
  String removeWhitespace() {
    return h.removeWhitespace(this);
  }

  /// Returns a List of Strings that groups characters together
  /// if consecutive elements meet criteria.
  ///
  /// 'helloworld!'.groupBy((a, b) => a <= b)
  /// returns ['h', 'ellow', 'or', 'l', 'd', '!'],
  /// where each element is sorted by character codes.
  List<String> groupBy(bool Function(String a, String b) groupFunction) {
    return h.groupByString(groupFunction, this);
  }

  /// Returns a List of Strings that groups characters together
  /// if consecutive elements are equal
  ///
  /// Equivalent to groupBy((a, b) => a == b)
  ///
  /// 'aabbccabc'.group() returns ['aa', 'bb', 'cc', 'a', 'b', 'c']
  List<String> group() {
    return h.groupString(this);
  }

  /// Removes characters from a String until criteria not met.
  ///
  /// 'lowerUPPERlower'.dropWhile((char) =>
  /// char.isLowerCase())
  /// returns 'UPPERlower'.
  String dropWhile(bool Function(String sub) dropFunction) {
    return h.dropWhileString(dropFunction, this);
  }

  /// Removes repeat characters.
  ///
  /// 'Mississippi'.nub() returns 'Misp'
  ///
  /// Optional parameter will only apply
  /// .nub() function to those individual characters.
  ///
  /// 'Mississippi'.nub('is') returns 'Mispp'.
  /// Only 1 'i' and 1 's' are in return value.
  ///
  /// .nub('') will have no effect.
  String nub([String? charsToNub]) {
    return h.stringNub(this, charsToNub);
  }

  /// Separates the words in a String, and
  /// returns them in a List.
  ///
  /// Ignores whitespace.
  ///
  /// 'hello \n world'.words() returns ['hello', 'world']
  List<String> words() {
    return h.words(this);
  }

  /// Returns a List of all characters from a String.
  ///
  /// 'hello world'.letters() returns
  /// ['h', 'e', 'l', 'l', 'o', 'w', 'o', 'r', 'l', 'd'] without the space.
  ///
  /// 'hello world'.letters(keepWhitespace: true)
  /// returns ['h', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd']
  List<String> letters({bool keepWhitespace = false}) {
    return h.letters(this, keepWhitespace);
  }

  /// Returns total number of characters in a String.
  /// Ignores whitespace by default.
  ///
  /// 'hello world'.letterCount() returns 10.
  ///
  /// 'hello world'.letterCount(keepWhitespace: false)
  /// returns 11, equivalent to .length
  ///
  /// If there is a substring, returns number of
  /// occurrences after [keepWhitespace] is applied.
  ///
  /// 'hello world'.letterCount(substring: 'o w')
  /// returns 0, but
  /// 'hello world'.letterCount(keepWhitespace: true,substring: 'o w')
  /// returns 1.
  int letterCount({bool keepWhitespace = false}) {
    return h.letterCount(this, keepWhitespace);
  }

  /// Returns numbers of words in String separated by whitespace.
  ///
  /// 'hello, world!'.wordCount() returns 2
  ///
  /// ''.wordCount() returns 0
  int wordCount() {
    return h.wordCount(this);
  }

  /// Count occurrences of a substring in a String.
  ///
  /// 'hello world'.count('l') returns 3.
  ///
  /// 'hello world'.count('ll') returns 1.
  int count(String substring) {
    return h.countString(substring, this);
  }

  /// Adds elements from [input] that aren't in original value.
  ///
  /// 'abc'.union('123') returns 'abc123'.
  ///
  /// 'hello'.union('hello') returns 'hello'.
  ///
  /// Doesn't remove duplicates in original value, but doesn't add
  /// duplicates from [input],
  ///
  /// Can use .nub() to remove duplicates,
  /// and can concatenate normally to keep duplicates.
  String union(String input) {
    return h.unionString(this, input);
  }

  /// Keeps all values from original String that are also in [input].
  ///
  /// 'hello'.intersect('lo') returns 'llo'.
  ///
  /// Doesn't remove duplicates in original value, but doesn't add
  /// duplicates from input value.
  ///
  /// Can use .nub() to remove duplicates.
  String intersect(String input) {
    return h.stringIntersection(this, input);
  }

  /// Returns true if any of the characters meet criteria.
  ///
  /// 'hello'.any((character) => character == 'e') returns true.
  ///
  /// 'hello'.any((character) => character == 'a') returns false.
  bool any(bool Function(String substring) anyFunction) {
    return h.stringAny(anyFunction, this);
  }

  /// Returns true if all characters meet criteria.
  ///
  /// 'abab'.all((char) => char == 'a' || char == 'b')
  /// returns true.
  ///
  /// Returns false for empty Strings.
  bool every(bool Function(String element) allFunction) {
    return h.stringEvery(allFunction, this);
  }

  /// Returns a shuffled String.
  ///
  /// Can specify a Random:
  /// ```dart
  /// String h = 'hello'.shuffled(Random.secure());
  /// ```
  String shuffled([Random? random]) {
    return h.shuffledString(this, random);
  }

  /// Keeps characters of a String that meet criteria.
  ///
  /// 'hello'.filter((char) => char < 'i') returns 'he'.
  ///
  /// Only checks one character at a time, so this returns empty:
  /// 'hello'.filter((char) => char == 'llo').
  String filter(bool Function(String substring) filterFunction) {
    return h.filterString(filterFunction, this);
  }

  /// Puts a substring in between each character of a String.
  ///
  /// 'hello'.intersperse('-') returns 'h-e-l-l-o'
  ///
  /// '(' + 'hello'.intersperse(')(') + ')'
  /// returns '(h)(e)(l)(l)(o)'
  String intersperse(String i) {
    return h.intersperseString(i, this);
  }

  /// Returns a List of all occurrences of [substring].
  ///
  /// 'hello'.elemIndices('l') returns [2, 3].
  ///
  /// 'hello'.elemIndices('ll') returns [2].
  ///
  /// 'hellllo'.elemIndices('ll') returns [2, 3, 4].
  ///
  /// 'hello'.elemIndices('a') returns [].
  @Deprecated("Use 'indices' instead.")
  List<int> elemIndices(String substring) {
    return h.elemIndicesString(substring, this);
  }

  /// Returns a List of all occurrences of [substring].
  ///
  /// 'hello'.indices('l') returns [2, 3].
  ///
  /// 'hello'.indices('ll') returns [2].
  ///
  /// 'hellllo'.indices('ll') returns [2, 3, 4].
  ///
  /// 'hello'.indices('a') returns [].
  List<int> indices(String substring, {bool exclusive = false}) {
    return h.indicesString(this, substring, exclusive: exclusive);
  }

  /// Drops first n characters.
  ///
  /// Similar to .substring(n), but returns empty String
  /// for invalid n instead of throwing exception.
  String drop(int n) {
    return h.dropString(n, this);
  }

  /// Returns the first character.
  ///
  /// Same as .substring(0, 1), except returns null
  /// for empty String instead of error.
  String? head() {
    return h.headString(this);
  }

  /// Returns a List of Strings by adding one element
  /// at a time, starting from the beginning.
  ///
  /// 'hi'.inits() returns ['', 'h', 'hi'].
  ///
  /// ''.inits() returns [''].
  List<String>? inits() {
    return h.initsString(this);
  }

  /// Removes the first character, keeps the "tail".
  ///
  /// 'hello'.tail() returns 'ello'
  ///
  /// 'h'.tail() returns ''
  ///
  /// ''.tail() returns null
  ///
  /// Equivalent to .substring(1) except returns
  /// null for empty String instead of error.
  String? tail() {
    return h.tailString(this);
  }

  /// Returns a List of Strings by removing one character at a time,
  /// starting from the beginning.
  ///
  /// 'hello'.tails() returns
  /// ['hello', 'ello', 'llo', 'lo', 'o', '']
  List<String> tails() {
    return h.tailsString(this);
  }

  /// Returns last character of a String.
  ///
  /// 'hello'.last() returns 'o'.
  ///
  /// Returns null for empty String.
  String? last() {
    return h.lastString(this);
  }

  /// Removes each character in [charsToDelete] one time.
  ///
  /// 'hello'.subtract('l') returns 'helo'.
  ///
  /// Characters can be added multiple times to delete
  /// multiple characters.
  ///
  /// 'hello'.subtract('lol') returns 'he'.
  ///
  /// Use [subtractAll] to remove all instances.
  String subtract(String charsToDelete) {
    return h.stringSubtract(this, charsToDelete);
  }

  /// Removes all occurrences of each character in [charsToDelete].
  ///
  /// 'hello'.subtractAll('lo') returns 'he'.
  String subtractAll(String charsToDelete) {
    return h.stringSubtractAll(this, charsToDelete);
  }

  /// Adds characters from two Strings together by taking turns.
  /// First character in original String is first character
  /// in new String.
  ///
  /// 'one'.interleave('TWO')
  /// returns 'oTnWeO'.
  ///
  /// Excess characters are added to the end.
  ///
  /// 'one'.interleave('SEVEN')
  /// returns 'oSnEeVEN'.
  String interleave(String s) {
    return h.interleaveString(this, s);
  }

  /// Splits in half and interleaves together.
  ///
  /// '123456'.riffleOut() returns '142536'
  String riffleOut() {
    return h.riffleOutString(this);
  }

  /// Splits in half and interleaves second half first.
  ///
  /// '123456'.riffleIn() returns '412536'
  String riffleIn() {
    return h.riffleInString(this);
  }

  /// Inserts [substring] before the first character that is greater or equal.
  ///
  /// 'hello'.insertInOrder('i') returns 'heillo'.
  ///
  /// If [substring] is more than one character, the first
  /// character is used to insert.
  ///
  /// 'hello'.insertInOrder('ice') returns 'heicello'.
  ///
  /// Does not sort.
  /// Can use .ascending() or .descending() to sort.
  String insertInOrder(String substring) {
    return h.insertInOrderString(substring, this);
  }

  /// Reverse a String.
  ///
  /// 'hello'.backwards() returns 'olleh'
  String backwards() {
    return h.backwardsString(this);
  }

  /// Compares code units character by character.
  ///
  /// 'h' > 'a' returns true.
  ///
  /// 'a' > 'b' returns false.
  ///
  /// 'hi' > 'hello' returns true.
  bool operator >(String s) {
    return h.greaterThanString(this, s);
  }

  /// Compares code units character by character.
  ///
  /// 'h' >= 'h' returns true.
  ///
  /// 'a' >= 'b' returns false.
  ///
  /// 'hi' >= 'hello' returns true.
  bool operator >=(String s) {
    return this == s || h.greaterThanString(this, s);
  }

  /// Compares code units character by character.
  ///
  /// 'h' < 'i' returns true.
  ///
  /// 'b' < 'a' returns false.
  ///
  /// 'hello' < 'hi' returns true.
  bool operator <(String s) {
    return h.lessThanString(this, s);
  }

  /// Compares code units character by character.
  ///
  /// 'h' <= 'h' returns true.
  ///
  /// 'b' <= 'a' returns false.
  ///
  /// 'hello' <= 'hi' returns true.
  bool operator <=(String s) {
    return this == s || h.lessThanString(this, s);
  }

  /// Returns all the characters after a given substring.
  /// 'abc'.after('a') returns 'bc'
  /// 'abc'.after('ab') returns 'c'
  /// 'abc'.after('') returns 'abc'
  /// 'abc'.after('x') returns ''
  String? after(String substring, {int skip = 0}) {
    return h.afterString(this, substring, skip);
  }

  /// Returns all the characters before the first occurrence of a substring.
  /// 'abcc'.before('c') returns 'ab'
  /// 'abcc'.before('cc') returns 'ab'
  ///
  /// Returns full string if [substring] is not present:
  /// 'abcc'.before('x') returns 'abcc'
  ///
  /// Returns empty string if [substring] is empty:
  /// 'abcc'.before('') returns ''
  String? before(String substring, {int skip = 0}) {
    return h.beforeString(this, substring, skip);
  }

  /// Alternative to [replaceFirst] and [replaceAll]
  /// '111'.replace('1', '3') returns '333', same as '111'.replaceAll('1', '3')
  /// '1111'.replace('11', '3') returns '33'
  ///
  /// Optional [count] replaces that many occurrences:
  /// '111'.replace('1', '3', 1) returns '311', same as '111'.replaceFirst('1', '3')
  /// '111'.replace('1', '', 1) returns '11'
  ///
  /// High [count] does not add more characters:
  /// '111'.replace('1', '2', 100) returns '222'
  /// Negative [count] returns the same String:
  /// '111'.replace('1', '2', -100) returns '111'
  ///
  /// Replacing empty String inserts substring before and after each character:
  /// '111'.replace('', '2') returns '2121212'
  /// '111'.replace('', '2', 2) returns '21211'
  /// ''.replace('', '1') returns '1'
  String replace(String from, [String to = '', int? count]) {
    return h.replaceCountString(this, from, to, count);
  }
}

/// Extension methods for integers
extension HeartInt on int {
  /// Returns character from character code.
  ///
  /// 97.chr() returns 'a'.
  String chr() {
    return h.chr(this);
  }
}

/// Generates a List of integers
///
/// For n>0,
/// nums(n) generates a List of n integers [0..n-1]
/// nums(5) = [0, 1, 2, 3, 4]
///
/// nums(-n) generates [-n+1..0]
/// nums(-5) = [-4, -3, -2, -1, 0]

/// nums(p,q) generates [p..q]
/// nums(1,5) = [1,2,3,4,5]
/// nums(1,-3) = [1, 0, -1, -2, -3]
///
/// nums (p,q,r) generates [p..q] with a step counter r.
/// Step counter must be positive.
/// nums(1, 5, 2) = [1, 3, 5]
///
/// nums(0) = []
@Deprecated("Use 'range' or 'inclusive' instead of 'nums'")
List<int> nums(int a, [int? b, int? step]) {
  return h.nums(a, b, step);
}

/// Generates a List of integers.
/// range(n) is always in ascending order, doesn't include n itself.
/// range(3) returns [0, 1, 2]
/// range(-3) returns [-2, -1, 0]
/// range(0) returns []
///
/// With two arguments, result doesn't include the second:
/// range(1, 3) returns [1, 2]
/// range(-3, -1) returns [-3, -2]
/// range(0, -3) returns [0, -1, -2]
/// range(1, 1) returns []
///
/// Optional [step] must be positive if a < b, negative if a > b.
/// range(1, 3, 2) returns [1]
/// range(-2, 2, 2) returns [-2, 0]
/// range(-3, -7, -2) returns [-3, -5]
///
/// [step] isn't considered if a = b:
/// range(1, 1, -100) returns []
List<int> range(int a, [int? b, int? step]) {
  return h.range(a, b, step);
}

/// Uses character codes and [range].
/// Strings must have exactly 1 character.
///
/// rangeString('a', 'f') returns 'abcde'
/// rangeString('c', 'a') returns 'cb'
/// rangeString('a', 'z', 2) returns 'acegikmoqsuwy'
String rangeString(String a, [String? b, int? step]) {
  return h.rangeString(a, b, step);
}

/// Generates an inclusive List of integers.
/// inclusive(3) returns [0, 1, 2, 3]
/// inclusive(-3) returns [-3, -2, -1, 0]
///
/// inclusive(1, 3) returns [1, 2, 3]
/// inclusive(-3, -1) returns [-3, -2, -1]
/// inclusive(0, -3) returns [0, -1, -2, -3]
///
/// Optional [step] must be positive if a < b, negative if a > b.
/// inclusive(1, 3, 2) returns [1, 3]
/// inclusive(-3, 1, 2) returns [-3, -1, 1]
/// inclusive(1, -3, -2) returns [1, -1, -3]
///
/// [step] isn't considered if a = b:
/// inclusive(1, 1, -100) returns [1]
List<int> inclusive(int a, [int? b, int? step]) {
  return h.inclusive(a, b, step);
}

/// Uses character codes and [inclusive].
/// Strings must have exactly 1 character.
///
/// inclusiveString('a', 'c') returns 'abc'
/// inclusiveString('c', 'a') returns 'cba'
/// inclusiveString('a', 'g', 2) returns 'aceg'
String inclusiveString(String a, [String? b, int? step]) {
  return h.inclusiveString(a, b, step);
}

/// Checks for equality of multiple data types, including nested iterables.
///
/// By default, [1, 2] == [1, 2] returns false.
/// Dart's separate listEquals doesn't work for
/// nested lists.
///
/// deepEquals([[1,2], {3,4}], [[1,2], {3,4}]) returns true.
bool deepEquals(var a, var b) {
  return h.deepEquals(a, b);
}

/// Takes in iterables, returns a list of lists where
/// corresponding elements are paired together.
///
/// zip([['one','two','three'], [1,2,3]])
/// returns [['one', 1], ['two', 2], ['three', 3]].
///
/// zip([['one','two','three'], [1]]) returns [['one', 1]].
/// Only one pair since [1] only has one element.
List<List<T>> zip<T>(Iterable<Iterable<T>> it) {
  return h.zipList(it);
}

/// Takes in an iterable of 2 iterables and performs a
/// function between corresponding elements.
///
/// zip2([[1,2,3],[4,5,6]], (a,b) => a+b)
/// returns [5, 7, 9].
///
/// May have to cast to another data type to use other methods:
/// ```dart
/// zip2([[1,2,3],[4,5,6]], (a,b) => a+b).cast<int>().sum() = 21.
/// ```
List zip2<T>(Iterable<Iterable<T>> it, dynamic Function(T a, T b) zipFunction) {
  return h.zip2(it, zipFunction);
}

/// Takes in an iterable with 3 iterables and performs a
/// function between corresponding elements.
///
/// zip3([[0,0,0],[1,1,1],[2,2,2]], (a,b,c) => a+b+c)
/// returns [3,3,3].
///
/// May have to cast to another data type to use other methods:
/// ```dart
/// zip3([[0,0,0],[1,1,1],[2,2,2]], (a,b,c) => a+b+c).cast<int>().sum() = 9.
/// ```
List zip3<T>(
    Iterable<Iterable<T>> it, dynamic Function(T a, T b, T c) zipFunction) {
  return h.zip3(it, zipFunction);
}

/// Takes in an iterable with 4 iterables and performs a
/// function between corresponding elements.
///
/// zip4([[0,0],[5,5],[10,10],[15,15]], (a,b,c,d) => a+b+c+d)
/// returns [30,30].
///
/// May have to cast to another data type to use other methods:
/// ```dart
/// zip4([[0,0],[5,5],[10,10],[15,15]], (a,b,c,d) => a+b+c+d).cast<int>().sum() = 60.
/// ```
List zip4<T>(Iterable<Iterable<T>> it,
    dynamic Function(T a, T b, T c, T d) zipFunction) {
  return h.zip4(it, zipFunction);
}
