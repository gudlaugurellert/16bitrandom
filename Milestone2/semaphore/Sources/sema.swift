/*
 Author: Eli Birgisson
 s2956190
 Griffith University
 Trimester 1, 2017
 3420ICT Systems Programming
 Assignment 2
 Milestone 2 - semaphores
 */

import Foundation

class SemaModule {

  var lockProcure = pthread_mutex_t()
  var lockVacate = pthread_mutex_t()
  var lockWait = pthread_mutex_t()
  var val: Int32
  var cond = pthread_cond_t()
  
  init(value: Int32) {
    val = value
    pthread_mutex_init(&lockProcure, nil)
    pthread_mutex_init(&lockVacate, nil)
    pthread_mutex_init(&lockWait, nil)
    pthread_cond_init(&cond, nil)
  }

  deinit {
    pthread_mutex_destroy(&lockProcure)
    pthread_mutex_destroy(&lockVacate)
    pthread_mutex_destroy(&lockWait)
    pthread_cond_destroy(&cond)
  }
}
extension SemaModule {
  
  func procure() {
    // Start critical
    pthread_mutex_lock(&lockProcure)
    
    // Wait for Signal from vacate()
    while(val <= 0) {
      pthread_cond_wait(&cond, &lockProcure)
    }
    
    // Claim Semaphore
    val -= 1
    
    // End critical
    pthread_mutex_unlock(&lockProcure)
  }

  func vacate() {
    // Start critical
    pthread_mutex_lock(&lockVacate)
    
    // Release Semaphore
    val += 1
    
    // Signal Anyone Waiting
    pthread_cond_signal(&cond)
    
    // End Critical
    pthread_mutex_unlock(&lockVacate)
  }
}
