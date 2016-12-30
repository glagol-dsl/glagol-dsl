module Exceptions::ParserExceptions

data ParserException
    = IllegalConstructorName(str msg)
    | IllegalObjectOperator(str msg)
    | IllegalMember(str msg)
    | EntityNotImported(str msg)
    ;
