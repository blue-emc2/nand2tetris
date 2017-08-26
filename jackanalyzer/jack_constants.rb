module JackConstants

  SYMBOLS = %w({ } ( ) [ ] . , ; + - * / & < > = ~ |)

  CLASS = 'class'
  CONSTRUCTOR = 'constructor'
  FUNCTION = 'function'
  METHOD = 'method'
  FIELD = 'field'
  STATIC = 'static'
  VAR = 'var'
  INT = 'int'
  CHAR = 'char'
  BOOLEAN = 'boolean'
  VOID = 'void'
  TRUE = 'true'
  FALSE = 'false'
  NULL = 'null'
  THIS = 'this'
  LET = 'let'
  DO = 'do'
  IF = 'if'
  ELSE = 'else'
  WHILE = 'while'
  RETURN = 'return'

  L_BRACE = '{'
  R_BRACE = '}'
  SEMICOLON = ';'
  L_ROUND_BRACKET = '('
  R_ROUND_BRACKET = ')'
  L_SQUARE_BRACKET = '['
  R_SQUARE_BRACKET = ']'
  EQ = '='
  DOT = '.'
  COMMA = ','

  KEYWORDS = [
    CLASS,
    CONSTRUCTOR,
    FUNCTION,
    METHOD,
    FIELD,
    STATIC,
    VAR,
    INT,
    CHAR,
    BOOLEAN,
    VOID,
    TRUE,
    FALSE,
    NULL,
    THIS,
    LET,
    DO,
    IF,
    ELSE,
    WHILE,
    RETURN
  ]
  
  TYPES = %w(int char boolean)
  SUBROUTINE_KEYWORDS = [CONSTRUCTOR, FUNCTION, METHOD]
  KEYWORD_CONSTANT = [TRUE, FALSE, NULL, THIS]
  STATEMENT_WORDS = [LET, WHILE, DO, RETURN, IF]
  OPERATIONS = %w(+ - * & | < > =)
  BRACKETS = %w({ } [ ] ( ))

end
