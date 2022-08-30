import 'package:randomness/randomness.dart';
import 'dart:core';


///Run program, compare console log to code
void main() {

  print('''
  Equivalent to Random().nextInt(5)
  ${Randomness.randomInt(include: {0,1,2,3,4})}
  ${Randomness.randomInt(include: {[0,4]})}
  ${Randomness.randomInt(include: {0,1,[2,4]})}
  ${Randomness.randomInt(include: {[0,100]}, exclude: {5,[6,100]})}
  
  default is 1 to 1000 inclusive
  ${Randomness.randomInt()}
 
  
  1 through 100 inclusive, cryptographically secure
  ${Randomness.randomInt(include: {[1,100]}, cryptographicallySecure: true)}

  
  Give weights. 2/3 chance of 0, 1/3 chance of 1, 2, 3, or 4:
  ${Randomness.randomInt(include: {0,1,2,3,4}, weights: {0: 2, everythingElse: 1})}
  
  Ignores included elements not in weights. This will always give 0.
  ${Randomness.randomInt(include: {0,1,2,3,4}, weights: {0:1})}
  
  Default length is 10. Default doesn't generate spaces.
  ${Randomness.randomString()}
  
  Strings include numbers, uppercase, lowercase, symbols, and spaces. This will generate numbers and spaces.
  ${Randomness.randomString(length: 100, includeSpaces: true, excludeSymbols: true, excludeUppercase: true, excludeLowercase: true)}
  
  cryptographically secure String with half A's
  ${Randomness.randomString(length: 50, cryptographicallySecure: true, weights: {'A': 1, everythingElse: 1})}
  
  random double, cryptographically secure
  ${Randomness.randomDouble(min: -3, max: -1, cryptographicallySecure: true)}
  
  random from List. Weights may not work with certain data types.
  ${Randomness.randomFromList([{1,2}, 'a', 3], weights: {'a': 1, everythingElse: 1}, cryptographicallySecure: true)}
  
  
  random n-digit number. Returns a String since parsing would ignore
  0's at the beginning, and cannot parse very large integers.
  ${Randomness.randomNDigits(numberOfDigits: 100, excludeDigits: {0,1,2,3}, weights: {4:1, everythingElse:1})}
  Gives average of half 4's, half 5, 6, 7, 8, or 9
  
  ''');




}
