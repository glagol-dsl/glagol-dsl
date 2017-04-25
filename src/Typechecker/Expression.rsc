module Typechecker::Expression

import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;
import Typechecker::Type::Compatibility;

import List;
import Map;
import Set;

@doc="Empty expression is always unknown type"
public Type lookupType(emptyExpr(), _) = unknownType();

@doc="Lookup literal types"
public Type lookupType(integer(int intValue), _) = integer();
public Type lookupType(float(real floatValue), _) = float();
public Type lookupType(string(str strValue), _) = string();
public Type lookupType(boolean(bool boolValue), _) = boolean();

@doc="Lookup list types"

@doc="Will return unknown type if lists consists of unequal types"
public Type lookupType(\list(list[Expression] values), TypeEnv env) = \list(unknownType()) 
    when size(values) > 1 && hasDifferentTypes(values, env);

@doc="Will try to get the list type from the first element"
public Type lookupType(\list(list[Expression] values), TypeEnv env) = \list(lookupType(values[0], env)) when size(values) > 0;

@doc="Empty list"
public Type lookupType(\list(list[Expression] values), _) = \list(voidValue()) when size(values) == 0;

@doc="Extract list of values from maps and use lookup for lists"
public Type lookupType(\map(map[Expression, Expression] items), TypeEnv env) = lookupType(\list(toList(range(items))), env);

public Type lookupType(arrayAccess(Expression variable, Expression arrayIndexKey), TypeEnv env) = lookupArrayType(lookupType(variable, env));

private Type lookupArrayType(\list(Type t)) = t;
private Type lookupArrayType(\map(Type key, Type val)) = val;
private Type lookupArrayType(_) = unknownType();

private bool hasDifferentTypes(list[Expression] values, TypeEnv env) = (false | it ? true : lookupType(t1, env) != lookupType(t2, env) | t1 <- values, t2 <- values);

@doc="Lookup variable type from type env"
public Type lookupType(variable(GlagolID name), TypeEnv env) = unknownType() when name notin env.definitions;
public Type lookupType(variable(GlagolID name), TypeEnv env) = lookupDefinitionType(env.definitions[name]) when name in env.definitions;

@doc="Lookup brackets expression"
public Type lookupType(\bracket(Expression expr), TypeEnv env) = lookupType(expr, env);

@doc="Lookup binary arithmetic type"
public Type lookupType(product(Expression lhs, Expression rhs), TypeEnv env) =
	lookupMathCompatibility(lookupType(lhs, env), lookupType(rhs, env));
	
public Type lookupType(remainder(Expression lhs, Expression rhs), TypeEnv env) =
	lookupMathCompatibility(lookupType(lhs, env), lookupType(rhs, env));
	
public Type lookupType(division(Expression lhs, Expression rhs), TypeEnv env) =
	lookupMathCompatibility(lookupType(lhs, env), lookupType(rhs, env));
	
private Type lookupMathCompatibility(integer(), integer()) = integer();
private Type lookupMathCompatibility(float(), float()) = float();
private Type lookupMathCompatibility(Type lhs, Type rhs) = unknownType();

private Type lookupDefinitionType(localVar(declare(Type varType, Expression varName, Statement defaultValue))) = varType;
private Type lookupDefinitionType(field(property(Type valueType, GlagolID name, set[AccessProperty] valueProperties, Expression defaultValue))) = valueType;
private Type lookupDefinitionType(param(param(Type paramType, GlagolID name, Expression defaultValue))) = paramType;
