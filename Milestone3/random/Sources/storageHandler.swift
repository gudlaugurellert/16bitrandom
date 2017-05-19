///*
// Author: Eli Birgisson
// s2956190
// Griffith University
// Trimester 1, 2017
// 3420ICT Systems Programming
// Assignment 2
// Milestone 3 - Random 16bit Number Generator
// */

import Foundation

class StorageHandler {
  
  func producer() -> UInt16? {
    
    var randNum: UInt16 = 0
    let flag: Bool = true
    let path = "/dev/random"
    let fd = open(path, O_RDONLY)
    
    if fd != -1 {
      
      // read() will return the size of the thing it read.
      // * CHECK IF r IS THE SAME SIZE AS THE VALUE I AM TRYING TO GET
      // * IF r IS NOT SAME SIZE, THEN I GET ERROR
      while (flag) {
        
        let r = read(fd, &randNum, MemoryLayout<UInt16>.size)
        
        if (r != 2) {
          print("some error with read() ?")
          print(r)
        }
        
        let hex: String = String(randNum, radix: 16)
        print(index)
        print("Random number is '\(randNum)' or '0x\(hex)'")
        
        return(randNum)
      }
      
      
    } else {
      print("error opening /dev/random")
    }
    
    close(fd)
    
    return nil
  }
  
  // buffer is pointer to Struct
  // value is the random number to put into buffer
  func put_buffer(buffer: UnsafeMutableRawPointer) {
    
    var temp = buffer // Struct
    let val = producer()   // Random number
    //print("put_buffer val: \(val)")
    
    typealias StructP = UnsafeMutablePointer<InputStruct>
    let sp: StructP = temp.assumingMemoryBound(to: InputStruct.self)
    
    
    
    
    
  }
  
  func get_buffer() {
    
  }

}
