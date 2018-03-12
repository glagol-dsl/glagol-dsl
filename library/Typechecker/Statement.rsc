module Typechecker::Statement

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Expression;
import Typechecker::Type;
import Syntax::Abstract::Glagol;

public TypeEnv checkStatements(list[Statement] stmts, Type t, Declaration subroutine, TypeEnv env) = 
	(env | checkStatement(stmt, t, subroutine, it) | stmt <- stmts);
public TypeEnv checkStatement(r: \return(Expression expr), \any(), action(_, _, _), TypeEnv env) = checkExpression(expr, env);
public TypeEnv checkStatement(r: \return(adaptable()), Type t, Declaration s, TypeEnv env) = env;
public TypeEnv checkStatement(r: \return(emptyExpr()), Type t, Declaration s, TypeEnv env) = checkReturn(voidValue(), t, r, env);
public TypeEnv checkStatement(r: \return(Expression expr), Type t, Declaration s, TypeEnv env) = checkReturn(lookupType(expr, env), t, r, checkExpression(expr, env));

public TypeEnv checkStatement(emptyStmt(), Type t, Declaration s, TypeEnv env) = env;

public TypeEnv checkReturn(Type actualType, Type expectedType, Statement r, TypeEnv env) = 
	addError(r, "Returning <toString(actualType)>, <toString(expectedType)> expected", env)
	when !isCompatibleForReturn(actualType, expectedType, env);

private bool isCompatibleForReturn(\list(voidValue()), \list(Type t), TypeEnv env) = true;
private bool isCompatibleForReturn(\map(voidValue(), voidValue()), \map(Type l, Type r), TypeEnv env) = true;
private bool isCompatibleForReturn(self(), artifact(Name n), TypeEnv env) = isSelf(n, env);
private bool isCompatibleForReturn(self(), repository(Name n), TypeEnv env) = isSelf(n, env);
	
private bool isCompatibleForReturn(Type actualType, Type expectedType, TypeEnv env) = actualType == expectedType;
	
public TypeEnv checkReturn(Type actualType, Type expectedType, Statement r, TypeEnv env) = env;

public TypeEnv checkStatement(block(list[Statement] stmts), Type t, Declaration s, TypeEnv env) = checkStatements(stmts, t, s, env);
public TypeEnv checkStatement(expression(expr), Type t, Declaration s, TypeEnv env) = checkExpression(expr, env);
public TypeEnv checkStatement(ifThen(condition, then), Type t, Declaration s, TypeEnv env) = checkStatement(then, t, s, checkCondition(condition, env));
public TypeEnv checkStatement(ifThenElse(Expression condition, Statement then, Statement \else), Type t, Declaration s, TypeEnv env) = 
	checkStatement(\else, t, s, checkStatement(then, t, s, checkCondition(condition, env)));
	
public TypeEnv checkStatement(a: assign(fieldAccess(this(), s: symbol(str name)), _, _), Type t, Declaration subroutine, TypeEnv env) = 
	addError(a, "Value objects are immutable. You can only assign property values from the constructor or private methods", env)
	when isValueObject(env) && !canVOSubroutineAssignProps(subroutine) && hasLocalProperty(name, env);
	
public TypeEnv checkStatement(a: assign(fieldAccess(Expression prev, s: symbol(str name)), AssignOperator ao, Statement val), Type t, Declaration subroutine, TypeEnv env) = 
	addError(a, "Value objects are immutable. You can only assign property values from the constructor or private methods", env)
	when isValueObject(env) && !canVOSubroutineAssignProps(subroutine) && sameAs(lookupType(prev, env), contextAsType(env), env);

private bool canVOSubroutineAssignProps(constructor(_, _, _)) = true;
private bool canVOSubroutineAssignProps(method(\private(), _, _, _, _, _)) = true;
private bool canVOSubroutineAssignProps(Declaration d) = false;

public bool sameAs(Type: repository(Name first), Type: repository(Name second), TypeEnv env) = sameAs(first, second);
public bool sameAs(Type: artifact(Name first), Type: artifact(Name second), TypeEnv env) = sameAs(first, second);

public bool sameAs(fullName(_, Declaration namespace, str originalName), fullName(_, Declaration namespaceT, str originalNameT)) =
	namespace == namespaceT && originalName == originalNameT;
	
public bool sameAs(Name first, Name second) = false;
public bool sameAs(Type first, Type second, TypeEnv env) = false;
	
public TypeEnv checkStatement(a: assign(variable(GlagolID name), _, _), Type t, Declaration subroutine, TypeEnv env) = 
	addError(a, "Value objects are immutable. You can only assign property values from the constructor or private methods", env)
	when isValueObject(env) && !canVOSubroutineAssignProps(subroutine) && isField(name, env);

public TypeEnv checkStatement(a: assign(assignable, operator, val), Type t, Declaration s, TypeEnv env) = 
	checkAssignType(a, lookupType(assignable, env), lookupType(val, env), checkAssignable(assignable, checkStatement(val, t, s, env)));

public TypeEnv checkAssignType(Statement s, \list(Type t), \list(voidValue()), TypeEnv env) = env;
public TypeEnv checkAssignType(Statement s, \map(Type k, Type v), \map(voidValue(), voidValue()), TypeEnv env) = env;
public TypeEnv checkAssignType(Statement s, artifact(Name n), self(), TypeEnv env) = env;
public TypeEnv checkAssignType(Statement s, repository(Name n), self(), TypeEnv env) = env;
	
public TypeEnv checkAssignType(Statement s, Type expectedType, Type actualType, TypeEnv env) =
	addError(s,
		"Cannot assign value of type <toString(actualType)> to a variable of type <toString(expectedType)>", env)
	when expectedType != actualType;

public TypeEnv checkAssignType(a: assign(assignable, operator, val), Type expectedType, Type actualType, TypeEnv env) = 
	addError(a, "Assignment operator not allowed", env)
	when !isOperatorAllowed(expectedType, operator);

public TypeEnv checkAssignType(Statement s, Type expectedType, Type actualType, TypeEnv env) = env;

public bool isOperatorAllowed(Type t, defaultAssign()) = true;
public bool isOperatorAllowed(integer(), AssignOperator a) = true;
public bool isOperatorAllowed(float(), AssignOperator a) = true;
public bool isOperatorAllowed(string(), additionAssign()) = true;
public bool isOperatorAllowed(\list(Type \type), additionAssign()) = true;
public bool isOperatorAllowed(Type t, AssignOperator a) = false;

public TypeEnv checkAssignable(v: variable(_), TypeEnv env) = checkExpression(v, env);
public TypeEnv checkAssignable(f: fieldAccess(_), TypeEnv env) = checkExpression(f, env);
public TypeEnv checkAssignable(f: fieldAccess(_, _), TypeEnv env) = checkExpression(f, env);
public TypeEnv checkAssignable(a: arrayAccess(_, _), TypeEnv env) = checkExpression(a, env);
public TypeEnv checkAssignable(Expression e, TypeEnv env) = addError(e, "Cannot assign value to expression", env);

public TypeEnv checkConditions(list[Expression] conditions, TypeEnv env) = (env | checkCondition(c, it) | c <- conditions);

public TypeEnv checkStatement(emptyStmt(), Type t, Declaration s, TypeEnv env) = env;
public TypeEnv checkStatement(p: persist(Expression expr), Type t, Declaration s, TypeEnv env) = checkORMFunction(p, env);
public TypeEnv checkStatement(p: flush(Expression expr), Type t, Declaration s, TypeEnv env) = checkORMFunction(p, env);
public TypeEnv checkStatement(p: remove(Expression expr), Type t, Declaration s, TypeEnv env) = checkORMFunction(p, env);

public TypeEnv checkORMFunction(Statement p, TypeEnv env) = checkIsContextARepository(getContext(env), p, env) when emptyExpr() := p.expr;
public TypeEnv checkORMFunction(Statement p, TypeEnv env) = checkIsContextARepository(getContext(env), p, checkIsSubjectAnEntity(lookupType(p.expr, env), p, env));

public TypeEnv checkIsSubjectAnEntity(t: artifact(Name n), Statement p, TypeEnv env) = env when isEntity(t, env);
public TypeEnv checkIsSubjectAnEntity(Type t, Statement p, TypeEnv env) = addError(p, "Only entities can be <stringify(p)>", env);

public TypeEnv checkIsContextARepository(\module(Declaration ns, list[Declaration] imports, repository(str name, list[Declaration] ds)), Statement p, TypeEnv env) = env;
public TypeEnv checkIsContextARepository(Declaration c, Statement p, TypeEnv env) = addError(p, "Entities can only be <stringify(p)> from within a repository", env);

public TypeEnv checkStatement(d: declare(Type tt, Expression varName, Statement v), Type t,  Declaration s, TypeEnv env) = 
	addError(d, "Cannot resolve variable name", env)
	when variable(_) !:= varName;

public TypeEnv checkStatement(d: declare(Type varType, variable(GlagolID name), emptyStmt()), Type t, Declaration s, TypeEnv env) = 
	checkType(varType, s, addDefinition(d, env));

public TypeEnv checkStatement(d: declare(Type varType, variable(GlagolID name), Statement defaultValue), Type t, Declaration s, TypeEnv env) = 
	checkDeclareType(varType, lookupType(defaultValue, env), name, d, addDefinition(d, checkStatement(defaultValue, t, s, env)));

public TypeEnv checkDeclareType(\list(Type l), \list(voidValue()), GlagolID name, Statement d, TypeEnv env) = env;
public TypeEnv checkDeclareType(\map(Type k, Type v), \map(voidValue(), voidValue()), GlagolID name, Statement d, TypeEnv env) = env;
public TypeEnv checkDeclareType(artifact(Name n), self(), GlagolID name, Statement d, TypeEnv env) = env;
public TypeEnv checkDeclareType(repository(Name n), self(), GlagolID name, Statement d, TypeEnv env) = env;

public TypeEnv checkDeclareType(Type expectedType, Type actualType, GlagolID name, Statement d, TypeEnv env) = 
	addError(d,
		"Cannot assign <toString(actualType)> to variable <name> originally defined as <toString(expectedType)>", env)
	when expectedType != actualType;
	
public TypeEnv checkDeclareType(Type expectedType, Type actualType, GlagolID name, Statement d, TypeEnv env) = env;

public Type lookupType(expression(Expression expr), TypeEnv env) = lookupType(expr, env);
public Type lookupType(assign(Expression e, AssignOperator ao, Statement \value), TypeEnv env) = lookupType(\value, env);
public Type lookupType(Statement s, TypeEnv env) = unknownType();

private str stringify(persist(Expression expr)) = "persisted";
private str stringify(flush(Expression expr)) = "flushed";
private str stringify(remove(Expression expr)) = "removed";

public TypeEnv checkStatement(f: foreach(Expression l, Expression key, Expression varName, Statement body, list[Expression] conditions), Type t, Declaration s, TypeEnv env) = 
	decrementControlLevel(checkStatement(body, t, s, incrementControlLevel(checkForeach(f, env))));

public TypeEnv checkForeach(f: foreach(Expression \list, Expression key, Expression varName, Statement body, list[Expression] conditions), TypeEnv env) = 
	checkConditions(conditions, checkForeachTypes(lookupType(\list, env), key, varName, env));

public TypeEnv checkForeachTypes(l: \list(Type _l), Expression key, Expression var, TypeEnv env) = 
	checkIsVarCompatibleWithCollection(l, var, checkIsKeyCompatibleWithCollection(l, key, env));
	
public TypeEnv checkForeachTypes(m: \map(Type k, Type v), Expression key, Expression var, TypeEnv env) = 
	checkIsVarCompatibleWithCollection(m, var, checkIsKeyCompatibleWithCollection(m, key, env));
	
public TypeEnv checkForeachTypes(Type t, Expression key, Expression var, TypeEnv env) = 
	addError(var, "Cannot traverse <toString(t)>", env);

public TypeEnv checkIsVarCompatibleWithCollection(\list(Type t), v: variable(name), TypeEnv env) = 
	addError(v, "Cannot use <name> as value in list traversing: already decleared and is not <toString(t)>", env)
	when isDefined(v, env) && lookupType(v, env) != t;

public TypeEnv checkIsVarCompatibleWithCollection(\list(Type t), v: variable(name), TypeEnv env) = 
	env when isDefined(v, env) && lookupType(v, env) == t;
	
public TypeEnv checkIsVarCompatibleWithCollection(\list(Type t), v: variable(name), TypeEnv env) = 
	addDefinition(declare(t, v, emptyStmt())[@src=v@src], env);
	
public TypeEnv checkIsVarCompatibleWithCollection(\map(_, Type t), v: variable(name), TypeEnv env) = 
	addError(v, "Cannot use <name> as value in map traversing: already decleared and is not <toString(t)>", env)
	when isDefined(v, env) && lookupType(v, env) != t;

public TypeEnv checkIsVarCompatibleWithCollection(\map(_, Type t), v: variable(name), TypeEnv env) = 
	env when isDefined(v, env) && lookupType(v, env) == t;
	
public TypeEnv checkIsVarCompatibleWithCollection(\map(_, Type t), v: variable(name), TypeEnv env) = 
	addDefinition(declare(t, v, emptyStmt())[@src=v@src], env);

public TypeEnv checkIsKeyCompatibleWithCollection(\list(Type l), emptyExpr(), TypeEnv env) = env;
public TypeEnv checkIsKeyCompatibleWithCollection(\list(Type l), v: variable(name), TypeEnv env) = 
	addError(v, "Cannot use <name> as key in list traversing: already decleared and it is not an integer", env) 
	when isDefined(v, env) && lookupType(v, env) != integer();
	
public TypeEnv checkIsKeyCompatibleWithCollection(\list(Type l), v: variable(str name), TypeEnv env) = 
	env when isDefined(v, env) && lookupType(v, env) == integer();
	
public TypeEnv checkIsKeyCompatibleWithCollection(\list(Type l), v: variable(str name), TypeEnv env) = 
	addDefinition(declare(integer(), v, emptyStmt())[@src=v@src], env);
	
public TypeEnv checkIsKeyCompatibleWithCollection(\map(Type key, Type v), emptyExpr(), TypeEnv env) = env;
public TypeEnv checkIsKeyCompatibleWithCollection(\map(Type key, Type val), v: variable(name), TypeEnv env) = 
	addError(v, "Cannot use <name> as key in map traversing: already decleared and it is not an <toString(key)>", env) 
	when isDefined(v, env) && lookupType(v, env) != key;

public TypeEnv checkIsKeyCompatibleWithCollection(\map(Type key, Type val), v: variable(name), TypeEnv env) = 
	env when isDefined(v, env) && lookupType(v, env) == key;

public TypeEnv checkIsKeyCompatibleWithCollection(\map(Type key, Type val), v: variable(name), TypeEnv env) = 
	addDefinition(declare(key, v, emptyStmt())[@src=v@src], env);

public TypeEnv checkIsKeyCompatibleWithCollection(Type t, Expression e, TypeEnv env) = env;

public TypeEnv checkStatement(b: \break(0), Type t, Declaration s, TypeEnv env) = 
	addError(b, "Cannot break out from structure using level 0", env);
	
public TypeEnv checkStatement(b: \break(int level), Type t, Declaration s, TypeEnv env) = 
	addError(b, "Cannot break out from structure using level <level>", env)
	when !isControlLevelCorrect(level, env);
	
public TypeEnv checkStatement(b: \break(int level), Type t, Declaration s, TypeEnv env) = env;

public TypeEnv checkStatement(c: \continue(0), Type t, Declaration s, TypeEnv env) = 
	addError(c, "Cannot continue from structure using level 0", env);
	
public TypeEnv checkStatement(c: \continue(int level), Type t, Declaration s, TypeEnv env) = 
	addError(c, "Cannot continue from structure using level <level>", env)
	when !isControlLevelCorrect(level, env);
	
public TypeEnv checkStatement(c: \continue(int level), Type t, Declaration s, TypeEnv env) = env;

