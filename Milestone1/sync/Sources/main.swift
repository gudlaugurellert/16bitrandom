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
  
  var inputBuffer: UnsafeMutablePointer<String>
  var lock1: UnsafeMutablePointer<pthread_mutex_t>
  var lock2: UnsafeMutablePointer<pthread_mutex_t>
  var lock3: UnsafeMutablePointer<pthread_mutex_t>
  
  init(_ mutex1: UnsafeMutablePointer<pthread_mutex_t>,
       _ mutex2: UnsafeMutablePointer<pthread_mutex_t>,
       _ mutex3: UnsafeMutablePointer<pthread_mutex_t>,
       _ textInput: UnsafeMutablePointer<String>) {
    
    self.lock1 = mutex1
    self.lock2 = mutex2
    self.lock3 = mutex3
    self.inputBuffer = textInput
  }
}

// Function that handles my error checking
func errorHandler(no: Int32, msg: String) {
  errno = no
  perror("Error in: \(msg) | Code: \(errno)")
  exit(EXIT_FAILURE)
}

func repeatFunc(input: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
  print("entering child thread/func") /* For Debugging */
  
  let temp = input
  typealias StructP = UnsafeMutablePointer<InputStruct>
  let sp: StructP = temp.assumingMemoryBound(to: InputStruct.self)

  pthread_mutex_lock(sp.pointee.lock3)
  pthread_mutex_lock(sp.pointee.lock1)
  
  // Printing out the input from stdin stored in my struct
  print(sp.pointee.inputBuffer.pointee)
  
  pthread_mutex_unlock(sp.pointee.lock3)
  pthread_mutex_lock(sp.pointee.lock2)

  print("Exiting repeatFunc") /* For Debugging */
  
  return nil
}

// Create mutexes
var lock1 = pthread_mutex_t()
var lock2 = pthread_mutex_t()
var lock3 = pthread_mutex_t()
var attr = pthread_mutexattr_t()
// Initializing mutexes
pthread_mutex_init(&lock1, &attr)
pthread_mutex_init(&lock2, &attr)
pthread_mutex_init(&lock3, &attr)

// Locking first mutex for main thread
pthread_mutex_lock(&lock1)

var inputBuffer: String = ""

// Constructing my struct stored values
var structArgs: InputStruct = InputStruct(&lock1, &lock2, &lock3, &inputBuffer)

//let pointer : UnsafeMutableRawPointer? = nil
var pt: pthread_t?

// Creating a new thread, passing in the address of the struct
print("create new child thread") /* For Debugging */
var s: Int32 = pthread_create(&pt, nil, repeatFunc, &structArgs)

// Reading in the input
if let stdin = readLine() {
  print("first input readline") /* For Debugging */
  inputBuffer = stdin
}

pthread_mutex_unlock(&lock2)
pthread_mutex_lock(&lock3)
pthread_mutex_lock(&lock2)

print("Press Enter to Quit: ")

if let stdin = readLine() {
  print("second input readline") /* For Debugging */
  pthread_mutex_unlock(&lock2)
  pthread_mutex_unlock(&lock3)
}
print("Child exiting") /* For Debugging */
// Joining the threads
var status: Int32 = pthread_join(pt!, nil)

// Checking the return of pthread_create and pass it to my error handler func
if (s != 0) {
  errorHandler(no: s, msg: "thread_create")
} else {
  //print("pthread_create ran successfully") /* For Debugging */
}


if (status != 0) {
  errorHandler(no: s, msg: "pthread_join")
} else {
  //print("pthread_join ran successfully") /* For Debugging */
}

// Destroy the mutexes to clear up resources
pthread_mutex_destroy(&lock1)
pthread_mutex_destroy(&lock2)
pthread_mutex_destroy(&lock3)
