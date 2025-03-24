#lang racket

(require "grammar.rkt")
(require "tokenizer.rkt")

(provide parse)
(provide execution-loop)

(define (safe-parse parser-func tokenizer-func input-port)
  (with-handlers

      ;; catches all errors with the code executed
      ;; in the second body of the with-handlers function
      ;; -----
      ;; if error is found, prints out the location in
      ;; the input file where the error occured
      {[exn:fail? (lambda (e)
                    (printf "Error: ~a/n" (exn-message e)))
                  ]}

      ;; code to be executed with error handling
      ;; -----
      ;; tokenizes and parses input and produces and prints syntax tree
      ;; along with "ACCEPT" if successful
      {begin (printf "Parse Tree~n-----~n~a" (syntax->datum (parser-func (tokenizer-func input-port))))
             (printf "~n-----~nACCEPT")}
  ))


;; create bindings for the parser and tokenizer/lexer
(define my-parser (make-rule-parser program))
(define my-tokenizer tokenize)


;; partial application of safe-parse called "parse" as per the assignment requirements
(define parse (lambda (input-port) (safe-parse my-parser my-tokenizer input-port)))


;; in:  takes a function; asks user if they want to continue
;; out: if user does, calls function
(define (continue? func)
  (display "\n---\nContinue? Y to Continue, Anything Else to Exit\n   >>>")
  (define input (string-trim (read-line)))

  (if [or (equal? input "Y")
          (equal? input "y")]
      (func)
      (display "---\n"))
  )


;; in:  no args
;; out: returns a valid string file name from user input
(define (get-file-path)
  (display "Enter Parser Input File Name\n   >>>")
  (define input (string-trim (read-line)))
  
  ;; Construct the full path to the file in the parser-input directory
  (define path (format "./parser-input/~a" input))
  
  ;; Check if the file exists
  (if (file-exists? path)
      path
      (begin
        (printf "Error: File Doesn't Exist: ~a~n---~n" path)
        (get-file-path))))


;; in:  no args
;; out: main program execution loop
(define (execution-loop)
    (define file-path (get-file-path))
    (define input-port (open-input-file file-path))
    (begin (parse input-port)
           (continue? execution-loop)))