/*
 Author: Eli Birgisson
 s2956190
 Griffith University
 Trimester 1, 2017
 3420ICT Systems Programming
 Assignment 2
 Milestone 3 - Random 16bit Number Generator
 */

import Foundation

// Struct that I will pass into the thread I create
struct InputStruct {
  
  var randGen: UnsafeMutablePointer<StorageHandler>
  
  var sem1: UnsafeMutablePointer<SemaModule>
  var sem2: UnsafeMutablePointer<SemaModule>
  var sem3: UnsafeMutablePointer<SemaModule>
  
  var numberBuffer: UnsafeMutablePointer<[UInt16]>
  var min: UnsafeMutablePointer<Int>
  var max: UnsafeMutablePointer<Int>
  var numbersToPrint: UnsafeMutablePointer<Int>
  var exitFlag: UnsafeMutablePointer<Bool>
  
  init( _ randomGen:  UnsafeMutablePointer<StorageHandler>,
        _ semaphore1: UnsafeMutablePointer<SemaModule>,
        _ semaphore2: UnsafeMutablePointer<SemaModule>,
        _ semaphore3: UnsafeMutablePointer<SemaModule>,
        _ buffer:     UnsafeMutablePointer<[UInt16]>,
        _ minimum:    UnsafeMutablePointer<Int>,
        _ maximum:    UnsafeMutablePointer<Int>,
        _ input:      UnsafeMutablePointer<Int>,
        _ quitFlag:   UnsafeMutablePointer<Bool>) {
    
    self.randGen = randomGen
    self.sem1 = semaphore1
    self.sem2 = semaphore2
    self.sem3 = semaphore3
    self.numberBuffer = buffer
    self.min = minimum
    self.max = maximum
    self.numbersToPrint = input
    self.exitFlag = quitFlag
  }
}

/**
 Function that handles all my error checking
 - parameter no: The Error Number Passed
 - parameter msg: Message passed
 */
func errorHandler(no: Int32, msg: String) {
  errno = no
  perror("Error in: \(msg) | Code: \(errno)")
  exit(EXIT_FAILURE)
}

/**
 Function that is essentially the child thread
 - parameter input: A pointer to the InputStruct struct
 - returns: nil
 */
func repeatFunc(input: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
//    print("entering child thread/func") /* For Debugging */
  
  let temp = input
  typealias StructP = UnsafeMutablePointer<InputStruct>
  let sp: StructP = temp.assumingMemoryBound(to: InputStruct.self)
  
  sp.pointee.randGen.pointee.producer(strukkt: temp)

  return nil
}

/* MAIN */

// Reference to the StorageHandler class
var rand: StorageHandler = StorageHandler()

// Max and Min default values
var max: Int = 5
var min: Int = 0

// The Array to hold all the random number
var numberBuffer: [UInt16] = []

// Variable to set the number of times a random number is printed
var numbersToPrint: Int = 0

// Boolean flag to exit the program
var exitFlag: Bool = false

// Variables used when printing out stuff
var randomNumber: UInt16 = 0
var hex: String
var incorrectInput: Bool = false

// Command line arguments
let argc = CommandLine.argc
let argTemp = CommandLine.arguments

// if the number of arguments are greater or equal to 3
// then assign arg[1] to max and arg[2] to min.
// There are other checks in place to make sure that
// the input is correct.
if argc >= 3 {
  if let argMax = Int(argTemp[1]) {
    max = argMax
  }
  
  if let argMin = Int(argTemp[2]) {
    min = argMin
  }
  
  if max < min {
    max = 5
    min = 0
    print("Command arguments invalid. Max cannot be lower than min.")
    print("Resetting max and min to default values: max = 5 and min = 0")
  }
} else if argc == 2{
  print("Command arguments invalid. Both Max and Min needs to be set, or none.")
  print("Resetting max and min to default values: max = 5 and min = 0")
}

// Semaphores
var sem1: SemaModule = SemaModule(value: 1)
var sem2: SemaModule = SemaModule(value: min+1)
var sem3: SemaModule = SemaModule(value: max)

// Constructing the structs stored values
var structArgs: InputStruct = InputStruct(&rand, &sem1, &sem2, &sem3, &numberBuffer, &min, &max, &numbersToPrint, &exitFlag)

var pt: pthread_t?

// Creating a new thread, passing in the address of the struct
var s: Int32 = pthread_create(&pt, nil, repeatFunc, &structArgs)

while(!exitFlag) {
  print(":: Enter a number>>")
  
  // Reading in the input
  if let stdin = readLine() {

    // If input is exit then quit the program
    if (stdin == "exit") {
      exitFlag = true
      sem1.vacate()
      sem3.vacate()
      
    } else {
      
      // Else if input is something other than exit then
      // loop through every element in temp String array
      // and parse into an Integer and then append that Integer
      // to the commandLineInput Integer array
      
      if let num = Int(stdin) {
        numbersToPrint = num
        
        if numbersToPrint < 0 {
          print("Less than zero values not allowed.")
          incorrectInput = true
        }
      } else {
        
        // If there is a element in the temp String array that
        // can not be parsed into an Integer then that is an invalid
        // input and the user is asked to re-enter the number
        
        // A flag incorrectInput is set to true, signaling the for loop
        // not to process the input.
        
        print("Error: Incorrect input.")
        incorrectInput = true
        
        }
      
      // This is where the program prints out the random numbers.
      // First it checks if the flag incorrectInput is set to false then it
      // can proceed and print out a random number.
      
      if(!incorrectInput) {
        
        for index in 0..<numbersToPrint {
          sem2.procure()
          sem1.procure()
          randomNumber = rand.get_buffer(strukkt: &structArgs)
          hex = String(randomNumber, radix: 16)
          sem1.vacate()
          sem3.vacate()
          
          print("Random number is '\(randomNumber)' or '0x\(hex)'")
        }
      }
      
      // Resetting the flag for the next input from the user.
      incorrectInput = false
    }
  }
}

print("Child is exiting")

// Joining the threads
var status: Int32 = pthread_join(pt!, nil)

print("Child is gone")

// Checking the return of pthread_create and pass it to my error handler func
if (s != 0) {
  errorHandler(no: s, msg: "thread_create")
} else {
//   print("pthread_create ran successfully") /* For Debugging */
}

if (status != 0) {
  errorHandler(no: s, msg: "pthread_join")
} else {
//   print("pthread_join ran successfully") /* For Debugging */
}
