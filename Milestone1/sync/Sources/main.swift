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
  var test: String = "what the shit"
  var m1 = pthread_mutex_t()
  var m2 = pthread_mutex_t()

}

func errorHandler(no: Int32, msg: String) {
  errno = no
  perror("Error in: \(msg) | Code: \(errno)")
  exit(EXIT_FAILURE)
}

func repeatFunc(input: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
  //pthread_mutex_lock(&input.m2)
  
//  let x = input.test.assumingMemoryBound(to: String.self).pointee
// WHY WONT DOING X WORK
  
  let printing = input.assumingMemoryBound(to: InputStruct.self).pointee.test

  print(printing)
  //print(x)
  
  return nil
}

var setInputBuffer = InputStruct()

let pointer : UnsafeMutableRawPointer? = nil
var pt: pthread_t?
pthread_mutex_init(&setInputBuffer.m1, nil)
pthread_mutex_init(&setInputBuffer.m2, nil)

//pthread_mutex_lock(&m1)
//var s: Int32 = pthread_create(&pt, nil, repeatFunc, &setInputBuffer.inputBuffer)

if let stdin = readLine() {
  
  setInputBuffer.inputBuffer = stdin
}


var s: Int32 = pthread_create(&pt, nil, repeatFunc, &setInputBuffer)
sleep(10)


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


