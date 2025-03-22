#lang brag

expr : expr "+" term
     | expr "-" term
     | term

term : term "*" factor
     | term "/" factor
     | factor

factor : NUMBER
       | "(" expr ")"

