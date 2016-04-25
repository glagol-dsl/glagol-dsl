module Syntax::Abstract::AST

data Declaration
    = \module(str name, set[Declaration] imports)
    | \module(str name, set[Declaration] imports, Declaration artifact)
    | importInternal(str target, str \artifactType)
    | importInternal(str target, str \artifactType, str \alias)
    | importExternal(str target, str \artifactType, str \module)
    | importExternal(str target, str \artifactType, str \module, str \alias)
    // artifact: entity
    | entity(set[Declaration] annotations, str name, set[Declaration] declarations)
    | entity(str name, set[Declaration] declarations)
    | entityValue(set[Declaration] annotations, Type \type, str name)
    | entityValue(set[Declaration] annotations, Type \type, str name, set[str] valueProperties)
    | relation(str local, str foreign, str entity, str \alias)
    | relation(str local, str foreign, str entity, str \alias, set[str] relProperties)
    // annotations
    | annoTable(str name)
    | annoField(set[Expression] pairs)
    | index(str name, set[str] columns)
    // methods
    | method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, Expression expr)
    | method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, Expression expr, Expression when)
    | method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, list[Statement] body)
    | method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, list[Statement] body, Expression when)
    | constructor(set[Declaration] parameters, Statement constructorBody, Expression when, Declaration conditionalThrow)
    | parameter(Type paramType, str name)
    | parameter(Type paramType, str name, Expression defaultValue)
    | conditionalThrow(str exceptionName, list[Expression] arguments, Expression condition)
    | emptyDeclaration()
    ;

data Statement
    = methodCall()
    | block(list[Statement] stmts)
    | methodBody(list[Statement] stmts)
    | expression(Expression expr)
    | empty()
    ;

data Expression
    = annoPair(str key, str \value)
    | intLiteral(int intValue)
    | floatLiteral(real floatValue)
    | booleanLiteral(str boolValue)
    | stringLiteral(str stringValue)
    | variable(str name)
    | \bracket(Expression expr)
    | product(Expression lhs, Expression rhs)
    | remainder(Expression lhs, Expression rhs)
    | division(Expression lhs, Expression rhs)
    | addition(Expression lhs, Expression rhs)
    | subtraction(Expression lhs, Expression rhs)
    | modulo(Expression lhs, Expression rhs)
    | negative(Expression expr)
    | greaterThanOrEq(Expression lhs, Expression rhs)
    | lessThanOrEq(Expression lhs, Expression rhs)
    | lessThan(Expression lhs, Expression rhs)
    | greaterThan(Expression lhs, Expression rhs)
    | equals(Expression lhs, Expression rhs)
    | nonEquals(Expression lhs, Expression rhs)
    | and(Expression lhs, Expression rhs)
    | or(Expression lhs, Expression rhs)
    | ifThenElse(Expression condition, Expression ifThen, Expression \else)
    | array(list[Expression] values)
    | none()
    | expr(Expression expr)
	;

data Modifier
    = \private()
    | \public()
    //| \protected()
    ;

data Type
    = integer()
    | \float()
    | \string()
    | voidValue()
    | \bool()
    | typedArray(Type \type)
    | artifactType(str name)
    ;
