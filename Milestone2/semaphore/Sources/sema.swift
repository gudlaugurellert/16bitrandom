/*
 Author: Eli Birgisson
 s2956190
 Griffith University
 Trimester 1, 2017
 3420ICT Systems Programming
 Assignment 2
 Milestone 2 - semaphores
 */

public class Sema {

  var m, m2: pthread_mutex_t = thread_mutex_t()
  var cond: pthread_cond_t = pthread_cond_t()
  
  public init() {
    pthread_mutex_init(&m, nil)
    pthread_mutex_init(&m2, nil)
    pthread_cond_init(&cond, nil)
  }
  
  public func lock() {
    pthread_mutex_lock(&self.mutex)
  }
  
  public func unlock() {
    pthread_mutex_unlock(&self.mutex)
  }
  
  public func signal() {
    pthread_cond_signal(&self.cond)
  }
  
  public func destroy() {
    pthread_cond_destroy(&self.cond)
  }
  
  public func procure(c: pthread_cond_t, m: pthread_mutex_t) {
    // start critical
    lock(&m)
    
    while(c <= 0) {
      pthread_cond_wait(&c, &m)
    }
    
    // Decrement by one
    c -= 1
    
    // end critical
    unlock(&m)
  }
  
  public func vacate(c: pthread_cond_t, m: pthread_mutex_t) {
    // start critical?
    lock(m)
    
    // Increment by one
    c += 1
    
    // signal vacate
    signal(c)
    
    // end critical
    unlock(m)
  }
  
  //procure(Semaphore *semaphore)
  //{
  //  begin_critical_section(semaphore);  // make the following concurrency-safe
  //  while (semaphore->value <= 0)
  //  wait_for_vacate(semaphore);     // wait for signal from vacate()
  //  semaphore->value--;                 // claim the Semaphore
  //  end_critical_section(semaphore);
  //}
  //
  //vacate(Semaphore *semaphore)
  //{
  //  begin_critical_section(semaphore);  // make the following concurrency-safe
  //  semaphore->value++;                 // release the Semaphore
  //  signal_vacate(semaphore);           // signal anyone waiting on this
  //  end_critical_section(semaphore);
  //}
  
}
// pthread_cond_signal()
// pthread_cond_destroy()
// pthread_cond_wait() Note that this function takes a mutex as a second parameter
// That mutex must be locked at the time  pthread_cond_wait() gets called




