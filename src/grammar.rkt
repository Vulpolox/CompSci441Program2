#lang brag

;; EXAMPLE GRAMMAR FROM DOCUMENTATION

;; sentence: verb optional-adjective object
;; verb: greeting
;; optional-adjective: ["happy" "frumpy"]
;; greeting: "hello" | "hola" | "aloha"
;; object: "world" | WORLD


;; NOTES: terminals are string literals; non-terminals are lowercase identifiers;
;; epsilons are ∅


;; GRAMMAR

program: "{" stmt-list "}" "$$"
stmt-list: stmt stmt-list | ∅
stmt: id "=" expr ";"
    | "if" "(" expr ")" stmt-list "endif" ";"
    | "read" id ";"
    | "write" expr ";"
expr: id etail
    | num etail
etail: "+" expr
     | "-" expr
     | compare expr
     | ∅
id: letter+
letter: "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
      | "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"
num: numsign digit+
digit: "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
numsign: "+" | "-" | ∅
compare: "<" | "<=" | ">" | ">=" | "==" | "!="

