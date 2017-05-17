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

struct BufferData {
//  var min: Int32
  var max: UnsafeMutablePointer<Int32>
  
  var buffer: UnsafeMutablePointer<[UInt16]>
  
  
  init( maximum: UnsafeMutablePointer<Int32>/*, minimum: Int32*/,
        randBuffer: UnsafeMutablePointer<[UInt16]>) {
//    min = minimum
    self.max = maximum
    self.buffer = randBuffer
  }

}

var dataBuffer: BufferData

func producer() {
  
  var randNum: UInt16 = 0
  let path = "/dev/random"
  var data: BufferData = BufferData()
  let fd = open(path, O_RDONLY)
  var test = [UInt16]()
  
  if fd != -1 {
    
    // read() will return the size of the thing it read.
    // * CHECK IF r IS THE SAME SIZE AS THE VALUE I AM TRYING TO GET
    // * IF r IS NOT SAME SIZE, THEN I GET ERROR
    for index in 1...5 {
      
      //        let r = read(fd, &randNum, MemoryLayout<UInt16>.size)
      //        print(r)
      
      read(fd, &randNum, MemoryLayout<UInt16>.size)
      
      test.append(randNum)
      
      //let hex: String = String(randNum, radix: 16)
      print(index)
      print("Random number is '\(test)'")
      //print("Random number is '\(randNum)' or '0x\(hex)'")
      
      
    }
    
    
  }
  close(fd)
}

producer()
