module Syntax::Abstract::AST

data Declaration
    = \module(str name, set[Declaration] imports)
    | \module(str name, set[Declaration] imports, Declaration artifact)
    | \import(str target, str artifactType, Declaration fromModule, Declaration \alias)
    // artifact: entity
    | entity(set[Declaration] annotations, str name, set[Declaration] declarations)
    | entity(str name, set[Declaration] declarations)
    | entityValue(set[Declaration] annotations, Type \type, str name)
    | entityValue(set[Declaration] annotations, Type \type, str name, set[str] valueProperties)
    | relation(str local, str foreign, str entity, str artifactAlias)
    | relation(str local, str foreign, str entity, str artifactAlias, set[str] relProperties)
    // annotations
    | annoTable(str name)
    | annoField(set[Expression] pairs)
    | index(str name, set[str] columns)
    // methods
    | method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, Expression expr, Expression when)
    | method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, list[Statement] body, Expression when)
    | constructor(set[Declaration] parameters, Statement constructorBody, Expression when, Declaration conditionalThrow)
    | parameter(Type paramType, str name, Expression defaultValue)
    | conditionalThrow(str exceptionName, list[Expression] arguments, Expression condition)
    | \alias(str aliasName)
    | noAlias()
    | localImport()
    | from(str sourceModule)
    | emptyDeclaration()
    ;

data Statement
    = methodCall()
    | block(list[Statement] stmts)
    | methodBody(list[Statement] stmts)
    | expression(Expression expr)
    | ifThen(Expression condition, Statement then)
    | ifThenElse(Expression condition, Statement then, Statement \else)
    | empty()
    ;

data Expression
    = annoPair(str key, str \value)
    | intLiteral(int intValue)
    | floatLiteral(real floatValue)
    | booleanLiteral(str boolValue)
    | stringLiteral(str stringValue)
    | variable(str name)
    | when(Expression expr)
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
    | expr(Expression expr)
    | defaultValue(Expression defaultValue)
    | none()
	;

data Modifier
    = \private()
    | \public()
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
