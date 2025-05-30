import 'dart:math';

import 'package:randomness/randomness.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Randomness tests',
    () {
      expect(randomInt(-3, -2), -3);
      expect(randomInt(0, 1), 0);

      int testInt = 0;
      expect(randomInt(-3, -2, onResult: (result) => testInt++), -3);
      expect(testInt, 1);

      expect(
          randomInt(-3, 1000, random: Random(73)) ==
              randomInt(-3, 1000, random: Random(73)),
          true);
      expect(() => randomInt(-3, -3, random: Random(73)), throwsArgumentError);

      testInt = 0;
      expect(randomDouble(-3, -3, onResult: (result) => testInt++), -3);
      expect(testInt, 1);

      expect(
          randomDouble(-3000, 30, random: Random(1)) ==
              randomDouble(-3000, 30, random: Random(1)),
          true);
      expect(randomDouble(-3, -2) >= -3 && randomDouble(-3, -2) < -2, true);
      expect(randomDouble(-3, 2) >= -3 && randomDouble(-3, 2) < 2, true);
      expect(randomDouble(2, 3) >= 2 && randomDouble(-3, 2) < 3, true);

      testInt = 0;
      expect(
        () {
          weighted([], onResult: (result) => testInt++);
        },
        throwsArgumentError,
      );
      expect(testInt, 0);

      expect(
          weighted(List.generate(1000, (index) => index),
                  random: Random(1), onResult: (result) => testInt++) ==
              weighted(List.generate(1000, (index) => index),
                  random: Random(1), onResult: (result) => testInt++),
          true);
      expect(testInt, 2);

      testInt = 0;
      expect(
        List.generate(
                1000,
                (element) => weighted(List.generate(1000, (index) => index),
                    random: Random(1),
                    onResult: (result) => testInt++)).first ==
            List.generate(
                1000,
                (element) => weighted(List.generate(1000, (index) => index),
                    random: Random(1), onResult: (result) => testInt++)).first,
        true,
      );
      expect(testInt, 2000);

      testInt = 0;
      expect(
          List.generate(
              1000,
              (_) => weightedBool(
                  trueWeight: 0,
                  falseWeight: 1,
                  onResult: (_) => testInt++)).contains(true),
          false);
      expect(
          List.generate(
              1000,
              (_) => weightedBool(
                  trueWeight: 1,
                  falseWeight: 0,
                  onResult: (_) => testInt++)).contains(false),
          false);
      expect(testInt, 2000);

      expect(
          () => weightedBool(
              trueWeight: -1, falseWeight: 1, onResult: (_) => testInt++),
          throwsArgumentError);
      expect(
          () => weightedBool(
              trueWeight: 1, falseWeight: -1, onResult: (_) => testInt++),
          throwsArgumentError);
      expect(testInt, 2000);

      expect(
          () => weightedBool(
              trueWeight: 0, falseWeight: 0, onResult: (_) => testInt++),
          throwsArgumentError);

      testInt = 0;
      expect(weightedFromMap({1: 0, 2: 1}, onResult: (_) => testInt++), 2);
      expect(
          weightedFromMap(
                  {for (int i in List.generate(1000, (index) => index)) i: 1},
                  random: Random(50), onResult: (_) => testInt++) ==
              weightedFromMap(
                  {for (int i in List.generate(1000, (index) => index)) i: 1},
                  random: Random(50), onResult: (_) => testInt++),
          true);
      expect(testInt, 3);
      expect(
          weightedFromMap(
            {
              for (int i in List.generate(1000, (index) => index))
                i: i == 45 ? 1 : 0
            },
          ),
          45);
      expect(() => weightedFromMap({1: -1, 2: 1}), throwsArgumentError);
      expect(() => weightedFromMap({1: 0, 2: 0}), throwsArgumentError);

      expect(kPrintableCharacters,
          String.fromCharCodes(List.generate(95, (index) => index + 32)));
      expect(kPrintableCharactersWithoutSpace,
          String.fromCharCodes(List.generate(94, (index) => index + 33)));
      expect(kDigits,
          String.fromCharCodes(List.generate(10, (index) => index + 48)));
      expect(kUppercaseLetters,
          String.fromCharCodes(List.generate(26, (index) => index + 65)));
      expect(kLowercaseLetters,
          String.fromCharCodes(List.generate(26, (index) => index + 97)));
      expect(kLetters, kUppercaseLetters + kLowercaseLetters);
      expect(kAlphanumeric, kUppercaseLetters + kLowercaseLetters + kDigits);
      expect(weightedString(''), '');
      expect(weightedString('a'), 'a');
      expect(
          weightedString(kPrintableCharactersWithoutSpace, random: Random(100)),
          weightedString(kPrintableCharactersWithoutSpace,
              random: Random(100)));
      expect(weightedString(kPrintableCharactersWithoutSpace, length: 0), '');
      expect(() => weightedString(kPrintableCharactersWithoutSpace, length: -1),
          throwsArgumentError);

      expect(weightedList([]), []);
      expect(weightedList([1], length: 0), []);
      expect(weightedList([1], length: 100), List.generate(100, (_) => 1));
      expect(() => weightedList([1], length: -1), throwsArgumentError);
      expect(weightedList([], length: -1), []);

      testInt = 0;
      expect(
          weightedList([1],
              length: 100,
              onEachValue: (index, value) => testInt += index,
              onFullResult: (result) => testInt += 100),
          List.generate(100, (_) => 1));
      expect(testInt, 5050);

      testInt = 0;
      expect(
          weightedList([1],
              length: 11,
              onEachValue: (index, value) => testInt += index + value,
              onFullResult: (result) => testInt += result.first),
          List.generate(11, (_) => 1));
      expect(testInt, 67);

      expect(weightedListFromMap({}), []);
      expect(weightedListFromMap({1: 0}), []);
      expect(weightedListFromMap({1: 100}), [1]);
      expect(weightedListFromMap({}, length: -1), []);
      expect(weightedListFromMap({1: 1}, length: 0), []);
      expect(
          () => weightedListFromMap({1: 2}, length: -1), throwsArgumentError);
      expect(weightedListFromMap({1: 2}, length: 100),
          List.generate(100, (_) => 1));

      testInt = 0;
      expect(
          weightedListFromMap({1: 1, 2: 0},
              length: 100,
              onEachValue: (index, value) => testInt += value + index,
              onFullResult: (result) => testInt += 100),
          List.generate(100, (_) => 1));
      expect(testInt, 5150);
    },
  );
}
