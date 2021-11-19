grammar Glagol;

namespace
    : 'namespace' identifier ';' (declarations+=declaration)* EOF
    ;

declaration
    : entity
    | repository
    | value
    | controller
    | service
    | proxy
    ;

entity : 'entity' identifier '{' '}' ;
repository : 'repository' '<' identifier '>' '{' '}' ;
value : 'value' identifier '{' '}' ;
controller : 'rest' 'controller' route '{' '}' #controllerRest ;
service : ('util' | 'service') identifier '{' '}' ;
proxy : 'proxy' PHP_LABEL 'as' proxable;

proxable
    : proxableValue
    | proxableService
    ;

proxableService: ('util' | 'service') identifier '{' '}' ;
proxableValue: 'value' identifier '{' '}';

route : ('/' routeElement)+ ;
routeElement
    : routeElementLiteral
    | routeElementPlaceholder
    ;
routeElementLiteral : ID ;
routeElementPlaceholder : ':' ID ;

identifier : ID ;

RESERVED_WORD : 'namespace' | 'entity' | 'value' | 'repository' | 'controller';

ID : [a-zA-Z][a-zA-Z0-9_]+;

WS  :  [ \t\r\n\u000C]+ -> skip
    ;

PHP_LABEL : ('\\' [a-zA-Z0-9_]+)+;

fragment ESCAPE_QUOTE
   : '\\' (["\\/bfnrt] | UNICODE)
   ;
fragment UNICODE
   : 'u' HEX HEX HEX HEX
   ;
fragment HEX
   : [0-9a-fA-F]
   ;
