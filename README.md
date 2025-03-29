# Racket Parser
### CS441 Program 2
***
# How to Run Code (Windows)
### Using CLI
1. Clone this repository
2. Add parser input files to the [./parser-input](https://github.com/Vulpolox/CompSci441Program2/tree/main/parser-input) directory
3. Download and install Racket
4. Add Racket directory to the system PATH variables
5. Open the terminal and run code `raco pkg install brag` and follow prompts
6. In the terminal, cd into the local repository `cd <path to local repo>`
7. In the terminal, `racket main.rkt`
### Using DrRacket REPL
1. Clone this repository
2. Add parser input files to the [./parser-input](https://github.com/Vulpolox/CompSci441Program2/tree/main/parser-input) directory
3. In [main.rkt](https://github.com/Vulpolox/CompSci441Program2/blob/main/main.rkt), comment out line 5 `(execution-loop)`
4. Download and install DrRacket and Racket
5. Add Racket directory to the system PATH variables
6. Open the terminal and run code `raco pkg install brag` and follow prompts
7. Open [main.rkt](https://github.com/Vulpolox/CompSci441Program2/blob/main/main.rkt) in DrRacket
8. Click 'run'
9. In the REPL, run `(repl-parse "<file name>")`
