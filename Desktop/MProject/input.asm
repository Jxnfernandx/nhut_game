.data
prompt_row: .asciiz "Enter row (0-3): "
prompt_col: .asciiz "Enter column (0-3): "
card_states: .space 16  # All initialized to 0

.text
.globl update_grid

update_grid:
    # Save registers
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    # Prompt for row input
    li $v0, 4
    la $a0, prompt_row
    syscall

    # Read row input
    li $v0, 5
    syscall
    move $s0, $v0  # Store row input in $s0

    # Prompt for column input
    li $v0, 4
    la $a0, prompt_col
    syscall

    # Read column input
    li $v0, 5
    syscall
    move $s1, $v0  # Store column input in $s1

    # Calculate card index
    mul $t0, $s0, 4
    add $t0, $t0, $s1

    # Update card state to revealed (1)
    la $t1, card_states
    add $t2, $t1, $t0
    li $t3, 1
    sb $t3, 0($t2)

    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra
