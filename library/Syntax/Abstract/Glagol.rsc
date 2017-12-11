module Syntax::Abstract::Glagol

import List;

alias GlagolID = str;

data Declaration 
    = file(loc file, Declaration \module)
    | \module(Declaration namespace, list[Declaration] imports, Declaration artifact)
    | namespace(GlagolID name)
    | namespace(GlagolID name, Declaration subNamespace)
    | \import(GlagolID artifactName, Declaration namespace, GlagolID as)
    | entity(GlagolID name, list[Declaration] declarations)
    | repository(GlagolID name, list[Declaration] declarations)
    | valueObject(GlagolID name, list[Declaration] declarations)
    | property(Type valueType, GlagolID name, Expression defaultValue)
    | util(GlagolID name, list[Declaration] declarations)
    | controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations)
    | action(GlagolID name, list[Declaration] params, list[Statement] body)
    | constructor(list[Declaration] params, list[Statement] body, Expression when)
    | method(Modifier modifier, Type returnType, GlagolID name, list[Declaration] params, list[Statement] body, Expression when)
    | param(Type paramType, GlagolID name, Expression defaultValue)
    | emptyDecl()
    ;

data ControllerType = jsonApi();

data Route
	= route(list[Route] routeParts)
	| routePart(str name)
	| routeVar(str name)
	;

data Expression
    = integer(int intValue)
    | float(real floatValue)
    | string(str strValue)
    | boolean(bool boolValue)
    | \list(list[Expression] values)
    | \map(map[Expression key, Expression \value] items)
    | arrayAccess(Expression variable, Expression arrayIndexKey)
    | variable(GlagolID name)
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
    | new(Name artifact, list[Expression] args)
    | get(Type t)
    | invoke(Symbol methodName, list[Expression] args)
    | invoke(Expression prev, Symbol methodName, list[Expression] args)
    | fieldAccess(Symbol symbolName)
    | fieldAccess(Expression prev, Symbol symbolName)
    | emptyExpr()
    | this()
    | cast(Type \type, Expression expr)
    ;

data Symbol 
	= symbol(str name);

data Type
    = integer()
    | float()
    | string()
    | voidValue()
    | boolean()
    | \list(Type \type)
    | \map(Type key, Type v)
    | artifact(Name name)
    | repository(Name name)
    | selfie()
    | self()
    | unknownType()
    | \any()
    ;

data Name
	= fullName(str localName, Declaration namespace, str originalName)
	;

data Modifier
    = \public()
    | \private()
    ;

data Statement
    = block(list[Statement] stmts)
    | expression(Expression expr)
    | ifThen(Expression condition, Statement then)
    | ifThenElse(Expression condition, Statement then, Statement \else)
    | assign(Expression assignable, AssignOperator operator, Statement \value)
    | emptyStmt()
    | \return(Expression expr)
    | persist(Expression expr)
    | remove(Expression expr)
    | flush(Expression expr)
    | declare(Type varType, Expression varName, Statement defaultValue)
    | foreach(Expression \list, Expression key, Expression varName, Statement body, list[Expression] conditions)
    | \break(int level)
    | \continue(int level)
    | query(QueryStatement queryStmt)
    ;

data QueryStatement
	= querySelect(QuerySpec spec, list[QuerySource] sources, QueryWhere where, QueryOrderBy order, QueryLimit limit)
	;

data QuerySpec
	= querySpec(Symbol symbol)
	;

data QuerySource
	= querySource(GlagolID name, Symbol symbol)
	;
	
data QueryWhere
	= noWhere()
	| expression(QueryExpression expr)
	;

data QueryExpression
	= \bracket(QueryExpression expr)
	| equals(QueryExpression lhs, QueryExpression rhs)
	| nonEquals(QueryExpression lhs, QueryExpression rhs)
	| greaterThan(QueryExpression lhs, QueryExpression rhs)
	| greaterThanOrEq(QueryExpression lhs, QueryExpression rhs)
	| lowerThan(QueryExpression lhs, QueryExpression rhs)
	| lowerThanOrEq(QueryExpression lhs, QueryExpression rhs)
	| isNull(QueryExpression lhs)
	| isNotNull(QueryExpression lhs)
	| and(QueryExpression lhs, QueryExpression rhs)
	| or(QueryExpression lhs, QueryExpression rhs)
	| glagolExpr(Expression expr)
	| queryField(QueryField expr)
	;

data QueryLimit
	= limit(int size, int offset)
	;
	
data QueryOrderBy
	= noOrderBy()
	| orderBy(list[QueryOrderBy] orderByFields)
	| orderBy(QueryField field, OrderByDirection dir)
	;
	
data OrderByDirection
	= asc()
	| desc()
	;

data QueryField
	= queryField(Symbol artifact, Symbol field)
	;

data AssignOperator
    = defaultAssign()
    | divisionAssign()
    | productAssign()
    | subtractionAssign()
    | additionAssign()
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

public anno list[Annotation] node@annotations;
public anno list[Annotation] Declaration@annotations;

public anno loc node@src;
public anno loc ControllerType@src;
public anno loc Route@src;
public anno loc AssignOperator@src;
public anno loc Statement@src; 
public anno loc Modifier@src; 
public anno loc Symbol@src; 
public anno loc Type@src; 
public anno loc Name@src; 
public anno loc Expression@src; 
public anno loc Annotation@src;
public anno loc Declaration@src;
