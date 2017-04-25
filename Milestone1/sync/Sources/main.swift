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

func errorHandler(no: Int32, msg: String) {
  errno = no
  perror("Error in: \(msg) | Code: \(errno)")
  exit(EXIT_FAILURE)
}

func repeatFunc(input: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
  
  let printing = input.assumingMemoryBound(to: String.self).pointee

  print(printing)
  
  return nil
}

let pointer : UnsafeMutableRawPointer? = nil
var pt: pthread_t?

var setInputBuffer = InputStruct()

if let stdin = readLine() {
  
  setInputBuffer.inputBuffer = stdin
}

var s: Int32 = pthread_create(&pt, nil, repeatFunc, &setInputBuffer.inputBuffer)

if (s != 0) {
  errorHandler(no: s, msg: "thread_create")
} else {
  //print("pthread_create ran successfully") /* For Debugging */
}

var status: Int32 = pthread_join(pt!, nil)

if (status != 0) {
  errorHandler(no: s, msg: "pthread_join")
} else {
  //print("pthread_join ran successfully") /* For Debugging */
}


