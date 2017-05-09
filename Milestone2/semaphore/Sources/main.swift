/*
 Author: Eli Birgisson
 s2956190
 Griffith University
 Trimester 1, 2017
 3420ICT Systems Programming
 Assignment 2
 Milestone 2 - semaphores
 */

import Foundation

// Struct that I will pass into the thread I create
struct InputStruct {
  
  var sem1: UnsafeMutablePointer<SemaModule>
  var sem2: UnsafeMutablePointer<SemaModule>
  
  var inputBuffer: UnsafeMutablePointer<String>
  
  init( _ semaphore1: UnsafeMutablePointer<SemaModule>,
        _ semaphore2: UnsafeMutablePointer<SemaModule>,
        _ textInput: UnsafeMutablePointer<String>) {

    self.sem1 = semaphore1
    self.sem2 = semaphore2
    self.inputBuffer = textInput
  }
}

// Function that handles all my error check printing
func errorHandler(no: Int32, msg: String) {
  errno = no
  perror("Error in: \(msg) | Code: \(errno)")
  exit(EXIT_FAILURE)
}

func repeatFunc(input: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
//  print("entering child thread/func") /* For Debugging */
  sleep(10)
  let temp = input
  typealias StructP = UnsafeMutablePointer<InputStruct>
  let sp: StructP = temp.assumingMemoryBound(to: InputStruct.self)
  
  sp.pointee.sem2.pointee.procure()

// print("printing input:") /* For Debugging */

  print(sp.pointee.inputBuffer.pointee)
  
  sp.pointee.sem1.pointee.vacate()
  sp.pointee.sem2.pointee.procure()
  
  sp.pointee.sem1.pointee.vacate()
  sp.pointee.sem2.pointee.procure()
  sp.pointee.sem1.pointee.vacate()
  
// print("Exiting repeatFunc") /* For Debugging */
  
  return nil
}

// Creating my semaphores
var sem1: SemaModule = SemaModule(value: 1)
var sem2: SemaModule = SemaModule(value: 1)

var inputBuffer: String = ""

sem1.procure() // Sem 1 procure

// Constructing my struct stored values
var structArgs: InputStruct = InputStruct(&sem1, &sem2, &inputBuffer)

var pt: pthread_t?

// print("create new child thread") /* For Debugging */

sem2.procure() // Sem2 procure

// Creating a new thread, passing in the address of the struct
var s: Int32 = pthread_create(&pt, nil, repeatFunc, &structArgs)

// Reading in the input
if let stdin = readLine() {
  //  print("first input readline") /* For Debugging */
//  pthread_mutex_lock(&enterLock_3)
  inputBuffer = stdin
}

sem2.vacate()   // Allows repeatFunc to print input

sem1.procure() // Makes main wait for repeatFunc to unlock/finish

print("Press Enter to Quit: ")

if let stdin = readLine() {
  // print("second input readline") /* For Debugging */
  
}

sem2.vacate()
sem1.procure()

print("Child is exiting")

sem2.vacate()
sem1.procure()

// Joining the threads
var status: Int32 = pthread_join(pt!, nil)

print("Child is gone")

// Checking the return of pthread_create and pass it to my error handler func
if (s != 0) {
  errorHandler(no: s, msg: "thread_create")
} else {
// print("pthread_create ran successfully") /* For Debugging */
}


if (status != 0) {
  errorHandler(no: s, msg: "pthread_join")
} else {
// print("pthread_join ran successfully") /* For Debugging */
}
