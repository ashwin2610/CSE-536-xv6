#ifndef __UTHREAD_H__
#define __UTHREAD_H__

#include <stdbool.h>

#define MAXULTHREADS 100

enum ulthread_state {
  FREE,
  RUNNABLE,
  YIELD,
};

enum ulthread_scheduling_algorithm {
  ROUNDROBIN,   
  PRIORITY,     
  FCFS,         // first-come-first serve
};

struct t_context {
  uint64 ra;
  uint64 sp;

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;

  uint64 a0;
  uint64 a1;
  uint64 a2;
  uint64 a3;
  uint64 a4;
  uint64 a5;
  uint64 a6;
  uint64 a7;
};


struct ulthread {
  // p->lock must be held when using these:
  enum ulthread_state state;        // thread state
  int tid;                     // thread ID
  int priority;
  uint64 start;
  uint64 create_time;

  // these are private to the thread, so p->lock need not be held.
  uint64 stack;               // Virtual address of kernel stack
  struct t_context context;      // swtch() here to run thread
};


#endif