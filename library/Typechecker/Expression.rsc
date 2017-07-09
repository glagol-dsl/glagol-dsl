module Typechecker::Expression

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Type;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Typechecker::Type::Compatibility;

import List;
import Map;
import Set;

public TypeEnv checkExpression(\list([]), TypeEnv env) = env;
public TypeEnv checkExpression(\map(map[Expression, Expression] items), TypeEnv env) = env when size(items) == 0;
public TypeEnv checkExpression(boolean(_), TypeEnv env) = env;
public TypeEnv checkExpression(string(_), TypeEnv env) = env;
public TypeEnv checkExpression(integer(_), TypeEnv env) = env;
public TypeEnv checkExpression(v: variable(GlagolID name), TypeEnv env) = checkIsVariableDefined(v, env);
public TypeEnv checkExpression(f: fieldAccess(_), TypeEnv env) = checkIsVariableDefined(f, env);
public TypeEnv checkExpression(f: fieldAccess(_, _), TypeEnv env) = checkIsVariableDefined(f, env);
public TypeEnv checkExpression(a: arrayAccess(_, _), TypeEnv env) = checkArrayAccess(a, env);

public TypeEnv checkIsVariableDefined(Expression expr, TypeEnv env) = 
	addError(expr@src, "\'<expr.name>\' is undefined in <expr@src.path> on line <expr@src.begin.line>", env)
	when !isDefined(expr, env);

public TypeEnv checkIsVariableDefined(Expression, TypeEnv env) = env;

public TypeEnv checkArrayAccess(a: arrayAccess(Expression variable, Expression arrayIndexKey), TypeEnv env) = 
	checkArrayAccess(lookupType(variable, env), lookupType(arrayIndexKey, env), a, checkIndexKey(arrayIndexKey, checkExpression(variable, env)));

public TypeEnv checkArrayAccess(\map(Type key, Type v), Type indexKeyType, _, TypeEnv env) = env when key == indexKeyType;

public TypeEnv checkArrayAccess(\map(Type key, Type v), Type indexKeyType, a, TypeEnv env) = 
	addError(a@src, 
		"Map key type is <toString(key)>, cannot access using <toString(indexKeyType)> in <a@src.path> on line <a@src.begin.line>", env)
	when key != indexKeyType;
	
public TypeEnv checkArrayAccess(\list(Type \type), integer(), _, TypeEnv env) = env;

public TypeEnv checkArrayAccess(\list(Type \type), Type indexKeyType, a, TypeEnv env) = 
	addError(a@src, 
		"List cannot be accessed using <toString(indexKeyType)>, only integers allowed in <a@src.path> on line <a@src.begin.line>", env)
	when integer() != indexKeyType;

public TypeEnv checkArrayAccess(Type t, Type indexKeyType, a, TypeEnv env) = 
	addError(a@src, "Cannot access <toString(t)> as array in <a@src.path> on line <a@src.begin.line>", env);

public TypeEnv checkIndexKey(Expression key, TypeEnv env) = checkIndexKey(lookupType(key, env), key, checkExpression(key, env));

public TypeEnv checkIndexKey(unknownType(), key, TypeEnv env) = 
	addError(key@src, "Type of array index key used cannot be determined in <key@src.path> on line <key@src.begin.line>", env);
public TypeEnv checkIndexKey(voidValue(), key, TypeEnv env) = 
	addError(key@src, "Void cannot be used as array index key in <key@src.path> on line <key@src.begin.line>", env);
	
public TypeEnv checkIndexKey(Type t, key, TypeEnv env) = env;

@doc="Empty expression is always unknown type"
public Type lookupType(emptyExpr(), _) = unknownType();

@doc="Lookup literal types"
public Type lookupType(integer(int intValue), _) = integer();
public Type lookupType(float(real floatValue), _) = float();
public Type lookupType(string(str strValue), _) = string();
public Type lookupType(boolean(bool boolValue), _) = boolean();

@doc="Lookup list types"

@doc="Empty list"
public Type lookupType(\list([]), _) = \list(voidValue());

@doc="Will return unknown type if lists consists of unequal types"
public Type lookupType(\list(list[Expression] values), TypeEnv env) = \list(unknownType()) 
    when size(values) > 1 && hasDifferentTypes(values, env);

@doc="Will try to get the list type from the first element"
public Type lookupType(\list(list[Expression] values), TypeEnv env) = \list(lookupType(values[0], env)) when size(values) > 0;

@doc="Extract list of values from maps and use lookup for lists"
public Type lookupType(\map(map[Expression, Expression] items), TypeEnv env) = \map(voidValue(), voidValue()) when size(items) == 0;
public Type lookupType(\map(map[Expression, Expression] items), TypeEnv env) = 
    \map(lookupType(\list(toList(domain(items))), env).\type, lookupType(\list(toList(range(items))), env).\type);

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
    
public Type lookupType(subtraction(Expression lhs, Expression rhs), TypeEnv env) =
    lookupMathCompatibility(lookupType(lhs, env), lookupType(rhs, env));
    
public Type lookupType(addition(Expression lhs, Expression rhs), TypeEnv env) {
    Type lType = lookupType(lhs, env);
    Type rType = lookupType(rhs, env);

    if (lType == rType && rType == string()) {
        return string();
    }

    return lookupMathCompatibility(lType, rType);
}
    
public Type lookupType(g: greaterThanOrEq(Expression lhs, Expression rhs), TypeEnv env) =
    lookupRelationalCompatibilityType(lookupType(lhs, env), lookupType(rhs, env), g);
    
public Type lookupType(g: greaterThan(Expression lhs, Expression rhs), TypeEnv env) =
    lookupRelationalCompatibilityType(lookupType(lhs, env), lookupType(rhs, env), g);
    
public Type lookupType(l: lessThanOrEq(Expression lhs, Expression rhs), TypeEnv env) =
    lookupRelationalCompatibilityType(lookupType(lhs, env), lookupType(rhs, env), l);
    
public Type lookupType(l: lessThan(Expression lhs, Expression rhs), TypeEnv env) =
    lookupRelationalCompatibilityType(lookupType(lhs, env), lookupType(rhs, env), l);
    
public Type lookupType(e: equals(Expression lhs, Expression rhs), TypeEnv env) =
    lookupRelationalCompatibilityType(lookupType(lhs, env), lookupType(rhs, env), e);
    
public Type lookupType(e: nonEquals(Expression lhs, Expression rhs), TypeEnv env) =
    lookupRelationalCompatibilityType(lookupType(lhs, env), lookupType(rhs, env), e);
    
public Type lookupType(and(Expression lhs, Expression rhs), TypeEnv env) =
    lookupBooleanCompatibilityType(lookupType(lhs, env), lookupType(rhs, env));
    
public Type lookupType(or(Expression lhs, Expression rhs), TypeEnv env) =
    lookupBooleanCompatibilityType(lookupType(lhs, env), lookupType(rhs, env));

public Type lookupType(positive(Expression expr), TypeEnv env) = lookupUnaryMathType(lookupType(expr, env));
public Type lookupType(negative(Expression expr), TypeEnv env) = lookupUnaryMathType(lookupType(expr, env));

public Type lookupType(ifThenElse(Expression condition, Expression ifThen, Expression \else), TypeEnv env) = 
    lookupTernaryType(lookupType(ifThen, env), lookupType(\else, env));

public Type lookupType(new(local(str name), list[Expression] args), TypeEnv env) {
	if (hasLocalArtifact(name, env)) {
		Name externalName = getFullNameOfLocalArtifact(name, env);
		Declaration \import = toNamespace(externalName);
		if (isEntity(\import, env) || isValueObject(\import, env)) {
			return artifact(externalName);
		}
	}
	
	return unknownType();
}

public Type lookupType(new(e: external(str localName, Declaration namespace, str originalName), list[Expression] args), TypeEnv env) = 
	artifact(e) when isInAST(toNamespace(e), env) && (isEntity(toNamespace(e), env) || isValueObject(toNamespace(e), env));
public Type lookupType(new(e: external(str localName, Declaration namespace, str originalName), list[Expression] args), TypeEnv env) = 
	unknownType();

public Type lookupType(get(a: artifact(local(str name))), TypeEnv env) {
	if (hasLocalArtifact(name, env)) {
		Name externalName = getFullNameOfLocalArtifact(name, env);
		if (isUtil(toNamespace(externalName), env)) {
			return artifact(externalName);
		}
	}
	
	return unknownType();
}

public Type lookupType(get(a: artifact(e: external(str name, Declaration namespace, str originalName))), TypeEnv env) = 
	a when isInAST(toNamespace(e), env) && isUtil(toNamespace(e), env);

public Type lookupType(get(a: artifact(e: external(str name, Declaration namespace, str originalName))), TypeEnv env) = unknownType();

public Type lookupType(get(t: repository(local(str name))), TypeEnv env) {
	if (hasLocalArtifact(name, env)) {
		Name externalName = getFullNameOfLocalArtifact(name, env);
		if (isEntity(toNamespace(externalName), env)) {
			return repository(externalName);
		}
	}
	
	return unknownType();
}

public Type lookupType(get(a: repository(e: external(str name, Declaration namespace, str originalName))), TypeEnv env) = 
	a when isInAST(toNamespace(e), env) && isEntity(toNamespace(e), env);

public Type lookupType(get(t: selfie()), TypeEnv env) = t;
public Type lookupType(get(_), TypeEnv env) = unknownType();

public Type lookupType(invoke(str m, _), TypeEnv env) {
	visit (getContext(env)) { 
		case method(\public(), Type t, m, _, _, _): 
			return externalize(t, env); 
	}
	
	return unknownType();
}

public Type lookupType(invoke(Expression prev, str m, params), TypeEnv env) = 
	lookupType(externalize(lookupType(prev, env), env), invoke(m , params), env);
	
public Type lookupType(Type prev, i: invoke(str m, params), TypeEnv env) = 
	lookupType(i, setContext(findModule(prev, env), env)) when hasModule(prev, env);
	
public Type lookupType(Type prev, i: invoke(str m, params), TypeEnv) = unknownType();

public Type lookupType(fieldAccess(str field), TypeEnv env) = 
	externalize(findLocalProperty(field, env).valueType, env) when hasLocalProperty(field, env);
	
public Type lookupType(f: fieldAccess(str field), TypeEnv env) = 
	lookupType(findLocalRelation(field, env), f, env) when hasLocalRelation(field, env);
	
public Type lookupType(f: fieldAccess(str field), TypeEnv env) = unknownType();

public Type lookupType(f: fieldAccess(this(), str field), TypeEnv env) = lookupType(fieldAccess(field), env);
public Type lookupType(f: fieldAccess(_, str field), TypeEnv env) = unknownType();

public Type lookupType(relation(_, \one(), name, _), fieldAccess(str field), TypeEnv env) = 
	externalize(artifact(local(name)), env) when hasLocalArtifact(name, env);
	
public Type lookupType(relation(_, \many(), name, _), fieldAccess(str field), TypeEnv env) = 
	\list(externalize(artifact(local(name)), env)) when hasLocalArtifact(name, env);
	
public Type lookupType(Declaration relation, fieldAccess(str field), TypeEnv env) = 
	unknownType();

private Type lookupTernaryType(artifact(Name ifThen), artifact(Name \else)) = ifThen == \else ? artifact(ifThen) : unknownType();
private Type lookupTernaryType(repository(Name ifThen), repository(Name \else)) = ifThen == \else ? repository(ifThen) : unknownType();
private Type lookupTernaryType(Type ifThen, Type \else) = ifThen when ifThen == \else;
private Type lookupTernaryType(Type ifThen, Type \else) = unknownType();

private Type lookupUnaryMathType(integer()) = integer();
private Type lookupUnaryMathType(float()) = float();
private Type lookupUnaryMathType(_) = unknownType();

private Type lookupMathCompatibility(integer(), integer()) = integer();
private Type lookupMathCompatibility(float(), float()) = float();
private Type lookupMathCompatibility(Type lhs, Type rhs) = unknownType();

private Type lookupBooleanCompatibilityType(boolean(), boolean()) = boolean();
private Type lookupBooleanCompatibilityType(Type lhs, Type rhs) = unknownType();

private Type lookupRelationalCompatibilityType(string(), string(), equals(Expression lhs, Expression rhs)) = boolean();
private Type lookupRelationalCompatibilityType(string(), string(), nonEquals(Expression lhs, Expression rhs)) = boolean();
private Type lookupRelationalCompatibilityType(integer(), integer(), _) = boolean();
private Type lookupRelationalCompatibilityType(integer(), float(), _) = boolean();
private Type lookupRelationalCompatibilityType(float(), float(), _) = boolean();
private Type lookupRelationalCompatibilityType(float(), integer(), _) = boolean();
private Type lookupRelationalCompatibilityType(Type lhs, Type rhs, _) = unknownType();

private Type lookupDefinitionType(localVar(declare(Type varType, Expression varName, Statement defaultValue))) = varType;
private Type lookupDefinitionType(field(property(Type valueType, GlagolID name, Expression defaultValue))) = valueType;
private Type lookupDefinitionType(param(param(Type paramType, GlagolID name, Expression defaultValue))) = paramType;
