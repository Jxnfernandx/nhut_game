# GameLogic.asm
.data
matched_pairs: .word 0
matched_msg: .asciiz "You found a match!\n"
not_matched_msg: .asciiz "Not a match. Try again.\n"
same_card_msg: .asciiz "You selected the same card. Try again.\n"

.text
.globl game_logic
.globl main

game_logic:
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    # Get first input from player
    jal get_user_input
    move $s0, $v0  # First card index

    # Reveal first card
    la $t1, card_states
    add $t2, $t1, $s0
    li $t3, 1
    sb $t3, 0($t2)  # Set state to 1 (revealed)

    # Draw the grid
    jal draw_grid

    # Get second input from player
    jal get_user_input
    move $s1, $v0  # Second card index

    # Check if the same card was selected
    beq $s0, $s1, same_card_selected

    # Reveal second card
    la $t1, card_states
    add $t2, $t1, $s1
    sb $t3, 0($t2)  # Set state to 1 (revealed)

    # Draw the grid
    jal draw_grid

    # Load card values
    la $t1, card_values
    add $t2, $t1, $s0
    lb $t5, 0($t2)
    add $t2, $t1, $s1
    lb $t6, 0($t2)

    # Compare card values
    bne $t5, $t6, not_matched

cards_match:
    # Lock the cards
    li $t7, 2
    la $t1, card_states
    add $t2, $t1, $s0
    sb $t7, 0($t2)
    add $t2, $t1, $s1
    sb $t7, 0($t2)

    # Update matched pairs
    lw $t8, matched_pairs
    addi $t8, $t8, 1
    sw $t8, matched_pairs

    # Check for game over
    li $t9, 8
    beq $t8, $t9, game_over_logic

    # Display match message
    li $v0, 4
    la $a0, matched_msg
    syscall
    li $v0, 0  # Game continues
    j end_game_logic

not_matched:
    # Hide the cards again
    li $t3, 0
    la $t1, card_states
    add $t2, $t1, $s0
    sb $t3, 0($t2)
    add $t2, $t1, $s1
    sb $t3, 0($t2)

    # Display not matched message
    li $v0, 4
    la $a0, not_matched_msg
    syscall
    li $v0, 0  # Game continues
    j end_game_logic

same_card_selected:
    # Display message
    li $v0, 4
    la $a0, same_card_msg
    syscall
    li $v0, 0  # Game continues
    j end_game_logic

game_over_logic:
    # Indicate game over
    li $v0, 1  # Game over

end_game_logic:
    # Restore registers
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra
