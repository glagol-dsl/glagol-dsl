module Typechecker::Statement

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Expression;
import Typechecker::Type;
import Syntax::Abstract::Glagol;

public TypeEnv checkStatements(list[Statement] stmts, t, subroutine, TypeEnv env) =
	(env | checkStatement(stmt, t, subroutine, it) | stmt <- stmts);

// TODO typecheck return type
public TypeEnv checkStatement(r: \return(Expression expr), t, s, TypeEnv env) = checkReturn(lookupType(expr, env), t, r, env);

public TypeEnv checkReturn(Type actualType, Type expectedType, Statement r, TypeEnv env) = 
	addError(r@src, "Returning <toString(actualType)>, <toString(expectedType)> expected in <r@src.path> on line <r@src.begin.line>", env)
	when actualType != expectedType;
	
public TypeEnv checkReturn(Type actualType, Type expectedType, Statement r, TypeEnv env) = env;

public TypeEnv checkStatement(block(list[Statement] stmts), t, s, env) = checkStatements(stmts, t, s, env);
public TypeEnv checkStatement(expression(expr), t, s, env) = checkExpression(expr, env);
public TypeEnv checkStatement(ifThen(condition, then), t, s, env) = checkStatement(then, t, s, checkCondition(condition, env));
public TypeEnv checkStatement(ifThenElse(condition, then, \else), t, s, env) = 
	checkStatement(\else, t, s, checkStatement(then, t, s, checkCondition(condition, env)));

public TypeEnv checkStatement(a: assign(assignable, operator, val), t, s, env) = checkAssignable(assignable, env);

public TypeEnv checkAssignable(v: variable(_), TypeEnv env) = checkExpression(v, env);
public TypeEnv checkAssignable(f: fieldAccess(_), TypeEnv env) = checkExpression(f, env);
public TypeEnv checkAssignable(f: fieldAccess(_, _), TypeEnv env) = checkExpression(f, env);
public TypeEnv checkAssignable(a: arrayAccess(_, _), TypeEnv env) = checkExpression(a, env);
public TypeEnv checkAssignable(e, TypeEnv env) = addError(e@src, "Cannot assign value to expression in <e@src.path> on line <e@src.begin.line>", env);

public TypeEnv checkCondition(Expression condition, TypeEnv env) = checkIsBoolean(lookupType(condition, env), condition, checkExpression(condition, env));

public TypeEnv checkIsBoolean(boolean(), _, TypeEnv env) = env;
public TypeEnv checkIsBoolean(_, c, TypeEnv env) = 
	addError(c@src, "Condition does not evaluate to boolean in <c@src.path> on line <c@src.begin.line>", env);

/*
public TypeEnv checkStatement() = ;
public TypeEnv checkStatement() = ;
public TypeEnv checkStatement() = ;
public TypeEnv checkStatement() = ;*/
