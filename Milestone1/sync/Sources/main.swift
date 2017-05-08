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
  
  var mainLock_1: UnsafeMutablePointer<pthread_mutex_t>
  var childLock_2: UnsafeMutablePointer<pthread_mutex_t>
  var enterLock_3: UnsafeMutablePointer<pthread_mutex_t>
  var inputBuffer: UnsafeMutablePointer<String>
  
  init(_ mutex1: UnsafeMutablePointer<pthread_mutex_t>,
       _ mutex2: UnsafeMutablePointer<pthread_mutex_t>,
       _ mutex3: UnsafeMutablePointer<pthread_mutex_t>,
       _ textInput: UnsafeMutablePointer<String>) {
    
    self.mainLock_1 = mutex1
    self.childLock_2 = mutex2
    self.enterLock_3 = mutex3
    self.inputBuffer = textInput
  }
}

// Function that handles all my error checking
func errorHandler(no: Int32, msg: String) {
  errno = no
  perror("Error in: \(msg) | Code: \(errno)")
  exit(EXIT_FAILURE)
}

func repeatFunc(input: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
  // print("entering child thread/func") /* For Debugging */
  
  let temp = input
  typealias StructP = UnsafeMutablePointer<InputStruct>
  let sp: StructP = temp.assumingMemoryBound(to: InputStruct.self)

  pthread_mutex_lock(sp.pointee.childLock_2)
  pthread_mutex_lock(sp.pointee.mainLock_1)

  // print("printing input:") /* For Debugging */
  // Printing out the input from stdin stored in my struct
  print(sp.pointee.inputBuffer.pointee)
  
  pthread_mutex_unlock(sp.pointee.childLock_2)
  pthread_mutex_lock(sp.pointee.enterLock_3)
  
  pthread_mutex_unlock(sp.pointee.mainLock_1)
  pthread_mutex_unlock(sp.pointee.childLock_2)
  pthread_mutex_unlock(sp.pointee.enterLock_3)

  // print("Exiting repeatFunc") /* For Debugging */
  
  return nil
}

// Create mutexes
var mainLock_1 = pthread_mutex_t()
var childLock_2 = pthread_mutex_t()
var enterLock_3 = pthread_mutex_t()

// Create attributes
var attr1 = pthread_mutexattr_t()
var attr2 = pthread_mutexattr_t()
var attr3 = pthread_mutexattr_t()

// Initializing attributes
// !!!!!! FUN FACT, THIS IS WHAT I FORGOT TO DO FROM THE VERY BEGINNING !!!!!!
var a1: Int32 = pthread_mutexattr_init(&attr1)
var a2: Int32 = pthread_mutexattr_init(&attr2)
var a3: Int32 = pthread_mutexattr_init(&attr3)

// Error handling
if (a1 != 0) {
  errorHandler(no: a1, msg: "mutex attribute init: a1")
}

if (a2 != 0) {
  errorHandler(no: a2, msg: "mutex attribute init: a2")
}

if (a3 != 0) {
  errorHandler(no: a3, msg: "mutex attribute init: a3")
}

// Initializing mutexes
var m1: Int32 = pthread_mutex_init(&mainLock_1, &attr1)
var m2: Int32 = pthread_mutex_init(&childLock_2, &attr2)
var m3: Int32 = pthread_mutex_init(&enterLock_3, &attr3)

// Error handling
if (m1 != 0) {
  errorHandler(no: m1, msg: "mutex init: m1")
}

if (m2 != 0) {
  errorHandler(no: m2, msg: "mutex init: m2")
}

if (m3 != 0) {
  errorHandler(no: m3, msg: "mutex init: m3")
}

// Locking first mutex for main thread
pthread_mutex_lock(&mainLock_1)

var inputBuffer: String = ""

// Constructing my struct stored values
var structArgs: InputStruct = InputStruct(&mainLock_1, &childLock_2, &enterLock_3, &inputBuffer)

var pt: pthread_t?

// print("create new child thread") /* For Debugging */

// Creating a new thread, passing in the address of the struct
var s: Int32 = pthread_create(&pt, nil, repeatFunc, &structArgs)

// Reading in the input
if let stdin = readLine() {
  // print("first input readline") /* For Debugging */
  inputBuffer = stdin
}

pthread_mutex_unlock(&mainLock_1) // Allows repeatFunc to print input
pthread_mutex_lock(&childLock_2) // Makes main wait for repeatFunc to unlock/finish
pthread_mutex_lock(&enterLock_3)

print("Press Enter to Quit: ")

if let stdin = readLine() {
  // print("second input readline") /* For Debugging */
  
}

pthread_mutex_unlock(&enterLock_3)
pthread_mutex_unlock(&childLock_2)

print("Child is exiting")

// Joining the threads
var status: Int32 = pthread_join(pt!, nil)

print("Child is gone")

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
pthread_mutex_destroy(&mainLock_1)
pthread_mutex_destroy(&childLock_2)
pthread_mutex_destroy(&enterLock_3)
