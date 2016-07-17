module Exceptions::ParserExceptions

data ParserException
    = IllegalConstructorName(str msg)
    ;
