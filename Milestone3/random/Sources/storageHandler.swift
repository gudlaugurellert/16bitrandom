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
  
  func producer() {

    var randNum: UInt16 = 0

    let path = "/dev/random"
    let fd = open(path, O_RDONLY)
    
    if fd != -1 {
      
      // read() will return the size of the thing it read.
      // * CHECK IF r IS THE SAME SIZE AS THE VALUE I AM TRYING TO GET
      // * IF r IS NOT SAME SIZE, THEN I GET ERROR

      while(true) {
        let r = read(fd, &randNum, MemoryLayout<UInt16>.size)
        
        if (r != 2) {
          print("some error with read() ?")
  //        print(r)
        }
        
        let hex: String = String(randNum, radix: 16)
  //      print(index)
        print("Random number is '\(randNum)' or '0x\(hex)'")
        put_buffer(num: randNum)
      }

      
      
    } else {
      print("error opening /dev/random")
    }
    
    close(fd)
  }
  
  // buffer is pointer to Struct
  // value is the random number to put into buffer
  func put_buffer(num: UInt16) {
    var randomNumberGenerated = num
    print("putbuffer: \(randomNumberGenerated)")
    //var temp = bufferStruct // Struct
//      print(bufferStruct.pointee.cmdInput.pointee)
//    print(temp.pointee.cmdInput.pointee)
    //print("put_buffer val: \(val)")

  }
  
  func get_buffer() {
    
  }

}
