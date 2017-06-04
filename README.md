# Systems Programming - Assignment 2
Third year course at Griffith University - Bachelor of IT

## Assignment 2 is split into three Milestones.

### Milestone 1:
```
 The objective of this part is to explore simple thread synchronisation using mutexes 
 by implementing a program that creates a child thread, reads (in the parent thread) a line of input from the user, and sends that line to the child thread for printing (to stdout). The parent thread should then wait for the user to hit return (or enter), then notify the child thread to exit. The parent thread should wait for the child to exit, then print "child thread is gone" and also exit.
```
### Milestone 2:
```
Improve Milestone 1 to fix race conditions by creating manual Sempahores (not use existing POSIX Semaphore)
```
  
### Milestone 3:

```
The goal of this milestone is to solve the Producer/Consumer problem for a random number generator by using semaphores from Milestone 2.

One thread acts as a random number generator that reads true random numbers from the reliable kernel random number source device /dev/random and puts them into a buffer. 

Another thread consumes these random numbers as they come in and prints them on standard output.

It is important that the buffer does not overflow (i.e., the random number generator does not try to put more random numbers into the buffer than the buffer can hold). It is also imporant that the buffer does not underflow (i.e., a random number may only be taken out of the buffer if that does not take the total number that remains in the buffer below the minimum fill level).
```
