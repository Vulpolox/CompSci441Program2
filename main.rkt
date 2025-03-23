#lang racket

(require "./src/grammar.rkt")
(require "./src/tokenizer.rkt")


(define my-parser (make-rule-parser program))

; temporary test input
(define input (open-input-file "./parser-input/file1.txt"))

(define (safe-parse parser-func tokenizer-func input-port)
    (with-handlers
        
        ;; catches all errors with the code executed
        ;; in the second body of the function
        ([exn:fail? (lambda (e) 
                    (printf "Error: ~a/n" (exn-message e)))
        ])

        ;; code to be executed with error handling
        (parser-func (tokenizer-func input-port))
    ))

(safe-parse my-parser tokenize input)