module Typechecker::Statement

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Expression;
import Syntax::Abstract::Glagol;

public TypeEnv checkStatements(list[Statement] stmts, t, subroutine, TypeEnv env) =
	(env | checkStatement(stmt, t, subroutine, it) | stmt <- stmts);

// TODO typecheck return type
public TypeEnv checkStatement(\return(Expression expr), t, s, env) = env;

public TypeEnv checkStatement(block(list[Statement] stmts), t, s, env) = checkStatements(stmts, t, s, env);
public TypeEnv checkStatement(expression(expr), t, s, env) = checkExpression(expr, env);
public TypeEnv checkStatement(ifThen(condition, then), t, s, env) = checkStatement(then, t, s, checkCondition(condition, env));
public TypeEnv checkStatement(ifThenElse(condition, then, \else), t, s, env) = 
	checkStatement(\else, t, s, checkStatement(then, t, s, checkCondition(condition, env)));
public TypeEnv checkStatement(a: assign(assignable, operator, val), t, s, env) = checkAssignable(assignable, env);


public TypeEnv checkAssignable(v: variable(_), TypeEnv) = checkIsVariableDefined(v, env);
public TypeEnv checkAssignable(f: fieldAccess(_), TypeEnv) = checkIsVariableDefined(f, env);
public TypeEnv checkAssignable(f: fieldAccess(_, _), TypeEnv) = checkIsVariableDefined(f, env);
public TypeEnv checkAssignable(a: arrayAccess(Expression variable, Expression arrayIndexKey), TypeEnv) = checkArrayAccess(v, env);

public TypeEnv checkCondition(Expression condition, TypeEnv env) = checkIsBoolean(lookupType(condition, env), condition, checkExpression(condition, env));

public TypeEnv checkIsBoolean(boolean(), _, TypeEnv env) = env;
public TypeEnv checkIsBoolean(_, c, TypeEnv env) = 
	addError(c@src, "Condition does not evaluate to boolean in <c@src.path> on line <c@src.begin.line>", env);

/*
public TypeEnv checkStatement() = ;
public TypeEnv checkStatement() = ;
public TypeEnv checkStatement() = ;
public TypeEnv checkStatement() = ;*/
