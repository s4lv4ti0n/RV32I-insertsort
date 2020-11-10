.data
vector:
    .word 1, 2, 2, 1, 5, 6, 7, 8, 9, 10

.text
_start:
    lui s0, 0x10000
    li sp, 0x1000
    j main

main:
    call load_element # Load first value to a0
    mv a1, a0 # move to tmp

    # Loop init
    li t0, 1
    li t1, 10
    j loop_forward

loop_forward:
    call load_element

    beq a0, a1, move_element ## a0 == a1 ? repeat : continue
    bgt a0, a1, move_element ## a0 < a1 ? repeat : continue


    # Inner loop init
    mv t2, t0
    li t3, 0
    j loop_backward

    addi t0, t0, 1
    blt t0, t1, loop_forward
    ret


loop_backward:
    addi t2, t2, -1

    # TODO:
    # CONTINUE FROM HERE!
    #
    #
    #j load_element
    #blt a0, a1, swap_values

    bgt t2, t3, loop_backward
    ret


swap_values:
    slli a3, a3, -2
    add a3, a3, s0
    sw  a2, 40(a3) ## what is this bs
    #store x store, mv, load
    # switch
    #mv a1, a0
    ret

move_element:
    mv a1, a0
    addi t0, t0, 1
    j loop_forward


load_element: # load the element at (s0 + 4*t0) address
    mv a0, t0
    slli a0, a0, 2
    add a0, a0, s0
    lw a0, 0(a0)
    ret

