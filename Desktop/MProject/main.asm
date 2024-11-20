.data
card_values_str: .asciiz "1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8"
card_values: .space 16  # Space for 16 card values

.text
.globl main
.globl parse_card_values

main:
    # Load card values from card_values_str
    la $a0, card_values_str
    jal parse_card_values

    # Initial draw of the grid
    jal draw_grid

game_loop:
    # Update grid based on user input
    jal update_grid

    # Redraw the grid
    jal draw_grid

    # Loop back for next input
    j game_loop

    # Exit program (unreachable in this loop)
    li $v0, 10
    syscall

# Function to parse card values from string
parse_card_values:
    la $t0, card_values  # Load address of card_values array
    li $t1, 0  # Initialize index

parse_loop:
    lb $t2, 0($a0)  # Load next character
    beqz $t2, end_parse_card_values  # If null terminator, end loop
    beq $t2, ',', skip_comma  # If comma, skip

    sub $t2, $t2, '0'  # Convert ASCII to integer
    sb $t2, 0($t0)  # Store integer in card_values array
    addi $t0, $t0, 1  # Move to next position in array

skip_comma:
    addi $a0, $a0, 1  # Move to next character
    j parse_loop

end_parse_card_values:
    jr $ra
