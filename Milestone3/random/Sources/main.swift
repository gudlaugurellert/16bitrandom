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
  
//  var inputBuffer: UnsafeMutablePointer<String>
  
  var numberBuffer: UnsafeMutablePointer<[UInt16]>
  var min: UnsafeMutablePointer<Int>
  var max: UnsafeMutablePointer<Int>
  var cmdInput: UnsafeMutablePointer<[Int]>
  var exitFlag: UnsafeMutablePointer<Bool>
  
  init( _ randomGen:  UnsafeMutablePointer<StorageHandler>,
        _ semaphore1: UnsafeMutablePointer<SemaModule>,
        _ semaphore2: UnsafeMutablePointer<SemaModule>,
        _ semaphore3: UnsafeMutablePointer<SemaModule>,
        _ buffer:     UnsafeMutablePointer<[UInt16]>,
        _ minimum:    UnsafeMutablePointer<Int>,
        _ maximum:    UnsafeMutablePointer<Int>,
        _ input:      UnsafeMutablePointer<[Int]>,
        _ quitFlag:   UnsafeMutablePointer<Bool>) {
    
    self.randGen = randomGen
    self.sem1 = semaphore1
    self.sem2 = semaphore2
    self.sem3 = semaphore3
    self.numberBuffer = buffer
    self.min = minimum
    self.max = maximum
    self.cmdInput = input
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

// Semaphores
var rand: StorageHandler = StorageHandler()
var sem1: SemaModule = SemaModule(value: 1)
var sem2: SemaModule = SemaModule(value: 1)
var sem3: SemaModule = SemaModule(value: 1)

// Max and Min default values
var max: Int = 5
var min: Int = 0

// The Array to hold all the random number
var numberBuffer: [UInt16] = []

// The Array to hold the numbers entered inside program
var commandLineInput = [Int]()

// Boolean flags for the program
var exitFlag: Bool = false

// Variables used when printing out stuff
var randomNumber: UInt16 = 0
var hex: String
var incorrectInput: Bool = false

// Constructing the structs stored values
var structArgs: InputStruct = InputStruct(&rand, &sem1, &sem2, &sem3, &numberBuffer, &min, &max, &commandLineInput, &exitFlag)

var pt: pthread_t?

// print("create new child thread") /* For Debugging */

// Creating a new thread, passing in the address of the struct
var s: Int32 = pthread_create(&pt, nil, repeatFunc, &structArgs)

let argc = CommandLine.argc
let argTemp = CommandLine.arguments

if argc > 1 {
  if let argMax = Int(argTemp[1]) {
    max = argMax
  }

  if let argMin = Int(argTemp[2]) {
    min = argMin
  }

  if max < min {
    max = 5
    min = 0
    print("Command arguments invalid. Max cannot be lower than min")
    print("Resetting max and min to default values: max = 5 and min = 0")
  }
}

while(!exitFlag) {
  print(":: Enter a number>>")
  
  // Reading in the input
  if let stdin = readLine() {
    
    // components.separatedBy(: _) returns a String array
    var temp = stdin.components(separatedBy: " ")
    
    // If input is exit then quit the program
    if (temp[0] == "exit") {
      exitFlag = true
      sem1.vacate()
      sem3.vacate()
      
    } else {
      
      // Else if input is something other than exit then
      // loop through every element in temp String array
      // and parse into an Integer and then append that Integer
      // to the commandLineInput Integer array
      
      for index in temp {
        
        if let num = Int(index) {
          
          commandLineInput.append(num)
          
        } else {
          
          // If there is a element in the temp String array that
          // can not be parsed into an Integer then that is an invalid
          // input and the user is asked to re-enter the number
          
          // A flag incorrectInput is set to true, signaling the for loop
          // not to process the input.
          
          print("Error: Incorrect input.")
          incorrectInput = true
        }
      }
      
      // This is where the program prints out the random numbers.
      // First it checks if the flag incorrectInput is set to false then it
      // can proceed and print out a random number.
      
      if(!incorrectInput) {
        
        for index in 0..<commandLineInput[0] {
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
