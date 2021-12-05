parser grammar GlagolParser;

@header {
package org.glagoldsl.compiler.syntax.concrete;
}

options { tokenVocab=GlagolLexer; }

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
    : 'import' namespace '::' decl=identifier ';'                          #ImportPlain
    | 'import' namespace '::' decl=identifier 'as' alias=identifier ';'    #ImportAlias
    ;

annotatedDeclaration : annotation* declaration;

annotation
    : AnnotationName
    | AnnotationName '(' (items+=expression (',' items+=expression)* ','?)? ')'
    ;

expression
    : '(' expression ')'                                                                                #ExprBracket
    | '[' (items+=expression (',' items+=expression)* ','?)? ']'                                        #ExprList
    | '{' (pairs+=mapPair (',' pairs+=mapPair)* ','?)? '}'                                              #ExprMap
    | literal                                                                                           #ExprLiteral
    | identifier                                                                                        #ExprVariable
    | 'new' identifier '(' (args+=expression (',' args+=expression)* ','?)? ')'                         #ExprNew
    | method=identifier '(' (args+=expression (',' args+=expression)* ','?)? ')'                        #ExprInvoke
    | prev=expression '.' method=identifier '(' (args+=expression (',' args+=expression)* ','?)? ')'    #ExprInvoke
    | 'this'                                                                                            #ExprThis
    | prev=expression '.' prop=identifier                                                               #ExprPropAccess
    | query                                                                                             #ExprQuery
    | <assoc=right> cond=expression '?' then=expression ':' els=expression                              #ExprTernary
    // unary
    | '-' expression                                                                                    #ExprNegative
    | '+' expression                                                                                    #ExprPositive
    | '!' expression                                                                                    #ExprNegation
    | '(' type ')' expression                                                                           #ExprTypeCast
    // binary
    | left=expression '++' right=expression                                                             #ExprConcat
    // binary - arithmetic
    | left=expression '+' right=expression                                                              #ExprAdd
    | left=expression '-' right=expression                                                              #ExprSub
    | left=expression '*' right=expression                                                              #ExprProduct
    | left=expression '/' right=expression                                                              #ExprDivision
    // binary - relational
    | left=expression '>' right=expression                                                              #ExprGreaterThan
    | left=expression '<' right=expression                                                              #ExprLowerThan
    | left=expression '==' right=expression                                                             #ExprEqual
    | left=expression '!=' right=expression                                                             #ExprNotEqual
    | left=expression '>=' right=expression                                                             #ExprGreaterThanOrEqual
    | left=expression '<=' right=expression                                                             #ExprLowerThanOrEqual
    | left=expression '&&' right=expression                                                             #ExprConjunction
    | left=expression '||' right=expression                                                             #ExprDisjunction
    ;

type
    : 'int'                                                         #TypeInt
    | 'float'                                                       #TypeFloat
    | 'string'                                                      #TypeString
    | 'bool'                                                        #TypeBool
    | 'void'                                                        #TypeVoid
    | type '[' ']'                                                  #TypeTypedList
    | '{' key=type ',' val=type '}'                                 #TypeTypedMap
    | 'repository' '<' entityRef=identifier '>'                     #TypeRepository
    | class_=identifier                                             #TypeClass
    ;

query
    : querySelect
    ;

querySelect
    :   'SELECT'
        querySpec
        'FROM'
        querySource
        ('WHERE' where=queryExpression)?
        ('ORDER' 'BY' orderBy=queryOrderBy)?
        ('LIMIT' limit=queryLimit)?
    ;

querySpec
    : identifier                #QuerySpecSingle
    | identifier ('[' ']')?     #QuerySpecMulti
    ;

querySource
    : entityRef=identifier 'as'? alias=identifier
    ;

queryExpression
    : '(' queryExpression ')'                                      #QueryExprBracket
    | left=queryExpression '=' right=literalOrQueryExpression      #QueryExprEqual
    | left=queryExpression '!=' right=literalOrQueryExpression     #QueryExprNonEqual
    | left=queryExpression '>' right=literalOrQueryExpression      #QueryExprGreaterThan
    | left=queryExpression '>=' right=literalOrQueryExpression     #QueryExprGreaterThanOrEqual
    | left=queryExpression '<' right=literalOrQueryExpression      #QueryExprLowerThan
    | left=queryExpression '<=' right=literalOrQueryExpression     #QueryExprLowerThanOrEqual
    | left=queryExpression 'AND' right=literalOrQueryExpression    #QueryExprConjunction
    | left=queryExpression 'OR' right=literalOrQueryExpression     #QueryExprDisjunction
    | expr=queryExpression 'IS' 'NULL'                             #QueryExprIsNull
    | expr=queryExpression 'IS' 'NOT' 'NULL'                       #QueryExprIsNotNull
    | '<<' expression '>>'                                         #QueryExprExpr
    | field=queryField                                             #QueryExprField
    ;

queryField
    : entityRef=identifier '.' prop=identifier
    ;

queryOrderBy
    : fields+=queryOrderByField (',' fields+=queryOrderByField)*
    ;

queryLimit
    : offset=literalOrQueryExpression ',' size=literalOrQueryExpression       #QueryLimitOffset
    | size=literalOrQueryExpression 'OFFSET' offset=literalOrQueryExpression  #QueryLimitOffset
    | size=literalOrQueryExpression                                           #QueryLimitNoOffset
    ;

literalOrQueryExpression
    : queryExpression               #ParseQueryExpression
    | literal                       #ParseLiteral
    ;

queryOrderByField
    : field=queryField            #QueryOrderByFieldAscending
    | field=queryField 'ASC'      #QueryOrderByFieldAscending
    | field=queryField 'DESC'     #QueryOrderByFieldDescending
    ;

literal
    : StringLiteral                    #LiteralString
    | IntegerLiteral                   #LiteralInteger
    | DecimalLiteral                   #LiteralDecimal
    | (True | False)                   #LiteralBoolean
    ;

mapPair
    : key=expression ':' val=expression
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
proxy : 'proxy' PhpClass 'as' proxable;

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
routeElementLiteral : Identifier ;
routeElementPlaceholder : ':' Identifier ;

identifier : Identifier ;