/*
 Author: Eli Birgisson
 s2956190
 Griffith University
 Trimester 1, 2017
 3420ICT Systems Programming
 Assignment 2
 Milestone 1 - sync
 */

import Foundation

struct InputStruct {
  var inputBuffer: String = ""
}

func repeatFunc(input: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
  
  var printing = input.assumingMemoryBound(to: String.self).pointee

  print("1 start repeatFunc")
  print(printing)
  
  print("2 end of repatFunc ")
  return nil
}

let pointer : UnsafeMutableRawPointer? = nil
var pt: pthread_t?
var s: Int32

var testingStruct = InputStruct()

if let stdin = readLine() {
  
  testingStruct.inputBuffer = stdin
  
}

print("test:::  \(testingStruct.inputBuffer)")
s = pthread_create(&pt, nil, repeatFunc, &testingStruct.inputBuffer)


if (s != 0) {
  print("some Error")
} else {
  print("it ran??")
}



//guard pthread_create(&pt, nil, repeatFunc, pointer) == 0 && pt != nil
//  else { throw Error
//  
//}

