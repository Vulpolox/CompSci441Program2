#lang racket

(require "grammar.rkt")
(require "tokenizer.rkt")

(provide parse)
(provide repl-parse)
(provide execution-loop)

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


(define (modify-exn-message exn-message buffer)
  (define split-exn (string-split exn-message " "))
  (define is-scanner-error (equal? "lexer:" (first split-exn)))

  ;; helper function for looking up
  ;; line number of error
  (define (get-line-number buffer invalid-token)
    (for/fold
      ([current-line-number 1]
       [found #f]
       #:result current-line-number)
      ([current-line buffer])
      (if (or (equal? found #t) 
              (regexp-match? (format "~a" invalid-token) current-line))
          (values current-line-number #t)
          (values (+ current-line-number 1) #f))
    )
  )

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
      (format "Parsing Error at Line ~a" adjusted-line-number)]
  )
)

;; create bindings for the parser and tokenizer/lexer
(define my-parser (make-rule-parser program))
(define my-tokenizer tokenize)


;; partial application of safe-parse for use in the execution loop
(define parse (lambda (input-port) (safe-parse my-parser my-tokenizer input-port)))

;; partial application of safe-parse called "parse" as per the assignment requirements
;; for use in the DrRacket REPL
(define repl-parse (lambda (file-path) 
                      (safe-parse my-parser my-tokenizer 
                                  (open-input-file (format "./parser-input/~a" file-path)))
                   )
)


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