# UserInput.asm

.data
prompt_row:        .asciiz "Enter row number (0-3): "
prompt_col:        .asciiz "Enter column number (0-3): "
invalid_input_msg: .asciiz "Invalid input. Please try again.\n"

.text
.globl get_user_input

get_user_input:
    # Save the return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

input_row:
    # Prompt for row number
    li $v0, 4            # syscall for print string
    la $a0, prompt_row   # address of prompt_row
    syscall

    # Read row input
    li $v0, 5            # syscall for read integer
    syscall
    move $t0, $v0        # Store the row input in $t0

    # Validate row input (should be between 0 and 3)
    blt $t0, 0, invalid_input_row
    bgt $t0, 3, invalid_input_row

input_col:
    # Prompt for column number
    li $v0, 4            # syscall for print string
    la $a0, prompt_col   # address of prompt_col
    syscall

    # Read column input
    li $v0, 5            # syscall for read integer
    syscall
    move $t1, $v0        # Store the column input in $t1

    # Validate column input (should be between 0 and 3)
    blt $t1, 0, invalid_input_col
    bgt $t1, 3, invalid_input_col

    # Calculate card index: index = (row * 4) + column
    mul $t2, $t0, 4      # $t2 = $t0 * 4
    add $t2, $t2, $t1    # $t2 = $t2 + $t1

    # Return the card index in $v0
    move $v0, $t2

    # Restore the return address and stack pointer
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra               # Return to the caller

invalid_input_row:
    # Invalid row input message
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j input_row          # Prompt for row input again

invalid_input_col:
    # Invalid column input message
    li $v0, 4
    la $a0, invalid_input_msg
    syscall
    j input_col          # Prompt for column input again
