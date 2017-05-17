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

/*
 Create a function that, in a loop, reads high quality 16 bit random numbers of type uint16_t
 for C/C++/Objective-C (as defined in <stdint.h>)
 or UInt16 for Swift from /dev/random as fast as it can.
 */


var randNum: UInt16 = 0

//var randomPath = "/dev/random"

let fd = open("/dev/random", O_RDONLY)

if fd != -1 {
  
  // read() will return the size of the thing it read.
  // * CHECK IF r IS THE SAME SIZE AS THE VALUE I AM TRYING TO GET
  // * IF r IS NOT SAME SIZE, THEN I GET ERROR MSG
  for index in 0...1000 {
    
    var r = read(fd, &randNum, MemoryLayout<UInt16>.size)
    print(r)
    
    var hex: String = String(randNum, radix: 16)
    print("Random number is '\(randNum)' or '0x\(hex)'")
    print(index)
  }
  
  close(fd)
  
}
