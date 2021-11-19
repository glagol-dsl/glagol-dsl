grammar Glagol;

module
    : 'namespace' namespace ';'
        (imports+=use)*
        (declarations+=annotatedDeclaration)*
        EOF
    ;

namespace
    : names+=identifier ('::' names+=identifier)*
    ;

use
    : 'import' namespace '::' decl=identifier ';'                          #importPlain
    | 'import' namespace '::' decl=identifier 'as' alias=identifier ';'    #importAlias
    ;

annotatedDeclaration : annotation* declaration;

annotation
    : ANNOTATION_NAME
    | ANNOTATION_NAME '(' ')'
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
proxy : 'proxy' PHP_CLASS 'as' proxable;

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

ANNOTATION_NAME: '@' ID;

ID : [a-zA-Z][a-zA-Z0-9_]*;

WS  :  [ \t\r\n\u000C]+ -> skip
    ;

PHP_CLASS : ('\\' [a-zA-Z0-9_]+)+;

fragment ESCAPE_QUOTE
   : '\\' (["\\/bfnrt] | UNICODE)
   ;
fragment UNICODE
   : 'u' HEX HEX HEX HEX
   ;
fragment HEX
   : [0-9a-fA-F]
   ;
