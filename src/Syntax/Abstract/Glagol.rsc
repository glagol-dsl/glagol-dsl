module Syntax::Abstract::Glagol

import List;

data Declaration 
    = file(loc file, Declaration \module)
    | \module(Declaration namespace, list[Declaration] imports, Declaration artifact)
    | namespace(str name)
    | namespace(str name, Declaration subNamespace)
    | \import(str artifactName, Declaration namespace, str as)
    | annotated(list[Annotation] annotations, Declaration declaration)
    | entity(str name, list[Declaration] declarations)
    | repository(str name, list[Declaration] declarations)
    | valueObject(str name, list[Declaration] declarations)
    | property(Type \valueType, str name, set[AccessProperty] valueProperties)
    | property(Type \valueType, str name, set[AccessProperty] valueProperties, Expression defaultValue)
    | util(str name, list[Declaration] declarations)
    | relation(RelationDir l, RelationDir r, str name, str as, set[AccessProperty] valueProperties)
    | constructor(list[Declaration] params, list[Statement] body)
    | constructor(list[Declaration] params, list[Statement] body, Expression when)
    | method(Modifier modifier, Type returnType, str name, list[Declaration] params, list[Statement] body)
    | method(Modifier modifier, Type returnType, str name, list[Declaration] params, list[Statement] body, Expression when)
    | param(Type paramType, str name)
    | param(Type paramType, str name, Expression defaultValue)
    ;

data RelationDir
    = \one()
    | many()
    ;

data UseSource
    = externalUse(str \module)
    | internalUse()
    ;

data Annotation
    = annotation(str annotationName, list[Annotation] arguments)
    | annotationMap(map[str key, Annotation \value] \map)
    | annotationVal(Annotation \value)
    | annotationVal(list[Annotation] listValue)
    | annotationVal(str strValue)
    | annotationVal(bool boolValue)
    | annotationVal(int intValue)
    | annotationVal(real floatValue)
    | annotationVal(Type \typeValue)
    | annotationValPrimary()
    ;

data Expression
    = intLiteral(int intValue)
    | floatLiteral(real floatValue)
    | strLiteral(str strValue)
    | boolLiteral(bool boolValue)
    | \list(list[Expression] values)
    | arrayAccess(Expression variable, Expression arrayIndexKey)
    | \map(map[Expression key, Expression \value])
    | variable(str name)
    | \bracket(Expression expr)
    | product(Expression lhs, Expression rhs)
    | remainder(Expression lhs, Expression rhs)
    | division(Expression lhs, Expression rhs)
    | addition(Expression lhs, Expression rhs)
    | subtraction(Expression lhs, Expression rhs)
    | greaterThanOrEq(Expression lhs, Expression rhs)
    | lessThanOrEq(Expression lhs, Expression rhs)
    | lessThan(Expression lhs, Expression rhs)
    | greaterThan(Expression lhs, Expression rhs)
    | equals(Expression lhs, Expression rhs)
    | nonEquals(Expression lhs, Expression rhs)
    | and(Expression lhs, Expression rhs)
    | or(Expression lhs, Expression rhs)
    | negative(Expression expr)
    | positive(Expression expr)
    | ifThenElse(Expression condition, Expression ifThen, Expression \else)
    | new(str artifact, list[Expression] args)
    | get(Type t)
    | invoke(str methodName, list[Expression] args)
    | invoke(Expression prev, str methodName, list[Expression] args)
    | fieldAccess(str field)
    | fieldAccess(Expression prev, str field)
    | emptyExpr()
    | this()
    ;

data Type
    = integer()
    | float()
    | string()
    | voidValue()
    | boolean()
    | typedList(Type \type)
    | typedMap(Type key, Type v)
    | artifactType(str name)
    | repositoryType(str name)
    | selfie()
    ;
    
data Modifier
    = \public()
    | \private()
    ;

data AccessProperty
    = read()
    | \set()
    | add()
    | clear()
    ;

data Statement
    = block(list[Statement] stmts)
    | expression(Expression expr)
    | ifThen(Expression condition, Statement then)
    | ifThenElse(Expression condition, Statement then, Statement \else)
    | assign(Expression assignable, AssignOperator operator, Statement \value)
    | emptyStmt()
    | \return(Statement stmt)
    | declare(Type varType, Expression varName)
    | declare(Type varType, Expression varName, Statement defaultValue)
    | foreach(Expression \list, Expression varName, Statement body)
    | foreach(Expression \list, Expression varName, Statement body, list[Expression] conditions)
    | \break()
    | \break(int level)
    | \continue()
    | \continue(int level)
    ;

data AssignOperator
    = defaultAssign()
    | divisionAssign()
    | productAssign()
    | subtractionAssign()
    | additionAssign()
    ;
