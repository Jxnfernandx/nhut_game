# main.asm
.text
.globl main

main:
    # Save $ra before starting the game
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Initialize the game board
    jal initialize_board

game_loop:
    # Draw the game grid
    jal draw_grid

    # Call game logic to ask for input and check if cards match
    jal game_logic

    # Check if game over
    beq $v0, 1, game_over  # If $v0 == 1, game over

    # Optional: render graphics if implemented
    jal graphics_render

    # Optional: play sounds if implemented
    jal sound_playback

    # Continue game loop until game ends
    j game_loop

game_over:
    # Restore $ra before exiting
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    # Exit game
    li $v0, 10
    syscall
