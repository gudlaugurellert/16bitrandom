///*
// Author: Eli Birgisson
// s2956190
// Griffith University
// Trimester 1, 2017
// 3420ICT Systems Programming
// Assignment 2
// Milestone 3 - Random 16bit Number Generator
// */
//
//import Foundation
//
//class RandGen {
//  
//  struct StructBuffer {
////    var min: UnsafeMutablePointer<Int>
////    var max: UnsafeMutablePointer<Int>
//    var buffer: [UnsafeMutablePointer<UInt16>]
//    
//    init( /*_ minimum: UnsafeMutablePointer<Int>,
//          _ maximum: UnsafeMutablePointer<Int>,*/
//          _ randBuffer: UnsafeMutablePointer<UInt16>) {
////      self.min = minimum
////      self.max = maximum
//      self.buffer = [randBuffer]
//    }
//  }
//  
//  func put_buffer() {
//    
//    var bufferStruct = StructBuffer()
//    
//    var randNum: UInt16 = 0
//    let path = "/dev/random"
//    
//    let fd = open(path, O_RDONLY)
//    
//    if fd != -1 {
//      
//      // read() will return the size of the thing it read.
//      // * CHECK IF r IS THE SAME SIZE AS THE VALUE I AM TRYING TO GET
//      // * IF r IS NOT SAME SIZE, THEN I GET ERROR MSG
//      for index in 0...1000 {
//        
////        let r = read(fd, &randNum, MemoryLayout<UInt16>.size)
////        print(r)
//        
//        bufferStruct(read(fd, &randNum, MemoryLayout<UInt16>.size))
//        
//        
//        let hex: String = String(randNum, radix: 16)
//        print("Random number is '\(randNum)' or '0x\(hex)'")
//        print(index)
//        
//      }
//      
//      close(fd)
//    }
//  }
//  
//  func get_buffer() {
//    
//  }
//
//  
//} // Class RandGen end.
//
