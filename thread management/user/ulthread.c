/* CSE 536: User-Level Threading Library */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "user/ulthread.h"
#include "kernel/param.h"
#include "kernel/riscv.h"

/* Standard definitions */
#include <stdbool.h>
#include <stddef.h>

struct ulthread thread[MAXULTHREADS];
int sched_pointer = 0;
int n_threads = 0;

struct ulthread *init_thread;

int nexttid = 1;
int n_threads_runnable = 0;
// int scheduler_tid;

struct ulthread *current_thread;


enum ulthread_scheduling_algorithm sched_algo;

/* Get thread ID */
int get_current_tid(void) {
    return current_thread->tid;
}

/* Thread initialization */
void ulthread_init(int schedalgo) {
    struct ulthread *ult;

    memset(&thread[0].context, 0, sizeof(&thread[0].context));
    thread[0].tid = 0;

    for(ult = thread; ult < &thread[MAXULTHREADS]; ult++) {
        ult->state = FREE;       
    }

    sched_algo = schedalgo;
}

/* Thread creation */
bool ulthread_create(uint64 start, uint64 stack, uint64 args[], int priority) {
    /* Please add thread-id instead of '0' here. */
    printf("[*] ultcreate(tid: %d, ra: %p, sp: %p)\n", nexttid, start, stack);

    struct ulthread *ult = thread;
    ++ ult;

    for (; ult < &thread[MAXULTHREADS]; ult ++) {
        if (ult->state == FREE) {
            ult->tid = nexttid;
            nexttid ++;

            ult->priority = priority;
            ult->stack = stack;
            ult->start = start;
            ult->state = RUNNABLE;
            ult->create_time = r_time();

            memset(&ult->context, 0, sizeof(ult->context));
            // p->context.ra = (uint64)forkret;
            ult->context.sp = ult->stack + PGSIZE;
            
            // int arglength = sizeof(args)/sizeof(uint64);

            ult->context.a0 = args[0];
            ult->context.a1 = args[1];
            ult->context.a2 = args[2];
            ult->context.a3 = args[3];
            ult->context.a4 = args[4];
            ult->context.a5 = args[5];
            ult->context.a6 = args[6];
            ult->context.a7 = args[7];

            n_threads ++;
            n_threads_runnable ++;

            break;

        }
    }

    
    return true;
}

/* Thread scheduler */
void ulthread_schedule(void) {    
    struct ulthread *t;
    struct ulthread *t1;

    for(;n_threads_runnable > 0;) {
        switch (sched_algo)
        {
        case FCFS:
            int min_time = r_time();

            for (int i = sched_pointer; i < n_threads; i++) {
                t1 = &thread[i+1];
                if (t1->state == YIELD) {
                    t1->state = RUNNABLE;
                } else if (t1->state == RUNNABLE) {
                    if (min_time > t1->create_time) {
                        t = t1;
                        min_time = t->create_time;
                    }
                }

            }
            break;

        
        case ROUNDROBIN:
            for (int i = sched_pointer;;i = (i+1) % n_threads) {
                t = &thread[i+1];
                if (t->state == YIELD) {
                    t->state = RUNNABLE;
                } else if (t->state == RUNNABLE) {
                    sched_pointer = i;
                    break;
                }
            }
            break;

        
        case PRIORITY:
            int max_priority = -1;

            for (int i = 0; i < n_threads ; i++) {
                t1 = &thread[i+1];
                if (t1->state == YIELD) {
                    t1->state = RUNNABLE;
                } else if (t1->state == RUNNABLE) {
                    if (max_priority < t1->priority) {
                        t = t1;
                        max_priority = t->priority;
                    }
                }
            }
            break;

        default:
            break;
        }

        /* Add this statement to denote which thread-id is being scheduled next */
        printf("[*] ultschedule (next tid: %d)\n", t->tid);

        // Switch between thread contexts
        current_thread = t;
        ulthread_context_switch(&thread[0].context, &thread[t->tid].context);
    }

    return;
}

/* Yield CPU time to some other thread. */
void ulthread_yield(void) {

    /* Please add thread-id instead of '0' here. */
    printf("[*] ultyield(tid: %d)\n", current_thread->tid);
    struct ulthread *t = current_thread;
    
    t->state = YIELD;
    ulthread_context_switch(&thread[current_thread->tid].context, &thread[0].context);
}

/* Destroy thread */
void ulthread_destroy(void) {
    printf("[*] ultdestroy(tid: %d)\n", current_thread->tid);
    struct ulthread *t = current_thread;
    
    t->state = FREE;
    n_threads_runnable --;
    ulthread_context_switch(&thread[current_thread->tid].context, &thread[0].context);
}
