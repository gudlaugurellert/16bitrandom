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
  
  func producer(strukkt: UnsafeMutableRawPointer) {
    
    let testing = strukkt
    let sp: StructP = testing.assumingMemoryBound(to: InputStruct.self)
    
    var randNum: UInt16 = 0

    let path = "/dev/random"
    let fd = open(path, O_RDONLY)

    if fd != -1 {
      
      while (!sp.pointee.exitFlag.pointee) {
        
        let r = read(fd, &randNum, MemoryLayout<UInt16>.size)
        
        sp.pointee.sem3.pointee.procure()
        sp.pointee.sem1.pointee.procure()
        
        put_buffer(number: randNum, strukkt: testing)
        
        if (r != 2) { print("some error with read() ?") }
        
        sp.pointee.sem1.pointee.vacate()
        sp.pointee.sem2.pointee.vacate()
        
      }
    } else {
      print("error opening /dev/random")
    }
    
    close(fd)
  }
  
  func put_buffer(number: UInt16, strukkt: UnsafeMutableRawPointer) {
    
    let numberToStore = number
    
    let testing = strukkt
    let sp: StructP = testing.assumingMemoryBound(to: InputStruct.self)
    
    if (sp.pointee.numberBuffer.pointee.count < sp.pointee.max.pointee) {
      sp.pointee.numberBuffer.pointee.append(numberToStore)
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
