module Exceptions::ParserExceptions

data ParserException
    = IllegalConstructorName(str msg, loc at)
    | IllegalObjectOperator(str msg, loc at)
    | IllegalMember(str msg, loc at)
    | IllegalControllerName(str msg, loc at)
    | ConstructorNotAllowed(str msg, loc at)
    | RelationNotAllowed(str msg, loc at)
    | ActionNotAllowed(str msg, loc at)
    | EntityNotImported(str msg, loc at)
    ;
