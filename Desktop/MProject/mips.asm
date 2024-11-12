.data
    # Represent the face of each card
    board: .word 1, 4, 3, 15, 2, 14, 1, 5, 6, 15, 14, 3, 5, 4, 2, 6
    # Represent whether to display the face of the card (0 -> hidden, 1 -> shown)
    found: .word 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    # Stores guesses
    guess1: .word 0
    guess2: .word 0
    # Stores number of matches
    matches: .word 0
    # Stores number of turns
    turns: .word 0
    # Messages
    help1: .asciiz "This is a memory game in which you guess two cards.\n"
    help2: .asciiz "If the faces of the cards match, you win the pair.\n"
    help3: .asciiz "and they remain face up. Don't waste a turn!\n"
    continue: .asciiz "Enter any number to CONTINUE: "
    prompt: .asciiz "Guess a card (1-16): "
    invalid: .asciiz "Invalid input. Please try again.\n"
    match: .asciiz "Match! :)\n"
    nomatch: .asciiz "No match. :(\n"
    reply: .asciiz "Enter 0 to QUIT. Enter any other number to CONTINUE: "
    quit: .asciiz "Thanks for playing!\n"
    win: .asciiz "Congratulations! Well done!\n"
    prtTurns: .asciiz "Number of turns: "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Initialize the game and display the intro
    jal intro

    # Main game loop
M1:
    # Display the board
    jal printBoard

    # Get first guess
    jal guess
    sw $v0, guess1    # Store guess1

    # Display the board
    jal printBoard

    # Get second guess
    jal guess
    sw $v0, guess2    # Store guess2

    # Display the board
    jal printBoard

    # Check if the two guesses match
    jal check

    # Check if game is won (8 matches)
    lw $t0, matches
    li $t1, 8
    bge $t0, $t1, won

    # Repeat the game if not won
    j M1

won:
    # Print the win message and number of turns
    jal wonMessage
    li $v0, 10
    syscall

# Print the introduction and instructions
intro:
  
    li $v0, 4
    la $a0, help1
    syscall

    li $v0, 4
    la $a0, help2
    syscall

    li $v0, 4
    la $a0, help3
    syscall

    li $v0, 4
    la $a0, continue
    syscall

    # Wait for user input to continue
    li $v0, 5
    syscall
    move $t0, $v0
    jr $ra

# Print the board with hidden and displayed cards
printBoard:
    # Clear screen
    li $v0, 11
    li $a0, 12  # ASCII code for clear screen
    syscall

    # Display the board row by row (4 cards per row)
    li $t0, 0       # Initialize index for board
    li $t1, 0       # Initialize row counter
    li $t2, 4       # Number of columns per row

printBoardLoop:
    # Check if it's time to end the board (after 16 cards)
    bge $t0, 16, printBoardEnd

    # Load the card face value and the found status
    la $t3, board
    lw $t4, 0($t3)      # Load card face
    la $t5, found
    lw $t6, 0($t5)      # Load found status

    # If the card is found (shown), display the card face
    beqz $t6, printHidden
    # Print the card face
    li $v0, 1
    move $a0, $t4
    syscall
    j printSpace

printHidden:
    # Print a hidden card placeholder
    li $v0, 11
    li $a0, 42  # ASCII code for a placeholder character
    syscall

printSpace:
    # Print space between cards
    li $v0, 11
    li $a0, 32  # ASCII code for space
    syscall

    # Increment the index and row
    addi $t0, $t0, 1
    addi $t1, $t1, 1

    # Print a newline after every 4th card
    bge $t1, $t2, printNewline
    j printBoardLoop

printNewline:
    # Print newline after 4 cards
    li $v0, 4
    la $a0, newline
    syscall
    li $t1, 0
    j printBoardLoop

printBoardEnd:
    jr $ra

# Get a valid guess from the user
guess:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # Get the user input
    li $v0, 5
    syscall
    move $t0, $v0

    # Check if input is valid (between 1 and 16)
    li $t1, 1
    li $t2, 16
    blt $t0, $t1, invalidInput
    bgt $t0, $t2, invalidInput

    # Return the valid guess
    jr $ra

invalidInput:
    # Print invalid input message
    li $v0, 4
    la $a0, invalid
    syscall
    j guess

# Check if the two guesses match
check:
    lw $t0, guess1
    lw $t1, guess2

    # Load the corresponding card values
    la $t2, board
    lw $t3, 0($t2)       # First guess value
    la $t4, board
    lw $t5, 0($t4)       # Second guess value

    # Check if the two guessed cards match
    beq $t3, $t5, matchFound
    j noMatch

matchFound:
    # Mark both cards as found
    la $t6, found
    sw $zero, 0($t6)     # Set found to 1 for guess1
    sw $zero, 4($t6)     # Set found to 1 for guess2

    # Increment matches and turns
    lw $t7, matches
    addi $t7, $t7, 1
    sw $t7, matches

    lw $t8, turns
    addi $t8, $t8, 1
    sw $t8, turns

    # Print match message
    li $v0, 4
    la $a0, match
    syscall
    jr $ra

noMatch:
    # Print no match message
    li $v0, 4
    la $a0, nomatch
    syscall

    # Increment turns
    lw $t9, turns
    addi $t9, $t9, 1
    sw $t9, turns

    jr $ra

# Print the win message and number of turns
wonMessage:
    li $v0, 4
    la $a0, win
    syscall

    li $v0, 4
    la $a0, prtTurns
    syscall

    # Print number of turns
    li $v0, 1
    lw $a0, turns
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    jr $ra


