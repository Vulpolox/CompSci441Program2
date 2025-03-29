#lang brag

;; EXAMPLE GRAMMAR FROM DOCUMENTATION

;; sentence: verb optional-adjective object
;; verb: greeting
;; optional-adjective: ["happy" "frumpy"]
;; greeting: "hello" | "hola" | "aloha"
;; object: "world" | WORLD


;; NOTES: terminals are all caps identifiers
;; non-terminals are lowercase identifiers;
;; epsilons are ∅


;; GRAMMAR

;program: LBRAC stmt-list RBRAC END
program: stmt-list END
stmt-list: stmt stmt-list | ∅
stmt: id EQUALS expr SEMICOLON
    | IF LPAREN expr RPAREN stmt-list ENDIF SEMICOLON
    | READ id SEMICOLON
    | WRITE expr SEMICOLON
expr: id etail
    | num etail
num: [NUMSIGN] DIGIT+
etail: PLUS expr
     | MINUS expr
     | COMPARE expr
     | ∅
id: LETTER+
