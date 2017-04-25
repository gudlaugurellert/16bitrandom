Eli Birgisson
3420ICT Systems Programming
Assignment 2
Milestone 1 - sync

Step 3 Question:
In the parent thread, read one line of input into the buffer.  Print the buffer to stdout from within the child thread (do not synchronise with the parent at this stage). Explain in your README what happens and why!

My Answer:

The program compiles and runs, however, nothing gets printed out to stdout because the main() program, (or the parent thread), terminates before the child thread can even starts/finishes doing its thing. When the parent dies, so does its children!

If I put a decent long sleep() after creating my child thread, it'll print to stdout.