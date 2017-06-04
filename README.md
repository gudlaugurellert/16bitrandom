# Assignment2
Systems Programming - Assignment 2

Assignment 2 is split into three Milestones.

Milestone 1:
  Simple thread synchronisation using mutexes.
  
Milestone 2:
  Change Milestone1 to use manually created semaphores.
  
Milestone 3:
  16 bit random number generator using dev/random.
  Solve Producer/Consumer problem.
  One thread reads 'dev/random' and populates a buffer with all the random numbers as fast as it can.
  Another thread reads that buffer and prints to stdout as fast as it can.
  Using semaphores, the stdout thread must wait if there are not enough random numbers available in the buffer.
