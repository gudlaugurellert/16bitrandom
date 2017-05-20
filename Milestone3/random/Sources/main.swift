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
  
//  var inputBuffer: UnsafeMutablePointer<String>
  
  var numberBuffer: UnsafeMutablePointer<[UInt16]>
  var min: UnsafeMutablePointer<Int>
  var max: UnsafeMutablePointer<Int>
  var cmdInput: UnsafeMutablePointer<[Int]>
  var flag: UnsafeMutablePointer<Bool>
  var minBuffFillFlag: UnsafeMutablePointer<Bool>
  var maxBuffFillFlag: UnsafeMutablePointer<Bool>
  
  init( _ randomGen:  UnsafeMutablePointer<StorageHandler>,
        _ semaphore1: UnsafeMutablePointer<SemaModule>,
        _ semaphore2: UnsafeMutablePointer<SemaModule>,
        _ buffer:     UnsafeMutablePointer<[UInt16]>,
        _ minimum:    UnsafeMutablePointer<Int>,
        _ maximum:    UnsafeMutablePointer<Int>,
        _ input:      UnsafeMutablePointer<[Int]>,
        _ quitFlag:   UnsafeMutablePointer<Bool>,
        _ fillMinFlag:UnsafeMutablePointer<Bool>,
        _ fillMaxFlag:UnsafeMutablePointer<Bool> ) {
    
    self.randGen = randomGen
    self.sem1 = semaphore1
    self.sem2 = semaphore2
    self.numberBuffer = buffer
    self.min = minimum
    self.max = maximum
    self.cmdInput = input
    self.flag = quitFlag
    self.minBuffFillFlag = fillMinFlag
    self.maxBuffFillFlag = fillMaxFlag
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

//  print("printing input:") /* For Debugging */

  //sp.pointee.sem2.pointee.procure()
  
  //while(sp.pointee.numberBuffer.pointee.count <= sp.pointee.max.pointee) {
    sp.pointee.randGen.pointee.put_buffer(strukkt: temp)
  //}

  sp.pointee.sem1.pointee.vacate()
  sp.pointee.sem2.pointee.procure()
  
  sp.pointee.sem1.pointee.vacate()
  sp.pointee.sem2.pointee.procure()
  sp.pointee.sem1.pointee.vacate()
  
//   print("Exiting repeatFunc") /* For Debugging */
  
  return nil
}

// Creating my semaphores
// Using two with value of 1
var rand: StorageHandler = StorageHandler()
var sem1: SemaModule = SemaModule(value: 1)
var sem2: SemaModule = SemaModule(value: 1)


var max: Int = 5
var min: Int = 0

var numberBuffer: [UInt16] = [] // Empty array of type UInt16

var commandLineInput = [Int]()

var exitFlag: Bool = false
var minBuffFillFlag: Bool = false
var maxBuffFillFlag: Bool = false

var randomNumber: UInt16 = 0
var hex: String

sem1.procure()

// Constructing my struct stored values
var structArgs: InputStruct = InputStruct(&rand, &sem1, &sem2, &numberBuffer, &min, &max, &commandLineInput, &exitFlag, &minBuffFillFlag, &maxBuffFillFlag)

var pt: pthread_t?

// print("create new child thread") /* For Debugging */


sem2.procure()
// Creating a new thread, passing in the address of the struct
var s: Int32 = pthread_create(&pt, nil, repeatFunc, &structArgs)



while(!exitFlag) {
  print("++Enter a number")
  // Reading in the input
  if let stdin = readLine() {
    //  print("first input readline") /* For Debugging */
    
    var temp = stdin.components(separatedBy: " ")
    
    if (temp[0] == "exit") {
      print("exitflag is true")
      exitFlag = true
      
    } else {
      
      for index in temp {
        
        if let num = Int(index) {
          
          commandLineInput.append(num)
          
        } else {
          print("Error: Incorrect input. Enter a number.")
          //exit(EXIT_FAILURE)
        }
      }
      
      for index in 0..<commandLineInput[0] {
        randomNumber = rand.get_buffer(strukkt: &structArgs)
        hex = String(randomNumber, radix: 16)
        
        print("Random number is '\(randomNumber)' or '0x\(hex)'")
        
      }
    }
  }
  
  
}
print("exiting while loop")


sem2.vacate()   // Allows repeatFunc to print input

sem1.procure() // Makes main wait for repeatFunc to unlock/finish

print("Press Enter to Quit: ????")


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
//   print("pthread_create ran successfully") /* For Debugging */
}


if (status != 0) {
  errorHandler(no: s, msg: "pthread_join")
} else {
//   print("pthread_join ran successfully") /* For Debugging */
}
