;; extends
; Code primarily written by Chat-GPT

; By default, in TypeScript/JavaScript, a variable is only recognized as a `@constant` if it's written in all caps,
; NOT if it's actually declared with `const`. These overrides ensure these variables are properly
; recognized/highlighted.

; Ensure all variables declared with `const` are correctly recognized and highlighted as `@constant`
(
  (lexical_declaration
    (variable_declarator
      name: (identifier) @constant
    )
  )
  (#set! "priority" 100)
)

; Apply `@constant` to array-destructured constant variables
(
  (lexical_declaration
    (variable_declarator
      name: (array_pattern
              (identifier) @constant
              (_)? @constant)
    )
  )
  (#set! "priority" 100)
)

; Since functions can be declared with `const`, ensure the `@function` identifier has a higher priority than `@constant`
(
  (lexical_declaration
    (variable_declarator
      name: (identifier) @function
      value: [
        (arrow_function)
        (function_expression)
      ]
    )
  )
  (#set! "priority" 110)
)

