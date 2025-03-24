#lang racket
(require "./src/user-interface.rkt")


; temporary test input
(define input (open-input-file "./parser-input/file1.txt"))

(syntax->datum (parse input))

