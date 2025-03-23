#lang racket

(require brag/support)
(require "./src/grammar.rkt")
(require "./src/tokenizer.rkt")


(define custom-parser (make-rule-parser program))