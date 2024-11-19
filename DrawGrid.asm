# DrawGrid.asm
.data
prompt_grid: .asciiz "Game Grid:\n"
index_header: .asciiz "   0   1   2   3\n"
card_back: .asciiz "[?]"
new_line: .asciiz "\n"
space: .asciiz " "

card_states: .space 16  # All initialized to 0
card_values: .byte 1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8

.text
.globl draw_grid

draw_grid:
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    # Print grid header
    li $v0, 4
    la $a0, prompt_grid
    syscall
    la $a0, index_header
    syscall

    # Initialize row counter
    li $s0, 0

row_loop:
    bge $s0, 4, end_draw_grid

    # Print row number
    li $v0, 1
    move $a0, $s0
    syscall

    # Print space
    li $v0, 4
    la $a0, space
    syscall

    # Initialize column counter
    li $s1, 0

col_loop:
    bge $s1, 4, next_row

    # Calculate card index
    mul $t0, $s0, 4
    add $t0, $t0, $s1

    # Get card state
    la $t1, card_states
    add $t2, $t1, $t0
    lb $t3, 0($t2)

    # Print card based on state
    beq $t3, 0, print_hidden

    # Print card value
    la $t1, card_values
    add $t2, $t1, $t0
    lb $a0, 0($t2)
    li $v0, 1
    syscall
    j end_print_card

print_hidden:
    # Print [?]
    li $v0, 4
    la $a0, card_back
    syscall

end_print_card:
    # Print space
    li $v0, 4
    la $a0, space
    syscall

    # Next column
    addi $s1, $s1, 1
    j col_loop

next_row:
    # New line
    li $v0, 4
    la $a0, new_line
    syscall

    # Next row
    addi $s0, $s0, 1
    j row_loop

end_draw_grid:
    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra
