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

// Struct that I will pass into the thread I create
struct InputStruct {
  
  // The stdin
  var inputBuffer: String = ""
  
  // Mutexes I need
  var m1 = pthread_mutex_t()
  var m2 = pthread_mutex_t()
  var m3 = pthread_mutex_t()

}

// Function that handles my error checking
func errorHandler(no: Int32, msg: String) {
  errno = no
  perror("Error in: \(msg) | Code: \(errno)")
  exit(EXIT_FAILURE)
}

func repeatFunc(input: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
  pthread_mutex_lock(&setInputBuffer.m2)
  
  
  // Printing out the input from stdin stored in my struct
  let printing = input.assumingMemoryBound(to: InputStruct.self).pointee.inputBuffer
  
  
  // Pseudocode !!
  /*
  print("press enter to quit: ")
  
   while readline() != enter {
    print("that was not enter ph00l, try again")
   }
   pthread_mutex_unlock(&setInputBuffer.m2)
  
   */

  print(printing)
  pthread_mutex_unlock(&setInputBuffer.m1)
  print("Child thread exiting")
  pthread_mutex_unlock(&setInputBuffer.m2)
  return nil
}

var setInputBuffer = InputStruct()

// Initializing mutexes - I reckon I need three...
pthread_mutex_init(&setInputBuffer.m1, nil)
pthread_mutex_init(&setInputBuffer.m2, nil)
pthread_mutex_init(&setInputBuffer.m3, nil)

let pointer : UnsafeMutableRawPointer? = nil

var pt: pthread_t?

// Reading in the input
if let stdin = readLine() {
  
  setInputBuffer.inputBuffer = stdin
}


pthread_mutex_lock(&setInputBuffer.m1)
// Creating a new thread, passing in the address of the struct
var s: Int32 = pthread_create(&pt, nil, repeatFunc, &setInputBuffer)
print("child thread is gone")

// Destroy the mutexes to clear up resources
pthread_mutex_destroy(&setInputBuffer.m1)
pthread_mutex_destroy(&setInputBuffer.m2)
pthread_mutex_destroy(&setInputBuffer.m3)

// Checking the return of pthread_create and pass it to my error handler func
if (s != 0) {
  errorHandler(no: s, msg: "thread_create")
} else {
  //print("pthread_create ran successfully") /* For Debugging */
}

// Joining the threads
var status: Int32 = pthread_join(pt!, nil)

if (status != 0) {
  errorHandler(no: s, msg: "pthread_join")
} else {
  //print("pthread_join ran successfully") /* For Debugging */
}


