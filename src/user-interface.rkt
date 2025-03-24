#lang racket

(require "grammar.rkt")
(require "tokenizer.rkt")

(provide parse)

(define (safe-parse parser-func tokenizer-func input-port)
  (with-handlers

      ;; catches all errors with the code executed
      ;; in the second body of the with-handlers function
      ([exn:fail? (lambda (e)
                    (printf "Error: ~a/n" (exn-message e)))
                  ])

      ;; code to be executed with error handling
      (parser-func (tokenizer-func input-port)
       (printf "~n-----~nACCEPT"))
  ))


;; create bindings for the parser and tokenizer/lexer
(define my-parser (make-rule-parser program))
(define my-tokenizer tokenize)


;; partial application of safe-parse called "parse" as per the assignment requirements
(define parse (lambda (input-port) (safe-parse my-parser my-tokenizer input-port)))