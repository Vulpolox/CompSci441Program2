#lang racket

(require br-parser-tools/lex)
(require brag/support)

(provide tokenize)

;; EXAMPLE TOKENIZER FROM DOCUMENTATION

#|
(define (tokenize ip)
  (port-count-lines! ip)
  (define my-lexer
    (lexer-src-pos
     [(repetition 1 +inf.0 numeric)
      (token 'INTEGER (string->number lexeme))]
     [upper-case
      (token 'STRING lexeme)]
     ["b"
      (token 'STRING " ")]
     [";"
      (token ";" lexeme)]
     [whitespace
      (token 'WHITESPACE lexeme #:skip? #t)]
     [(eof)
      (void)]))
  (define (next-token) (my-lexer ip))
  next-token)
|#


;; TOKENIZER

(define (tokenize ip)
  (port-count-lines! ip)
  (define my-lexer
    (lexer-src-pos

     ;; misc. terminals
     ["{" (token 'LBRAC lexeme)]
     ["}" (token 'RBRAC lexeme)]
     ["if" (token 'IF lexeme)]
     ["(" (token 'LPAREN lexeme)]
     [")" (token 'RPAREN lexeme)]
     ["endif" (token 'ENDIF lexeme)]
     ["read" (token 'READ lexeme)]
     ["write" (token 'WRITE lexeme)]
     [";" (token 'SEMICOLON lexeme)]
     ["=" (token 'EQUALS lexeme)]
     ["+" (token 'PLUS lexeme)]
     ["-" (token 'MINUS lexeme)]

     ;; comparison symbols
     [(union "<=" ">=" "==" "!=" "<" ">") (token 'COMPARE lexeme)]

     ;; letter
     [(union (char-range #\a #\z) (char-range #\A #\Z))
      (token 'LETTER lexeme)]

     ;; numsign
     [(union "+" "-") (token 'NUMSIGN lexeme)]

     ;; digit
     [numeric (token 'DIGIT lexeme)]

     ;; whitespace
     [whitespace (token 'WHITESPACE lexeme #:skip? #t)]

     ;; end of program
     ["$$" (token 'END lexeme)]

     ;; eof
     [(eof) (token 'EOF lexeme)]))

  ;; Return a function that generates tokens
  (define (next-token) (my-lexer ip))
  next-token)
