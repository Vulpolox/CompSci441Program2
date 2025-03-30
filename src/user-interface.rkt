#lang racket

(require "grammar.rkt")
(require "tokenizer.rkt")

(provide parse)
(provide execution-loop)
(provide continue?)


;; ----- PARSER WRAPPER ------------------------------------------

;; wrapper function for handling errors while parsing
;; signature: (func, func, input-port) -> void
(define (safe-parse parser-func tokenizer-func input-port)
  ;; buffer for looking up the lines at which errors occur
  (define buffer (port->lines (peeking-input-port input-port)))
  (with-handlers

      ;; catches all errors with the code executed
      ;; in the second body of the with-handlers function
      ;; -----
      ;; if error is found, prints out the location in
      ;; the input file where the error occured
      {[exn:fail? (lambda (e)
                    (printf "Error: ~a~n" (modify-exn-message (exn-message e) buffer)))
                  ]}

      ;; code to be executed with error handling
      ;; -----
      ;; tokenizes and parses input and produces and prints syntax tree
      ;; along with "ACCEPT" if successful
      {begin (printf "Parse Tree~n-----~n~a" (syntax->datum (parser-func (tokenizer-func input-port))))
             (printf "~n-----~nACCEPT")}
  ))


;; ----- ERROR MESSAGE HANDLING ------------------------------------------

;; function for manipulating brag's default parser error messages
;; signature: (string, list<string>) -> string
(define (modify-exn-message exn-message buffer)
  (define split-exn (string-split exn-message " "))
  (define is-scanner-error (equal? "lexer:" (first split-exn)))

  ;; helper function for looking up line number of invalid token in the buffer
  ;; signature: (list<string>, string) -> int
  (define (get-line-number buffer invalid-token)
    (for/fold
      ([current-line-number 1]
       [found #f]
       #:result current-line-number)
      ([current-line buffer])
      (if (or (equal? found #t) 
              (string-contains? current-line (format "~a" invalid-token)))
          (values current-line-number #t)
          (values (+ current-line-number 1) #f))
    )
  )
  
  ;; return string w/ line number and offending invalid token for scanning errors,
  ;; return string w/ approximate line number for parsing errors
  (if is-scanner-error
    [let* 
      ([raw-invalid-token (ninth split-exn)]
       [invalid-token (first (string-split raw-invalid-token "\""))]
       [line-number (get-line-number buffer invalid-token)])
      (format "Scaning Error at Line ~a; Invalid Token \"~a\"" line-number invalid-token)]
    [let*
      ([raw-line-number (string-split (list-ref split-exn 10) "[line=")]
       [string-line-number (first raw-line-number)]
       [string-line-number-no-comma (first (string-split string-line-number ","))]
       [line-number (string->number string-line-number-no-comma)]
       [adjusted-line-number (- line-number 1)])
      (format "Parsing Error at/around Line ~a" adjusted-line-number)]
  )
)


;; ----- MAIN FUNCTIONS ------------------------------------------

;; create bindings for the parser and tokenizer/lexer
(define my-parser (make-rule-parser program))
(define my-tokenizer tokenize)

;; partial application of safe-parse for use in the execution loop
(define el-parse (lambda (input-port) (safe-parse my-parser my-tokenizer input-port)))

;; partial application of safe-parse called "parse" as per the assignment requirements
;; for use in the DrRacket REPL
(define parse (lambda (file-path) 
                      (safe-parse my-parser my-tokenizer 
                                  (open-input-file (format "./parser-input/~a" file-path)))
              )
)


;; ----- INTERFACE ------------------------------------------

;; function for use in the execution loop; keeps calling 'func' until user indicates
;; they don't want to continue
;; signature: (func, [string]) -> (func) or void
(define (continue? func [message "Continue [y], Exit [any other key]"])
  (printf "~n~a~n---~n   >>>" message)
  (define input (string-trim (read-line)))

  (if [or (equal? input "Y")
          (equal? input "y")]
      (func)
      (printf "---~n"))
  )

;; function for use in the execution loop; gets a valid file name from user input
;; signauture: () -> string
(define (get-file-path)
  (display "Enter Parser Input File Name\n   >>>")
  (define input (string-trim (read-line)))
  
  ;; construct file path
  (define path (format "./parser-input/~a" input))
  
  ;; if file exists, return the path, otherwise print error and recurse
  (if (file-exists? path)
      path
      (begin
        (printf "Error: File Doesn't Exist: ~a~n---~n" path)
        (get-file-path))))

;; execution loop
(define (execution-loop)
    (define file-path (get-file-path))
    (define input-port (open-input-file file-path))
    (begin (el-parse input-port)
           (continue? execution-loop)))