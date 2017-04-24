/*
 Author: Eli Birgisson
 s2956190
 Griffith University
 Trimester 1, 2017
 3420ICT Systems Programming
 Assignment 2
 Milestone 1 - sync
 */

import Foundation

func repeatFunc(_: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
  
  print("1 start repeatFunc")
  
  if let inputBuffer = readLine() {
    
    print("2 start readline")
    
    print(inputBuffer)
  }
  
  print("1x end of repatFunc ")
  return nil
}


let pointer : UnsafeMutableRawPointer? = nil
var pt: pthread_t?
var s: Int32

s = pthread_create(&pt, nil, repeatFunc, pointer)

if (s != 0) {
  print("some Error")
} else {
  print("it ran??")
}



//guard pthread_create(&pt, nil, repeatFunc, pointer) == 0 && pt != nil
//  else { throw Error
//  
//}

//pthread = pt!

//


//var pthread: pthread_t
//pthread_create(&pthread, nil, { (UnsafeMutableRawPointer) in
//  print("pthread ran")
//  
//  return nil
//}, nil)

