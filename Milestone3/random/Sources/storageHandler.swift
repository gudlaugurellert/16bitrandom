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
  typealias StructP = UnsafeMutablePointer<InputStruct>
  
  func producer(/*strukkt: UnsafeMutableRawPointer*/) -> UInt16? {
    
//    let testing = strukkt
//    let sp: StructP = testing.assumingMemoryBound(to: InputStruct.self)
    
//    print("producer: \(sp.pointee.max.pointee)")
    
    var randNum: UInt16 = 0

    let path = "/dev/random"
    let fd = open(path, O_RDONLY)

    if fd != -1 {

      let r = read(fd, &randNum, MemoryLayout<UInt16>.size)
      
      if (r != 2) { print("some error with read() ?") }
      
//      let hex: String = String(randNum, radix: 16)
//      print("Random number is '\(randNum)' or '0x\(hex)'")
      
      return randNum
    } else {
      print("error opening /dev/random")
      return nil
    }

    close(fd)
    return nil
  }
  
  func put_buffer(strukkt: UnsafeMutableRawPointer) {
    
    let testing = strukkt
    let sp: StructP = testing.assumingMemoryBound(to: InputStruct.self)
    
    // Populating the buffer with random numbers
    for _ in 0..<sp.pointee.max.pointee {
      
      if let randomNumberGenerated = producer(/*strukkt: testing*/) {
        
        sp.pointee.numberBuffer.pointee.append(randomNumberGenerated)
      }
    }
    print("something put in buffer")
  }
  
  
  func get_buffer(strukkt: UnsafeMutableRawPointer) -> UInt16 {
    
    let testing = strukkt
    let sp: StructP = testing.assumingMemoryBound(to: InputStruct.self)
    
    let oldestNumber = sp.pointee.numberBuffer.pointee.removeFirst()
    print("something removed from buffer")
    return oldestNumber
  }
}
