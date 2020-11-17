# Kind of works, but the solution is not efficient

.data
vector:
    .word 1, 2, 2, 1, 5, 6, 7, 8, 9, 10
    #.word 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

.text
_start:
    lui s0, 0x10000
    li sp, 0x1000
    j main

main:
    #counters init
    li t0, 0
    li t4, 8 # Iterate X-2 times, X is number of elements
    j outer_loop

outer_loop:
    call load_a1_a0
    blt a1, a0, panic # a1 < a0 ? panic : proceed

    # final conditions check
    beq t0, t4, stop
    addi t0, t0, 1
    j outer_loop

panic:
    call save_a1_a0
    beq t0, zero, outer_loop
    mv t5, t0 # Save to tmp
    j inner_loop

inner_loop:
    beq t0, zero, continue_to_outer
    addi t0, t0, -1
    call load_a1_a0
    blt a1, a0, save_a1_a0 # a1 < a0 ? save : proceed
    j inner_loop

save_a1_a0:
    mv a3, t0
    slli a3, a3, 2
    add a3, a3, s0
    sw  a1, 0(a3)
    sw  a0, 4(a3)
    mv a1, a0
    ret

load_a1_a0:
    mv a0, t0
    slli a0, a0, 2
    add a0, a0, s0
    lw a1, 4(a0)
    lw a0, 0(a0)
    ret

continue_to_outer:
    mv t0, t5 # Restore from tmp
    j outer_loop

stop:
    beq x0, x0, 0