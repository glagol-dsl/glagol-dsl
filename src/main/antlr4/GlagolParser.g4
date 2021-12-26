parser grammar GlagolParser;

@header {
package org.glagoldsl.compiler.syntax.concrete;
}

options { tokenVocab=GlagolLexer; }

module
    : 'namespace' namespace ';'
        (imports+=use)*
        (declarations+=declaration)*
        EOF
    ;

namespace
    : names+=identifier ('::' names+=identifier)*
    ;

use
    : 'import' namespace '::' decl=identifier ';'                          #ImportPlain
    | 'import' namespace '::' decl=identifier 'as' alias=identifier ';'    #ImportAlias
    ;

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
    | func=identifier '(' (args+=expression (',' args+=expression)* ','?)? ')'                          #ExprInvoke
    | prev=expression '.' func=identifier '(' (args+=expression (',' args+=expression)* ','?)? ')'      #ExprInvoke
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
    | left=queryExpression '=' right=queryExpression               #QueryExprEqual
    | left=queryExpression '!=' right=queryExpression              #QueryExprNonEqual
    | left=queryExpression '>' right=queryExpression               #QueryExprGreaterThan
    | left=queryExpression '>=' right=queryExpression              #QueryExprGreaterThanOrEqual
    | left=queryExpression '<' right=queryExpression               #QueryExprLowerThan
    | left=queryExpression '<=' right=queryExpression              #QueryExprLowerThanOrEqual
    | left=queryExpression 'AND' right=queryExpression             #QueryExprConjunction
    | left=queryExpression 'OR' right=queryExpression              #QueryExprDisjunction
    | expr=queryExpression 'IS' 'NULL'                             #QueryExprIsNull
    | expr=queryExpression 'IS' 'NOT' 'NULL'                       #QueryExprIsNotNull
    | '<<' expression '>>'                                         #QueryExprExpr
    | literal                                                      #QueryExprLiteral
    | field=queryField                                             #QueryExprField
    ;

queryField
    : entityRef=identifier '.' prop=identifier
    ;

queryOrderBy
    : fields+=queryOrderByField (',' fields+=queryOrderByField)*
    ;

queryLimit
    : offset=queryExpression ',' size=queryExpression       #QueryLimitOffset
    | size=queryExpression 'OFFSET' offset=queryExpression  #QueryLimitOffset
    | size=queryExpression                                  #QueryLimitNoOffset
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
    : annotation* entity
    | annotation* repository
    | annotation* value
    | annotation* controller
    | annotation* service
    | annotation* proxy
    ;

entity : 'entity' identifier '{' genericMember* '}' ;
repository : 'repository' '<' identifier '>' '{' genericMember* '}' ;
value : 'value' identifier '{' genericMember* '}' ;
controller : 'rest' 'controller' route '{' controllerMember* '}' #controllerRest ;
service : ('util' | 'service') identifier '{' genericMember* '}' ;
proxy : 'proxy' PhpClass 'as' proxable;

proxable
    : 'value' identifier '{' proxyMember* '}'                 #ProxableValue
    | ('util' | 'service') identifier '{' proxyMember* '}'    #ProxableService
    ;

genericMember
    : annotation* property
    | annotation* method
    | annotation* constructor
    ;

controllerMember
    : annotation* property
    | annotation* method
    | annotation* action
    ;

proxyMember
    : annotation* proxyProperty
    | annotation* proxyMethod
    | annotation* proxyConstructor
    | annotation* proxyRequire
    ;

proxyRequire
    : 'require' pkg=StringLiteral ver=StringLiteral ';'
    ;

proxyMethod
    : accessor=Public? type identifier '(' (params+=parameter (',' params+=parameter)* ','?)? ')' ';'
    ;

proxyConstructor
    : accessor=Public? identifier '(' (params+=parameter (',' params+=parameter)* ','?)? ')' ';'
    ;

proxyProperty
    : accessor=Public? type identifier ';'
    ;

action
    : identifier ('(' (params+=parameter (',' params+=parameter)* ','?)? ')')? methodBody
    ;

method
    : accessor=(Public | Private)? type identifier '(' (params+=parameter (',' params+=parameter)* ','?)? ')' methodBody
    ;

methodBody
    : '{' statement* '}'    #MethodBodyStatements
    | '=' expression ';'    #MethodBodyExpression
    ;

statement
    : expression ';'                                                              #StmtExpression
    | '{' statement* '}'                                                          #StmtBlock
    | 'if' '(' cond=expression ')' then=statement 'else' elseStmt=statement       #StmtIdThenElse
    | 'if' '(' cond=expression ')' then=statement                                 #StmtIdThen
    | assignable assignOperator=('='|'+='|'-='|'*='|'/=') val=statement           #StmtAssign
    | forEach                                                                     #StmtForeach
    | 'return' expression ';'                                                     #StmtReturn
    | 'return' ';'                                                                #StmtReturnVoid
    | 'persist' expression ';'                                                    #StmtPersist
    | 'flush' expression ';'                                                      #StmtFlush
    | 'flush' ';'                                                                 #StmtFlushAll
    | 'remove' expression ';'                                                     #StmtRemove
    | 'break' level=IntegerLiteral ';'                                            #StmtBreakLevel
    | 'break' ';'                                                                 #StmtBreak
    | 'continue' level=IntegerLiteral ';'                                         #StmtContinueLevel
    | 'continue' ';'                                                              #StmtContinue
    | type identifier '=' statement                                               #StmtDeclareWithValue
    | type identifier ';'                                                         #StmtDeclare
    ;

forEach
    : 'for' '(' arr=expression 'as' var=identifier (',' conds+=expression (','conds+=expression)*)? ')' statement                   #ForEachDefault
    | 'for' '(' arr=expression 'as' k=identifier ':' var=identifier (',' conds+=expression (','conds+=expression)*)? ')' statement  #ForEachWithKey
    ;

assignable
    : identifier                        #AssignableVar
    | expression '.' identifier         #AssignableProp
    | assignable '[' k=expression ']'   #AssignableListValue
    ;

parameter
    : annotation* type identifier
    ;

constructor
    : accessor=(Public | Private)? identifier '(' (params+=parameter (',' params+=parameter)* ','?)? ')' methodBody
    ;

property
    : accessor=(Public | Private)? type identifier ('=' defaultValue=expression)? ';'
    ;

route : ('/' routeElement)+ ;
routeElement
    : routeElementLiteral
    | routeElementPlaceholder
    ;
routeElementLiteral : Identifier ;
routeElementPlaceholder : ':' Identifier ;

identifier : Identifier ;