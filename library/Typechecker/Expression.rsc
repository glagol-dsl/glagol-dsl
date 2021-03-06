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

public TypeEnv checkExpression(l: \list(list[Expression] items), TypeEnv env) = checkList(l, lookupType(l, env), checkExpressions(items, env));

public TypeEnv checkExpressions(list[Expression] exprs, TypeEnv env) = (env | checkExpression(expr, it) | expr <- exprs);
public TypeEnv checkExpressions(map[Expression, Expression] exprs, TypeEnv env) = 
	(env | checkExpression(exprs[expr], checkExpression(expr, it)) | expr <- exprs);

public TypeEnv checkList(Expression l, \list(unknownType()), TypeEnv env) = addError(l, "Cannot unveil list type", env);
public TypeEnv checkList(Expression l, \list(Type t), TypeEnv env) = env;
	
public TypeEnv checkExpression(\map(map[Expression, Expression] items), TypeEnv env) = env when size(items) == 0;

public TypeEnv checkExpression(m: \map(map[Expression, Expression] items), TypeEnv env) = 
	checkMap(m, lookupType(m, env), checkExpressions(items, env));

public TypeEnv checkMap(Expression m, \map(unknownType(), unknownType()), TypeEnv env) = 
	addError(m,  "Cannot unveil map key and value types", env);
	
public TypeEnv checkMap(Expression m, \map(unknownType(), Type v), TypeEnv env) = 
	addError(m,  "Cannot unveil map key type", env);
	
public TypeEnv checkMap(Expression m, \map(Type k, unknownType()), TypeEnv env) = 
	addError(m,  "Cannot unveil map value type", env);
	
public TypeEnv checkMap(Expression m, \map(Type k, Type v), TypeEnv env) = env;

public TypeEnv checkExpression(boolean(_), TypeEnv env) = env;
public TypeEnv checkExpression(string(_), TypeEnv env) = env;
public TypeEnv checkExpression(float(_), TypeEnv env) = env;
public TypeEnv checkExpression(integer(_), TypeEnv env) = env;
public TypeEnv checkExpression(\bracket(Expression expr), TypeEnv env) = checkExpression(expr, env);
public TypeEnv checkExpression(v: variable(GlagolID name), TypeEnv env) = checkIsVariableDefined(v, env);
public TypeEnv checkExpression(f: fieldAccess(_), TypeEnv env) = checkIsVariableDefined(f, env);
public TypeEnv checkExpression(f: fieldAccess(_, _), TypeEnv env) = checkIsVariableDefined(f, env);
public TypeEnv checkExpression(a: arrayAccess(_, _), TypeEnv env) = checkArrayAccess(a, env);

public TypeEnv checkIsVariableDefined(expr: fieldAccess(s: symbol(str name)), TypeEnv env) = 
	addError(expr, "\'<name>\' is undefined", env)
	when !hasLocalProperty(name, env);

public TypeEnv checkIsVariableDefined(expr: fieldAccess(s: symbol(str name)), TypeEnv env) = env;

public TypeEnv checkIsVariableDefined(expr: fieldAccess(this(), s: symbol(str name)), TypeEnv env) = 
	addError(expr, "\'<name>\' is undefined", env)
	when !hasLocalProperty(name, env);

public TypeEnv checkIsVariableDefined(expr: fieldAccess(this(), s: symbol(str name)), TypeEnv env) = env;
public TypeEnv checkIsVariableDefined(expr: fieldAccess(Expression prev, s: symbol(str name)), TypeEnv env) = 
	checkFieldAccess(lookupType(prev, env), prev, fieldAccess(s), env);

public TypeEnv checkFieldAccess(self(), Expression prev, f: fieldAccess(s: symbol(str field)), TypeEnv env) = checkIsVariableDefined(f, env);
public TypeEnv checkFieldAccess(artifact(name), Expression prev, fieldAccess(s: symbol(str field)), TypeEnv env) = env when isSelf(name, env);
public TypeEnv checkFieldAccess(repository(name), Expression prev, fieldAccess(s: symbol(str field)), TypeEnv env) = env when isSelf(name, env);
public TypeEnv checkFieldAccess(Type t, Expression prev, f: fieldAccess(s: symbol(str field)), TypeEnv env) = addError(prev, "\'<field>\' is undefined", env);

public TypeEnv checkIsVariableDefined(Expression expr, TypeEnv env) = 
	addError(expr, "\'<expr.name>\' is undefined", env)
	when !isDefined(expr, env);

public TypeEnv checkIsVariableDefined(Expression e, TypeEnv env) = env;

public TypeEnv checkArrayAccess(a: arrayAccess(Expression variable, Expression arrayIndexKey), TypeEnv env) = 
	checkArrayAccess(lookupType(variable, env), lookupType(arrayIndexKey, env), a, checkIndexKey(arrayIndexKey, checkExpression(variable, env)));

public TypeEnv checkArrayAccess(\map(Type key, Type v), Type indexKeyType, Expression a, TypeEnv env) = env when key == indexKeyType;

public TypeEnv checkArrayAccess(\map(Type key, Type v), Type indexKeyType, Expression a, TypeEnv env) = 
	addError(a,
		"Map key type is <toString(key)>, cannot access using <toString(indexKeyType)>", env)
	when key != indexKeyType;
	
public TypeEnv checkArrayAccess(\list(Type \type), integer(), Expression a, TypeEnv env) = env;

public TypeEnv checkArrayAccess(\list(Type \type), Type indexKeyType, Expression a, TypeEnv env) = 
	addError(a,
		"List cannot be accessed using <toString(indexKeyType)>, only integers allowed", env)
	when integer() != indexKeyType;

public TypeEnv checkArrayAccess(Type t, Type indexKeyType, Expression a, TypeEnv env) = 
	addError(a, "Cannot access <toString(t)> as array", env);

public TypeEnv checkIndexKey(Expression key, TypeEnv env) = checkIndexKey(lookupType(key, env), key, checkExpression(key, env));

public TypeEnv checkIndexKey(unknownType(), Expression key, TypeEnv env) = addError(key, "Type of array index key used cannot be determined", env);
	
public TypeEnv checkIndexKey(voidValue(), Expression key, TypeEnv env) = addError(key, "Void cannot be used as array index key", env);
	
public TypeEnv checkIndexKey(Type t, Expression key, TypeEnv env) = env;

public TypeEnv checkExpression(e: product(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);
public TypeEnv checkExpression(e: remainder(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);
public TypeEnv checkExpression(e: division(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);
public TypeEnv checkExpression(e: addition(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);
public TypeEnv checkExpression(e: subtraction(Expression lhs, Expression rhs), TypeEnv env) = checkBinaryMath(e, lhs, rhs, env);
public TypeEnv checkExpression(e: concat(Expression lhs, Expression rhs), TypeEnv env) = checkConcat(e, lhs, rhs, env);

public TypeEnv checkConcat(Expression e, Expression lhs, Expression rhs, TypeEnv env) = 
	checkExpression(rhs, checkExpression(lhs, checkConcat(e, lookupType(lhs, env), lookupType(rhs, env), env)));

public TypeEnv checkConcat(Expression e, unknownType(), Type t, TypeEnv env) = 
	addError(e, "Cannot concatenate unknown type and <toString(t)>", env);
	
public TypeEnv checkConcat(Expression e, Type t, unknownType(), TypeEnv env) = 
	addError(e, "Cannot concatenate <toString(t)> and unknown type", env);

public TypeEnv checkConcat(Expression e, Type l, Type r, TypeEnv env) = 
	addError(e, "Cannot concatenate <toString(l)> and <toString(r)>", env) when !concatCompatible(l, r);
	
public TypeEnv checkConcat(Expression e, Type l, Type r, TypeEnv env) = env;

public TypeEnv checkBinaryMath(Expression e, Expression lhs, Expression rhs, TypeEnv env) = 
	checkExpression(rhs, checkExpression(lhs, checkBinaryMath(e, lookupType(lhs, env), lookupType(rhs, env), env)));

public TypeEnv checkBinaryMath(Expression e, unknownType(), Type t, TypeEnv env) = 
	addError(e, "Cannot apply <stringify(e)> on unknown type", env);
	
public TypeEnv checkBinaryMath(Expression e, Type t, unknownType(), TypeEnv env) = 
	addError(e, "Cannot apply <stringify(e)> on unknown type", env);
	
public TypeEnv checkBinaryMath(Expression e, integer(), integer(), TypeEnv env) = env;
public TypeEnv checkBinaryMath(Expression e, integer(), float(), TypeEnv env) = env;
public TypeEnv checkBinaryMath(Expression e, float(), float(), TypeEnv env) = env;
public TypeEnv checkBinaryMath(Expression e, float(), integer(), TypeEnv env) = env;
public TypeEnv checkBinaryMath(Expression e, Type lhs, Type rhs, TypeEnv env) = 
	addError(e, "Cannot apply <stringify(e)> on <toString(lhs)> and <toString(rhs)>", env);

private str stringify(product(Expression l, Expression r)) = "multiplication";
private str stringify(remainder(Expression l, Expression r)) = "remainder";
private str stringify(division(Expression l, Expression r)) = "division";
private str stringify(addition(Expression l, Expression r)) = "addition";
private str stringify(subtraction(Expression l, Expression r)) = "subtraction";

public TypeEnv checkExpression(e: greaterThanOrEq(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: lessThanOrEq(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: lessThan(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: greaterThan(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: equals(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);
public TypeEnv checkExpression(e: nonEquals(Expression lhs, Expression rhs), TypeEnv env) = checkComparison(e, lhs, rhs, env);

public TypeEnv checkComparison(Expression e, Expression lhs, Expression rhs, TypeEnv env) = 
	checkExpression(rhs, checkExpression(lhs, checkComparison(e, lookupType(lhs, env), lookupType(rhs, env), env)));

public TypeEnv checkComparison(Expression e, integer(), integer(), TypeEnv env) = env;
public TypeEnv checkComparison(Expression e, float(), integer(), TypeEnv env) = env;
public TypeEnv checkComparison(Expression e, integer(), float(), TypeEnv env) = env;
public TypeEnv checkComparison(Expression e, float(), float(), TypeEnv env) = env;
public TypeEnv checkComparison(equals(Expression lhs, Expression rhs), Type l, Type r, TypeEnv env) = env when l == r;
public TypeEnv checkComparison(nonEquals(Expression lhs, Expression rhs), Type l, Type r, TypeEnv env) = env when l == r;
public TypeEnv checkComparison(Expression e, Type l, Type r, TypeEnv env) = 
	addError(e, "Cannot compare <toString(l)> and <toString(r)>", env);

public TypeEnv checkExpression(e: and(Expression lhs, Expression rhs), TypeEnv env) = 
	checkExpression(rhs, checkExpression(lhs, checkBinaryLogic(e, lookupType(lhs, env), lookupType(rhs, env), env)));

public TypeEnv checkExpression(e: or(Expression lhs, Expression rhs), TypeEnv env) = 
	checkExpression(rhs, checkExpression(lhs, checkBinaryLogic(e, lookupType(lhs, env), lookupType(rhs, env), env)));

public TypeEnv checkBinaryLogic(Expression e, boolean(), boolean(), TypeEnv env) = env;
public TypeEnv checkBinaryLogic(Expression e, Type l, Type r, TypeEnv env) = 
	addError(e, "Cannot apply logical operation on <toString(l)> and <toString(r)>", env);

public TypeEnv checkExpression(e: negative(Expression expr), TypeEnv env) = 
	checkExpression(expr, checkUnaryMath(e, lookupType(expr, env), env));

public TypeEnv checkUnaryMath(Expression n, float(), TypeEnv env) = env;
public TypeEnv checkUnaryMath(Expression n, integer(), TypeEnv env) = env;
public TypeEnv checkUnaryMath(Expression n, Type t, TypeEnv env) = 
	addError(n, "Cannot apply <stringify(n)> on <toString(t)>", env);

private str stringify(negative(Expression n)) = "minus";

public TypeEnv checkExpression(e: ifThenElse(Expression condition, Expression ifThen, Expression \else), TypeEnv env) = checkIfThenElse(e, env);

public TypeEnv checkIfThenElse(e: ifThenElse(Expression condition, Expression ifThen, Expression \else), TypeEnv env) = 
	checkIfThenElse(e, lookupType(ifThen, env), lookupType(\else, env), checkExpression(ifThen, checkExpression(\else, checkCondition(condition, env))));

public TypeEnv checkIfThenElse(Expression e, \list(Type t), \list(voidValue()), TypeEnv env) = env;
public TypeEnv checkIfThenElse(Expression e, \list(voidValue()), \list(Type t), TypeEnv env) = env;
public TypeEnv checkIfThenElse(Expression e, \map(Type k, Type v), \map(voidValue(), voidValue()), TypeEnv env) = env;
public TypeEnv checkIfThenElse(Expression e, \map(voidValue(), voidValue()), \map(Type k, Type v), TypeEnv env) = env;
public TypeEnv checkIfThenElse(Expression e, Type leftType, Type rightType, TypeEnv env) = env when leftType == rightType;
public TypeEnv checkIfThenElse(Expression e, Type leftType, Type rightType, TypeEnv env) = 
	addError(e, "Ternary cannot return different types", env)
	when leftType != rightType;

public TypeEnv checkCondition(Expression condition, TypeEnv env) = checkIsBoolean(lookupType(condition, env), condition, checkExpression(condition, env));

public TypeEnv checkIsBoolean(boolean(), Expression e, TypeEnv env) = env;
public TypeEnv checkIsBoolean(Type t, Expression c, TypeEnv env) = 
	addError(c, "Condition does not evaluate to boolean", env);
	
public TypeEnv checkExpression(n: new(Name name, list[Expression] args), TypeEnv env) = 
	checkConstructor(n, checkExpressions(args, checkNewArtifact(n, name, env)));

public TypeEnv checkConstructor(n: new(Name name, list[Expression] args), TypeEnv env) = 
	addError(n, "Cannot match constructor <name.localName>(<toString(toSignature(args, env), ", ")>)", env)
	when hasLocalArtifact(name.localName, env) && !hasConstructor(toSignature(args, env), findModule(n, env), env);

public TypeEnv checkConstructor(n: new(Name name, list[Expression] args), TypeEnv env) = env;
	
public TypeEnv checkNewArtifact(Expression n, e: fullName(str localName, Declaration namespace, str originalName), TypeEnv env) = 
	addError(n, "<stringify(e)> not found", env)
	when !isInAST(toNamespace(e), env);
	
public TypeEnv checkNewArtifact(Expression n, e: fullName(str localName, Declaration namespace, str originalName), TypeEnv env) = 
	addError(n, "Cannot instantiate artifact <stringify(e)>: only entities and value objects can be instantiated", env)
	when isInAST(toNamespace(e), env) && !(isEntity(toNamespace(e), env) || isValueObject(toNamespace(e), env));
	
public TypeEnv checkNewArtifact(Expression n, e: fullName(str localName, Declaration namespace, str originalName), TypeEnv env) = env;

private str stringify(fullName(str localName, Declaration namespace, str originalName)) = 
	namespaceToString(namespace, "::") + "::<originalName>";

public TypeEnv checkExpression(i: invoke(s: symbol(str m), list[Expression] params), TypeEnv env) = 
	checkInvoke(i, toSignature(params, env), checkExpressions(params, env));

public TypeEnv checkInvoke(i: invoke(s: symbol(str m), list[Expression] params), list[Type] signature, TypeEnv env) = 
	addError(i, "Call to an undefined method <m>(<toString(signature,  ", ")>)", env)
	when !hasMethod(m, signature, env);

public TypeEnv checkInvoke(i: invoke(s: symbol(str m), list[Expression] params), list[Type] signature, TypeEnv env) = env;

public bool hasMethod(str name, list[Type] signature, TypeEnv env) = 
	(false | true | method(Modifier access, _, name, params, _, _) <- getMethods(getContext(env)), 
		isSignatureMatching(signature, params, env) && isMethodAccessible(access, getDimension(env)));

public bool hasConstructor(list[Type] signature, emptyDecl(), TypeEnv env) = false;
public bool hasConstructor([], Declaration m, TypeEnv env) = true when size(getConstructors(m)) == 0;

public bool hasConstructor(list[Type] signature, Declaration m, TypeEnv env) = 
	(false | true | constructor(list[Declaration] params, _, _) <- getConstructors(m), isSignatureMatching(signature, params, env));

public bool isMethodAccessible(Modifier m, 0) = true;
public bool isMethodAccessible(\public(), int i) = true when i > 0;
public bool isMethodAccessible(\private(), int i) = false when i > 0;
	
public bool isSignatureMatching(list[Type] signature, list[Declaration] params, TypeEnv env) = 
	signature <= toSignature(params, env) && haveDefaultValues(slice(params, size(signature), size(params) - size(signature)));
	
public bool haveDefaultValues(list[Declaration] params) = 
	params == [p | p: param(_, _, Expression defaultValue) <- params, emptyExpr() != defaultValue];

public list[Type] toSignature(list[Expression] params, TypeEnv env) = [lookupType(p, env) | p <- params];
public list[Type] toSignature(list[Declaration] params, TypeEnv env) = [t | param(Type t, _, _) <- params];

public TypeEnv checkExpression(i: invoke(Expression prev, symbol(str m), list[Expression] params), TypeEnv env) = 
	checkInvoke(lookupType(prev, env), i, toSignature(params, env), checkExpressions(params, env));

public TypeEnv checkInvoke(self(), i: invoke(Expression prev, s: symbol(str m), list[Expression] params), list[Type] signature, TypeEnv env) =
	checkInvoke(invoke(s, params)[@src=i@src], signature, env);

public TypeEnv checkInvoke(unknownType(), i: invoke(Expression prev, symbol(str m), list[Expression] params), list[Type] signature, TypeEnv env) =
	addError(i,
		"Cannot call method <m>(<toString(signature,  ", ")>) on unknown type",
		checkExpression(prev, env)
	);
	
public TypeEnv checkInvoke(Type prevType, i: invoke(Expression prev, s: symbol(str m), list[Expression] params), list[Type] signature, TypeEnv env) =
	addError(i,
		"Cannot call method <m>(<toString(signature,  ", ")>) on <toString(prevType)>",
		checkExpression(prev, env)
	) when (artifact(_) !:= prevType && repository(_) !:= prevType);
	
public TypeEnv checkInvoke(Type prevType, i: invoke(Expression prev, s: symbol(str m), list[Expression] params), list[Type] signature, TypeEnv env) =
	decrementDimension(setContext(getContext(env), 
		checkInvoke(invoke(s, params)[@src=i@src], signature, 
			incrementDimension(setContext(findModule(prevType, env), checkExpression(prev, env)))
		)
	));
	
public TypeEnv checkExpression(emptyExpr(), TypeEnv env) = env;
public TypeEnv checkExpression(this(), TypeEnv env) = env;
public TypeEnv checkExpression(cast(Type t, Expression expr), TypeEnv env) = checkCast(t, lookupType(expr, env), checkExpression(expr, env));

public TypeEnv checkCast(string(), string(), TypeEnv env) = env;
public TypeEnv checkCast(string(), integer(), TypeEnv env) = env;
public TypeEnv checkCast(string(), float(), TypeEnv env) = env;
public TypeEnv checkCast(string(), boolean(), TypeEnv env) = env;

public TypeEnv checkCast(integer(), string(), TypeEnv env) = env;
public TypeEnv checkCast(integer(), integer(), TypeEnv env) = env;
public TypeEnv checkCast(integer(), float(), TypeEnv env) = env;
public TypeEnv checkCast(integer(), boolean(), TypeEnv env) = env;

public TypeEnv checkCast(float(), string(), TypeEnv env) = env;
public TypeEnv checkCast(float(), integer(), TypeEnv env) = env;
public TypeEnv checkCast(float(), float(), TypeEnv env) = env;
public TypeEnv checkCast(float(), boolean(), TypeEnv env) = env;

public TypeEnv checkCast(boolean(), string(), TypeEnv env) = env;
public TypeEnv checkCast(boolean(), integer(), TypeEnv env) = env;
public TypeEnv checkCast(boolean(), float(), TypeEnv env) = env;
public TypeEnv checkCast(boolean(), boolean(), TypeEnv env) = env;

public TypeEnv checkCast(Type cast, Type actual, TypeEnv env) = 
	addError(cast, "Type casting <toString(actual)> to <toString(cast)> is not supported", env);

public TypeEnv checkExpression(query(querySelect(QuerySpec qs, src: querySource(Name name, Symbol as), QueryWhere w, QueryOrderBy ord, QueryLimit l)), TypeEnv env) =
	addError(src, "<stringify(name)> not found", env) when !isInAST(toNamespace(name), env);
	
public TypeEnv checkExpression(query(querySelect(QuerySpec qs, src: querySource(Name name, Symbol as), QueryWhere w, QueryOrderBy ord, QueryLimit l)), TypeEnv env) =
	addError(src, "<stringify(name)> is not an entity", env) when isInAST(toNamespace(name), env) && !isEntity(toNamespace(name), env);

public TypeEnv checkExpression(query(q: querySelect(QuerySpec querySpec, QuerySource querySource, QueryWhere where, QueryOrderBy order, QueryLimit limit)), TypeEnv env) =
	checkExpression(q, addQuerySources(querySource, newQueryEnv(), env), env);

public TypeEnv checkExpression(querySelect(QuerySpec spec, QuerySource source, QueryWhere where, QueryOrderBy order, QueryLimit limit), QueryEnv qEnv, TypeEnv env) = 
	checkQuerySpec(spec, qEnv, env);

public TypeEnv checkQuerySpec(q: querySpec(symbol(str as), bool single), QueryEnv qEnv, TypeEnv env) = 
	addError(q, "Alias \'<as>\' is not defined in the FROM clause", env) when !hasAlias(as, qEnv);

public TypeEnv checkQuerySpec(q: querySpec(symbol(str as), bool single), QueryEnv qEnv, TypeEnv env) = env;

@doc="Empty expression is always unknown type"
public Type lookupType(emptyExpr(), TypeEnv env) = unknownType();

@doc="Lookup this"
public Type lookupType(this(), TypeEnv env) = self();

@doc="Lookup literal types"
public Type lookupType(integer(int intValue), TypeEnv env) = integer();
public Type lookupType(float(real floatValue), TypeEnv env) = float();
public Type lookupType(string(str strValue), TypeEnv env) = string();
public Type lookupType(boolean(bool boolValue), TypeEnv env) = boolean();

@doc="Lookup list types"

@doc="Empty list"
public Type lookupType(\list([]), TypeEnv env) = \list(voidValue());

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
private Type lookupArrayType(Type t) = unknownType();

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
    
public Type lookupType(concat(Expression lhs, Expression rhs), TypeEnv env) = string() when concatCompatible(lookupType(lhs, env), lookupType(rhs, env));

public Type lookupType(concat(Expression lhs, Expression rhs), TypeEnv env) = unknownType();

public bool concatCompatible(string(), string()) = true;
public bool concatCompatible(string(), integer()) = true;
public bool concatCompatible(string(), float()) = true;
public bool concatCompatible(float(), string()) = true;
public bool concatCompatible(float(), float()) = true;
public bool concatCompatible(float(), integer()) = true;
public bool concatCompatible(integer(), integer()) = true;
public bool concatCompatible(integer(), string()) = true;
public bool concatCompatible(integer(), float()) = true;

public default bool concatCompatible(Type l, Type r) = false;

public Type lookupType(addition(Expression lhs, Expression rhs), TypeEnv env) = lookupMathCompatibility(lookupType(lhs, env), lookupType(rhs, env));
    
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

public Type lookupType(negative(Expression expr), TypeEnv env) = lookupUnaryMathType(lookupType(expr, env));

public Type lookupType(ifThenElse(Expression condition, Expression ifThen, Expression \else), TypeEnv env) = 
    lookupTernaryType(lookupType(ifThen, env), lookupType(\else, env));

public Type lookupType(new(e: fullName(str localName, Declaration namespace, str originalName), list[Expression] args), TypeEnv env) = 
	artifact(e) when isInAST(toNamespace(e), env) && (isEntity(toNamespace(e), env) || isValueObject(toNamespace(e), env));
public Type lookupType(new(e: fullName(str localName, Declaration namespace, str originalName), list[Expression] args), TypeEnv env) = 
	unknownType();

public Type lookupType(get(a: artifact(e: fullName(str name, Declaration namespace, str originalName))), TypeEnv env) = 
	a when isInAST(toNamespace(e), env) && isUtil(toNamespace(e), env);

public Type lookupType(get(a: artifact(e: fullName(str name, Declaration namespace, str originalName))), TypeEnv env) = unknownType();

public Type lookupType(get(a: repository(e: fullName(str name, Declaration namespace, str originalName))), TypeEnv env) = 
	a when isInAST(toNamespace(e), env) && isEntity(toNamespace(e), env);

public Type lookupType(get(t: selfie()), TypeEnv env) = t;
public Type lookupType(get(_), TypeEnv env) = unknownType();

public Type lookupType(invoke(s: symbol(str m), args), TypeEnv env) {
	visit (getContext(env)) {
		case method(Modifier access, Type t, m, params, _, _): 
			if (isMethodAccessible(access, getDimension(env)) && isSignatureMatching(toSignature(args, env), params, env)) {
				return t; 
			}
	}
	
	return unknownType();
}

public Type lookupType(invoke(Expression prev, s: symbol(str m), params), TypeEnv env) = 
	lookupType(lookupType(prev, env), invoke(s , params), env);
	
public Type lookupType(self(), i: invoke(s: symbol(str m), params), TypeEnv env) = lookupType(i, env);
	
public Type lookupType(Type prev, i: invoke(s: symbol(str m), list[Expression] args), TypeEnv env) = 
	lookupType(i, incrementDimension(setContext(findModule(prev, env), env))) when hasModule(prev, env);
	
public Type lookupType(Type prev, i: invoke(s: symbol(str m), list[Expression] args), TypeEnv env) = unknownType();

public Type lookupType(fieldAccess(s: symbol(str field)), TypeEnv env) = 
	findLocalProperty(field, env).valueType when hasLocalProperty(field, env);
	
public Type lookupType(f: fieldAccess(s: symbol(str field)), TypeEnv env) = unknownType();

public Type lookupType(f: fieldAccess(this(), s: symbol(str field)), TypeEnv env) = lookupType(fieldAccess(s), env);

public Type lookupType(f: fieldAccess(Expression prev, s: symbol(str field)), TypeEnv env) = 
	lookupType(lookupType(prev, env), fieldAccess(s), env);
	
public Type lookupType(self(), f: fieldAccess(s: symbol(str field)), TypeEnv env) = lookupType(f, env);
public Type lookupType(artifact(name), f: fieldAccess(s: symbol(str field)), TypeEnv env) = lookupType(f, env) when isSelf(name, env);
public Type lookupType(repository(name), f: fieldAccess(s: symbol(str field)), TypeEnv env) = lookupType(f, env) when isSelf(name, env);
public Type lookupType(Type t, f: fieldAccess(s: symbol(str field)), TypeEnv env) = unknownType();

public Type lookupType(cast(Type t, Expression expr), TypeEnv env) = lookupCastType(t, lookupType(expr, env), env);

@doc="Query language lookups"
public Type lookupType(query(QueryStatement queryStmt), TypeEnv env) = lookupType(queryStmt, env);
public Type lookupType(querySelect(querySpec(Symbol as, false), QuerySource source, QueryWhere where, QueryOrderBy order, QueryLimit limit), TypeEnv env) = 
	\list(lookupType(source, as, env));
public Type lookupType(querySelect(querySpec(Symbol as, true), QuerySource source, QueryWhere where, QueryOrderBy order, QueryLimit limit), TypeEnv env) = 
	lookupType(source, as, env);
public Type lookupType(querySelect(QuerySpec spec, QuerySource source, QueryWhere where, QueryOrderBy order, QueryLimit limit), TypeEnv env) = unknownType();

public Type lookupType(querySource(Name name, Symbol srcAlias), Symbol as, TypeEnv env) = artifact(name) 
	when srcAlias == as && isInAST(toNamespace(name), env) && isEntity(toNamespace(name), env);
public Type lookupType(querySource(Name name, Symbol srcAlias), Symbol as, TypeEnv env) = unknownType();

public Type lookupCastType(string(), string(), TypeEnv env) = string();
public Type lookupCastType(string(), integer(), TypeEnv env) = string();
public Type lookupCastType(string(), float(), TypeEnv env) = string();
public Type lookupCastType(string(), boolean(), TypeEnv env) = string();

public Type lookupCastType(integer(), string(), TypeEnv env) = integer();
public Type lookupCastType(integer(), integer(), TypeEnv env) = integer();
public Type lookupCastType(integer(), float(), TypeEnv env) = integer();
public Type lookupCastType(integer(), boolean(), TypeEnv env) = integer();

public Type lookupCastType(float(), string(), TypeEnv env) = float();
public Type lookupCastType(float(), integer(), TypeEnv env) = float();
public Type lookupCastType(float(), float(), TypeEnv env) = float();
public Type lookupCastType(float(), boolean(), TypeEnv env) = float();

public Type lookupCastType(boolean(), string(), TypeEnv env) = boolean();
public Type lookupCastType(boolean(), integer(), TypeEnv env) = boolean();
public Type lookupCastType(boolean(), float(), TypeEnv env) = boolean();
public Type lookupCastType(boolean(), boolean(), TypeEnv env) = boolean();

public Type lookupCastType(Type t, Type a, TypeEnv env) = unknownType();

public bool isSelf(fullName(str name, ns, str original), TypeEnv env) = 
	getContext(env).artifact.name == original && ns == getContext(env).namespace;

private Type lookupTernaryType(artifact(Name ifThen), artifact(Name \else)) = ifThen == \else ? artifact(ifThen) : unknownType();
private Type lookupTernaryType(repository(Name ifThen), repository(Name \else)) = ifThen == \else ? repository(ifThen) : unknownType();
private Type lookupTernaryType(Type ifThen, Type \else) = ifThen when ifThen == \else;
private Type lookupTernaryType(Type ifThen, Type \else) = unknownType();

private Type lookupUnaryMathType(integer()) = integer();
private Type lookupUnaryMathType(float()) = float();
private Type lookupUnaryMathType(Type t) = unknownType();

private Type lookupMathCompatibility(integer(), integer()) = integer();
private Type lookupMathCompatibility(float(), float()) = float();
private Type lookupMathCompatibility(integer(), float()) = float();
private Type lookupMathCompatibility(float(), integer()) = float();
private Type lookupMathCompatibility(Type lhs, Type rhs) = unknownType();

private Type lookupBooleanCompatibilityType(boolean(), boolean()) = boolean();
private Type lookupBooleanCompatibilityType(Type lhs, Type rhs) = unknownType();

private Type lookupRelationalCompatibilityType(string(), string(), equals(Expression lhs, Expression rhs)) = boolean();
private Type lookupRelationalCompatibilityType(string(), string(), nonEquals(Expression lhs, Expression rhs)) = boolean();
private Type lookupRelationalCompatibilityType(integer(), integer(), Expression e) = boolean();
private Type lookupRelationalCompatibilityType(integer(), float(), Expression e) = boolean();
private Type lookupRelationalCompatibilityType(float(), float(), Expression e) = boolean();
private Type lookupRelationalCompatibilityType(float(), integer(), Expression e) = boolean();
private Type lookupRelationalCompatibilityType(Type lhs, Type rhs, Expression e) = unknownType();

private Type lookupDefinitionType(localVar(declare(Type varType, Expression varName, Statement defaultValue))) = varType;
private Type lookupDefinitionType(field(property(Type valueType, GlagolID name, Expression defaultValue))) = valueType;
private Type lookupDefinitionType(param(param(Type paramType, GlagolID name, Expression defaultValue))) = paramType;
