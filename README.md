# Racket Parser
### CS441 Program 2
***
# Program Description
This program reads in a text file from user input and attempts to tokenize and parse it into an abstract syntax tree based on the below grammar:
***
program → stmt-list  
stmt-list → stmt stmt-list | ε  
stmt → id = expr  
⠀⠀⠀⠀⠀⠀| if (expr) stmt endif;  
⠀⠀⠀⠀⠀⠀| read id;     
⠀⠀⠀⠀⠀⠀| write expr;  
expr → id etail  
⠀⠀⠀⠀⠀⠀| num etail  
etail → + expr  
⠀⠀⠀⠀⠀⠀| - expr  
⠀⠀⠀⠀⠀⠀| compare expr  
⠀⠀⠀⠀⠀⠀| ε   
id → [a-zA-z]+  
num → numsign digit+  
numsign → + | - | ε  
compare → < | <= | > | >= | == | !=
***
If the parse is successful, the program will print "ACCEPT" along with produced the syntax tree to the console; if the parse fails, an error message containing the error type (parsing/scanning) and the line at which it occurs will be printed instead


# Dependencies
- [brag](https://docs.racket-lang.org/brag/) `raco pkg install brag`
# How to Run Code (Windows)
### Using CLI w/ Custom UI
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
4. Download and install DrRacket and Racket
5. Add Racket directory to the system PATH variables
6. Open the terminal and run code `raco pkg install brag` and follow prompts
7. Open [main.rkt](https://github.com/Vulpolox/CompSci441Program2/blob/main/main.rkt) in DrRacket
8. Click 'run' in the DrRacket GUI
9. In the console UI, choose the option to use the REPL
10. In the REPL, run `(parse "<file name>")`
