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
    | entityValue(set[Declaration] annotations, str \type, str name)
    | entityValue(set[Declaration] annotations, str \type, str name, set[str] valueProperties)
    | relation(str local, str foreign, str entity, str \alias)
    | relation(str local, str foreign, str entity, str \alias, set[str] relProperties)
    // annotations
    | annoTable(str name)
    | annoField(set[Expression] pairs)
    | index(str name, set[str] columns)
    // methods
    | method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, Expression expr)
    //| method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, Expression expr, Expression when)
    //| method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, Statement body)
    //| method(Modifier modifier, Type returnType, str name, set[Declaration] parameters, Statement body, Expression when)
    | parameter(Type paramType, str name)
    | parameter(Type paramType, str name, Expression defaultValue)
    ;

data Statement
    = methodCall()
    | null()
    ;

data Expression
    = annoPair(str key, str \value)
    | numberLiteral(str numberValue)
    | literal(Expression literal)
    | booleanLiteral(bool boolValue)
    | stringLiteral(str stringValue)
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
    | array(set[Expression] values)
	;

data Modifier
    = \private()
    | \public()
    //| \protected()
    ;

data Type
    = \int()
    | \float()
    | \string()
    | \void()
    | \bool()
    | typedArray(Type \type)
    | artifactType(str name)
    ;
