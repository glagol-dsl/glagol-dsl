module Typechecker::Expression

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Type;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Typechecker::Type::Compatibility;

import IO;
import List;
import Map;
import Set;

public TypeEnv checkExpression(\list([]), TypeEnv env) = env;

public TypeEnv checkExpression(l: \list(list[Expression] items), TypeEnv env) = checkList(l, lookupType(l, env), checkExpressions(items, env));

public TypeEnv checkExpressions(list[Expression] exprs, TypeEnv env) = (env | checkExpression(expr, it) | expr <- exprs);
public TypeEnv checkExpressions(map[Expression, Expression] exprs, TypeEnv env) = 
	(env | checkExpression(exprs[expr], checkExpression(expr, it)) | expr <- exprs);

public TypeEnv checkList(l, \list(unknownType()), TypeEnv env) = addError(l, "Cannot unveil list type", env);
public TypeEnv checkList(l, \list(_), TypeEnv env) = env;
	
public TypeEnv checkExpression(\map(map[Expression, Expression] items), TypeEnv env) = env when size(items) == 0;

public TypeEnv checkExpression(m: \map(map[Expression, Expression] items), TypeEnv env) = 
	checkMap(m, lookupType(m, env), checkExpressions(items, env));

public TypeEnv checkMap(m, \map(unknownType(), unknownType()), TypeEnv env) = 
	addError(m,  "Cannot unveil map key and value types", env);
	
public TypeEnv checkMap(m, \map(unknownType(), _), TypeEnv env) = 
	addError(m,  "Cannot unveil map key type", env);
	
public TypeEnv checkMap(m, \map(_, unknownType()), TypeEnv env) = 
	addError(m,  "Cannot unveil map value type", env);
	
public TypeEnv checkMap(m, \map(_, _), TypeEnv env) = env;

public TypeEnv checkExpression(boolean(_), TypeEnv env) = env;
public TypeEnv checkExpression(string(_), TypeEnv env) = env;
public TypeEnv checkExpression(float(_), TypeEnv env) = env;
public TypeEnv checkExpression(integer(_), TypeEnv env) = env;
public TypeEnv checkExpression(\bracket(Expression expr), TypeEnv env) = checkExpression(expr, env);
public TypeEnv checkExpression(v: variable(GlagolID name), TypeEnv env) = checkIsVariableDefined(v, env);
public TypeEnv checkExpression(f: fieldAccess(_), TypeEnv env) = checkIsVariableDefined(f, env);
public TypeEnv checkExpression(f: fieldAccess(_, _), TypeEnv env) = checkIsVariableDefined(f, env);
public TypeEnv checkExpression(a: arrayAccess(_, _), TypeEnv env) = checkArrayAccess(a, env);

public TypeEnv checkIsVariableDefined(expr: fieldAccess(str name), TypeEnv env) = 
	addError(expr, "\'<expr.name>\' is undefined", env)
	when !hasLocalProperty(name, env);

public TypeEnv checkIsVariableDefined(expr: fieldAccess(str name), TypeEnv env) = env;

public TypeEnv checkIsVariableDefined(expr: fieldAccess(this(), str name), TypeEnv env) = 
	addError(expr, "\'<expr.name>\' is undefined", env)
	when !hasLocalProperty(name, env);

public TypeEnv checkIsVariableDefined(expr: fieldAccess(this(), str name), TypeEnv env) = env;
public TypeEnv checkIsVariableDefined(expr: fieldAccess(Expression prev, str name), TypeEnv env) = 
	checkFieldAccess(externalize(lookupType(prev, env), env), fieldAccess(name), env);

public TypeEnv checkFieldAccess(self(), f: fieldAccess(str field), TypeEnv env) = checkIsVariableDefined(f, env);
public TypeEnv checkFieldAccess(artifact(name), fieldAccess(str field), TypeEnv env) = env when isSelf(name, env);
public TypeEnv checkFieldAccess(repository(name), fieldAccess(str field), TypeEnv env) = env when isSelf(name, env);
public TypeEnv checkFieldAccess(Expression expr, fieldAccess(str field), TypeEnv env) = addError(expr, "\'<expr.name>\' is undefined", env);

public TypeEnv checkIsVariableDefined(Expression expr, TypeEnv env) = 
	addError(expr, "\'<expr.name>\' is undefined", env)
	when !isDefined(expr, env);

public TypeEnv checkIsVariableDefined(Expression, TypeEnv env) = env;

public TypeEnv checkArrayAccess(a: arrayAccess(Expression variable, Expression arrayIndexKey), TypeEnv env) = 
	checkArrayAccess(lookupType(variable, env), lookupType(arrayIndexKey, env), a, checkIndexKey(arrayIndexKey, checkExpression(variable, env)));

public TypeEnv checkArrayAccess(\map(Type key, Type v), Type indexKeyType, _, TypeEnv env) = env when key == indexKeyType;

public TypeEnv checkArrayAccess(\map(Type key, Type v), Type indexKeyType, a, TypeEnv env) = 
	addError(a,
		"Map key type is <toString(key)>, cannot access using <toString(indexKeyType)>", env)
	when key != indexKeyType;
	
public TypeEnv checkArrayAccess(\list(Type \type), integer(), _, TypeEnv env) = env;

public TypeEnv checkArrayAccess(\list(Type \type), Type indexKeyType, a, TypeEnv env) = 
	addError(a,
		"List cannot be accessed using <toString(indexKeyType)>, only integers allowed", env)
	when integer() != indexKeyType;

public TypeEnv checkArrayAccess(Type t, Type indexKeyType, a, TypeEnv env) = 
	addError(a, "Cannot access <toString(t)> as array", env);

public TypeEnv checkIndexKey(Expression key, TypeEnv env) = checkIndexKey(lookupType(key, env), key, checkExpression(key, env));

public TypeEnv checkIndexKey(unknownType(), key, TypeEnv env) = 
	addError(key, "Type of array index key used cannot be determined", env);
public TypeEnv checkIndexKey(voidValue(), key, TypeEnv env) = 
	addError(key, "Void cannot be used as array index key", env);
	
public TypeEnv checkIndexKey(Type t, key, TypeEnv env) = env;

public TypeEnv checkExpression(e: product(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);
public TypeEnv checkExpression(e: remainder(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);
public TypeEnv checkExpression(e: division(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);
public TypeEnv checkExpression(e: addition(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);
public TypeEnv checkExpression(e: subtraction(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);

public TypeEnv checkBinaryMath(e, Expression lhs, Expression rhs, TypeEnv env) = 
	checkExpression(rhs, checkExpression(lhs, checkBinaryMath(e, lookupType(lhs, env), lookupType(rhs, env), env)));

public TypeEnv checkBinaryMath(e, unknownType(), _, env) = 
	addError(e, "Cannot apply <stringify(e)> on unknown type", env);
	
public TypeEnv checkBinaryMath(e, _, unknownType(), env) = 
	addError(e, "Cannot apply <stringify(e)> on unknown type", env);
	
public TypeEnv checkBinaryMath(e, integer(), integer(), env) = env;
public TypeEnv checkBinaryMath(e, integer(), float(), env) = env;
public TypeEnv checkBinaryMath(e, float(), float(), env) = env;
public TypeEnv checkBinaryMath(e, float(), integer(), env) = env;
public TypeEnv checkBinaryMath(e, Type lhs, Type rhs, env) = 
	addError(e, "Cannot apply <stringify(e)> on <toString(lhs)> and <toString(rhs)>", env);

private str stringify(product(_, _)) = "multiplication";
private str stringify(remainder(_, _)) = "remainder";
private str stringify(division(_, _)) = "division";
private str stringify(addition(_, _)) = "addition";
private str stringify(subtraction(_, _)) = "subtraction";

public TypeEnv checkExpression(e: greaterThanOrEq(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: lessThanOrEq(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: lessThan(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: greaterThan(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: equals(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: nonEquals(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);

public TypeEnv checkComparison(e, Expression lhs, Expression rhs, TypeEnv env) = 
	checkExpression(rhs, checkExpression(lhs, checkComparison(e, lookupType(lhs, env), lookupType(rhs, env), env)));

public TypeEnv checkComparison(e, integer(), integer(), TypeEnv env) = env;
public TypeEnv checkComparison(e, float(), integer(), TypeEnv env) = env;
public TypeEnv checkComparison(e, integer(), float(), TypeEnv env) = env;
public TypeEnv checkComparison(e, float(), float(), TypeEnv env) = env;
public TypeEnv checkComparison(equals(_, _), Type l, Type r, TypeEnv env) = env when l == r;
public TypeEnv checkComparison(nonEquals(_, _), Type l, Type r, TypeEnv env) = env when l == r;
public TypeEnv checkComparison(e, Type l, Type r, TypeEnv env) = 
	addError(e, "Cannot compare <toString(l)> and <toString(r)>", env);

public TypeEnv checkExpression(e: and(Expression lhs, Expression rhs), TypeEnv env) = 
	checkExpression(rhs, checkExpression(lhs, checkBinaryLogic(e, lookupType(lhs, env), lookupType(rhs, env), env)));

public TypeEnv checkExpression(e: or(Expression lhs, Expression rhs), TypeEnv env) = 
	checkExpression(rhs, checkExpression(lhs, checkBinaryLogic(e, lookupType(lhs, env), lookupType(rhs, env), env)));

public TypeEnv checkBinaryLogic(e, boolean(), boolean(), TypeEnv env) = env;
public TypeEnv checkBinaryLogic(e, Type l, Type r, TypeEnv env) = 
	addError(e, "Cannot apply logical operation on <toString(l)> and <toString(r)>", env);

public TypeEnv checkExpression(e: negative(Expression expr), TypeEnv env) = 
	checkExpression(expr, checkUnaryMath(e, lookupType(expr, env), env));
public TypeEnv checkExpression(e: positive(Expression expr), TypeEnv env) = 
	checkExpression(expr, checkUnaryMath(e, lookupType(expr, env), env));

public TypeEnv checkUnaryMath(Expression, float(), TypeEnv env) = env;
public TypeEnv checkUnaryMath(Expression, integer(), TypeEnv env) = env;
public TypeEnv checkUnaryMath(n, Type t, TypeEnv env) = 
	addError(n, "Cannot apply <stringify(n)> on <toString(t)>", env);

private str stringify(negative(_)) = "minus";
private str stringify(positive(_)) = "plus";

public TypeEnv checkExpression(e: ifThenElse(Expression condition, Expression ifThen, Expression \else), TypeEnv env) = checkIfThenElse(e, env);

public TypeEnv checkIfThenElse(e: ifThenElse(Expression condition, Expression ifThen, Expression \else), TypeEnv env) = 
	checkIfThenElse(e, lookupType(ifThen, env), lookupType(\else, env), checkExpression(ifThen, checkExpression(\else, checkCondition(condition, env))));

public TypeEnv checkIfThenElse(e, \list(_), \list(voidValue()), TypeEnv env) = env;
public TypeEnv checkIfThenElse(e, \list(voidValue()), \list(_), TypeEnv env) = env;
public TypeEnv checkIfThenElse(e, \map(_, _), \map(voidValue(), voidValue()), TypeEnv env) = env;
public TypeEnv checkIfThenElse(e, \map(voidValue(), voidValue()), \map(_, _), TypeEnv env) = env;
public TypeEnv checkIfThenElse(e, Type leftType, Type rightType, TypeEnv env) = env when leftType == rightType;
public TypeEnv checkIfThenElse(e, Type leftType, Type rightType, TypeEnv env) = 
	addError(e, "Ternary cannot return different types", env)
	when leftType != rightType;

public TypeEnv checkCondition(Expression condition, TypeEnv env) = checkIsBoolean(lookupType(condition, env), condition, checkExpression(condition, env));

public TypeEnv checkIsBoolean(boolean(), _, TypeEnv env) = env;
public TypeEnv checkIsBoolean(_, c, TypeEnv env) = 
	addError(c, "Condition does not evaluate to boolean", env);
	
public TypeEnv checkExpression(n: new(l: local(str name), list[Expression] args), TypeEnv env) = 
	checkConstructor(n, checkExpressions(args, checkNewArtifact(n, l, env)));

public TypeEnv checkConstructor(n: new(local(str name), list[Expression] args), TypeEnv env) = 
	addError(n, "Cannot match constructor <name>(<toString(toSignature(args, env), ", ")>)", env)
	when hasLocalArtifact(name, env) && !hasConstructor(toSignature(args, env), findModule(externalize(n, env), env), env);

public TypeEnv checkConstructor(n: new(local(str name), list[Expression] args), TypeEnv env) = env;

public TypeEnv checkNewArtifact(n, l: local(str name), TypeEnv env) = 
	addError(n, "Artifact <name> used but not imported", env)
	when !hasLocalArtifact(name, env);
	
public TypeEnv checkNewArtifact(n, local(str name), TypeEnv env) = checkNewArtifact(n, getFullNameOfLocalArtifact(name, env), env);
	
public TypeEnv checkNewArtifact(n, e: external(str localName, Declaration namespace, str originalName), TypeEnv env) = 
	addError(n, "Cannot find artifact <stringify(e)> used", env)
	when !isInAST(toNamespace(e), env);
	
public TypeEnv checkNewArtifact(n, e: external(str localName, Declaration namespace, str originalName), TypeEnv env) = 
	addError(n, "Cannot instantiate artifact <stringify(e)>: only entities and value objects can be instantiated", env)
	when isInAST(toNamespace(e), env) && !(isEntity(toNamespace(e), env) || isValueObject(toNamespace(e), env));
	
public TypeEnv checkNewArtifact(n, e: external(str localName, Declaration namespace, str originalName), TypeEnv env) = env;

private str stringify(external(str localName, Declaration namespace, str originalName)) = 
	namespaceToString(namespace, "::") + "::<originalName>";

public TypeEnv checkExpression(i: invoke(str m, list[Expression] params), TypeEnv env) = 
	checkInvoke(i, toSignature(params, env), env);

public TypeEnv checkInvoke(i: invoke(str m, list[Expression] params), list[Type] signature, TypeEnv env) = 
	addError(i, "Call to an undefined method <m>(<toString(signature,  ", ")>)", env)
	when !hasMethod(m, signature, env);

public TypeEnv checkInvoke(i: invoke(str m, list[Expression] params), list[Type] signature, TypeEnv env) = env;

public bool hasMethod(str name, list[Type] signature, TypeEnv env) = 
	(false | true | method(Modifier access, _, name, params, _, _) <- getMethods(getContext(env)), 
		isSignatureMatching(signature, params, env) && isMethodAccessible(access, getDimension(env)));

public bool hasConstructor([], Declaration m, TypeEnv env) = true when size(getConstructors(m)) == 0;

public bool hasConstructor(list[Type] signature, Declaration m, TypeEnv env) = 
	(false | true | constructor(list[Declaration] params, _, _) <- getConstructors(m), isSignatureMatching(signature, params, env));

public bool isMethodAccessible(Modifier, 0) = true;
public bool isMethodAccessible(\public(), int i) = true when i > 0;
public bool isMethodAccessible(\private(), int i) = false when i > 0;
	
public bool isSignatureMatching(list[Type] signature, list[Declaration] params, TypeEnv env) = 
	signature <= toSignature(params, env) && haveDefaultValues(slice(params, size(signature), size(params) - size(signature)));
	
public bool haveDefaultValues(list[Declaration] params) = 
	params == [p | p: param(_, _, Expression defaultValue) <- params, emptyExpr() != defaultValue];

public list[Type] toSignature(list[Expression] params, TypeEnv env) = [lookupType(p, env) | p <- params];
public list[Type] toSignature(list[Declaration] params, TypeEnv env) = [t | param(Type t, _, _) <- params];

public TypeEnv checkExpression(i: invoke(Expression prev, str m, list[Expression] params), TypeEnv env) = 
	checkInvoke(lookupType(prev, env), i, toSignature(params, env), env);

public TypeEnv checkInvoke(self(), i: invoke(Expression prev, str m, list[Expression] params), list[Type] signature, TypeEnv env) =
	checkInvoke(invoke(m, params)[@src=i@src], signature, env);

public TypeEnv checkInvoke(unknownType(), i: invoke(Expression prev, str m, list[Expression] params), list[Type] signature, TypeEnv env) =
	addError(i,
		"Cannot call method <m>(<toString(signature,  ", ")>) on unknown type",
		checkExpression(prev, env)
	);
	
public TypeEnv checkInvoke(Type prevType, i: invoke(Expression prev, str m, list[Expression] params), list[Type] signature, TypeEnv env) =
	addError(i,
		"Cannot call method <m>(<toString(signature,  ", ")>) on <toString(prevType)>",
		checkExpression(prev, env)
	) when (artifact(_) !:= prevType && repository(_) !:= prevType);
	
public TypeEnv checkInvoke(Type prevType, i: invoke(Expression prev, str m, list[Expression] params), list[Type] signature, TypeEnv env) =
	decrementDimension(setContext(getContext(env), 
		checkInvoke(invoke(m, params)[@src=i@src], signature, 
			incrementDimension(setContext(findModule(prevType, env), checkExpression(prev, env)))
		)
	));
	
public TypeEnv checkExpression(emptyExpr(), TypeEnv env) = env;

@doc="Empty expression is always unknown type"
public Type lookupType(emptyExpr(), _) = unknownType();

@doc="Lookup this"
public Type lookupType(this(), TypeEnv env) = self();

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

public Type lookupType(invoke(str m, args), TypeEnv env) {
	visit (getContext(env)) { 
		case method(Modifier access, Type t, m, params, _, _): 
			if (isMethodAccessible(access, getDimension(env)) && isSignatureMatching(toSignature(args, env), params, env)) {
				return externalize(t, env); 
			}
	}
	
	return unknownType();
}

public Type lookupType(invoke(Expression prev, str m, params), TypeEnv env) = 
	lookupType(externalize(lookupType(prev, env), env), invoke(m , params), env);
	
public Type lookupType(self(), i: invoke(str m, params), TypeEnv env) = lookupType(i, env);
	
public Type lookupType(Type prev, i: invoke(str m, params), TypeEnv env) = 
	lookupType(i, incrementDimension(setContext(findModule(prev, env), env))) when hasModule(prev, env);
	
public Type lookupType(Type prev, i: invoke(str m, params), TypeEnv) = unknownType();

public Type lookupType(fieldAccess(str field), TypeEnv env) = 
	externalize(findLocalProperty(field, env).valueType, env) when hasLocalProperty(field, env);
	
public Type lookupType(f: fieldAccess(str field), TypeEnv env) = 
	lookupType(findLocalRelation(field, env), f, env) when hasLocalRelation(field, env);
	
public Type lookupType(f: fieldAccess(str field), TypeEnv env) = unknownType();

public Type lookupType(f: fieldAccess(this(), str field), TypeEnv env) = lookupType(fieldAccess(field), env);

public Type lookupType(f: fieldAccess(Expression prev, str field), TypeEnv env) = 
	lookupType(externalize(lookupType(prev, env), env), fieldAccess(field), env);
	
public Type lookupType(self(), f: fieldAccess(str field), TypeEnv env) = lookupType(f, env);
public Type lookupType(artifact(name), f: fieldAccess(str field), TypeEnv env) = lookupType(f, env) when isSelf(name, env);
public Type lookupType(repository(name), f: fieldAccess(str field), TypeEnv env) = lookupType(f, env) when isSelf(name, env);
public Type lookupType(Type, f: fieldAccess(str field), TypeEnv env) = unknownType();


private bool isSelf(local(str name), TypeEnv env) = getContext(env).artifact.name == name;
private bool isSelf(external(str name, ns, str original), TypeEnv env) = 
	getContext(env).artifact.name == original && ns == getContext(env).namespace;

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
private Type lookupMathCompatibility(integer(), float()) = float();
private Type lookupMathCompatibility(float(), integer()) = float();
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
