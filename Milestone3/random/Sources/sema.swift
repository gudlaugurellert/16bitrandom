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

class SemaModule {
  
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
  
  // Creating Variables
  var lock = pthread_mutex_t()
  var val: Int
  var cond = pthread_cond_t()
  
  
  // Initializing Variables
  // value is set in main.swift
  init(value: Int) {

    val = value
    
    // Initializing the mutex
    let m = pthread_mutex_init(&lock, nil)
    // Error check
    if (m != 0) { errorHandler(no: m, msg: "sema.swift mutex_init(&lock) failed") }
    
    // Initializing the condition variable
    let c = pthread_cond_init(&cond, nil)
    // Error check
    if (c != 0) { errorHandler(no: c, msg: "sema.swift cond_init(&cond) failed") }
  }

  deinit {
    print("stuff being deinit")
    // Destroy mutex
    let dm = pthread_mutex_destroy(&lock)
    // Error Check
    if (dm != 0) { errorHandler(no: dm, msg: "sema.swift mutex_destroy(&lock) failed") }
    
    // Destroy condition variable
    let dc = pthread_cond_destroy(&cond)
    // Error check
    if (dc != 0) { errorHandler(no: dc, msg: "sema.swift cond_destroy(&lock) failed") }
  }
}

extension SemaModule {

  func procure() {
    
    // Start critical
    let ml1 = pthread_mutex_lock(&lock)
    
    // Error check
    if (ml1 != 0) { errorHandler(no: ml1, msg: "sema.swift procure() mutex_lock(&lock) failed") }
    
    // Wait for Signal from vacate()
    while(val <= 0) {
      
      let cw = pthread_cond_wait(&cond, &lock)
      // Error check
      if (cw != 0) { errorHandler(no: cw, msg: "sema.swift procure() cond_wait(&cond, &lock) failed") }
    }
    
    // Claim Semaphore
    val -= 1
    
    // End critical
    let mu = pthread_mutex_unlock(&lock)
    // Error check
    if (mu != 0) { errorHandler(no: mu, msg: "sema.swift procure() mutex_unlock(&lock) failed") }
  }

  func vacate() {
    
    // Start critical
    let ml2 = pthread_mutex_lock(&lock)
    // Error Check
    if (ml2 != 0) { errorHandler(no: ml2, msg: "sema.swift vacate() mutex_lock(&lock) failed") }
    
    // Release Semaphore
    val += 1
    
    // Signal Anyone Waiting
    let cs = pthread_cond_signal(&cond)
    // Error Check
    if (cs != 0) { errorHandler(no: cs, msg: "sema.swift vacate() cond_signal(&cond) failed") }
    
    // End Critical
    let mu2 = pthread_mutex_unlock(&lock)
    
    // Error check
    if (mu2 != 0) { errorHandler(no: mu2, msg: "sema.swift vacate() mutex_unlock(&lock) failed") }
  }
}
