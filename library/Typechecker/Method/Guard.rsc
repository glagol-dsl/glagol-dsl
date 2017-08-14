module Typechecker::Method::Guard

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Type;
import Typechecker::Expression;
import Syntax::Abstract::Glagol;

public TypeEnv checkGuard(emptyExpr(), TypeEnv env) = env;

public TypeEnv checkGuard(Expression guard, TypeEnv env) = checkGuard(guard, lookupType(guard, env), checkExpression(guard, env));

public TypeEnv checkGuard(Expression guard, Type actualType, TypeEnv env) = 
	addError(guard,
		"Method guard should evaluate to boolean, resulted as <toString(actualType)>", env)
	when actualType != boolean();

public TypeEnv checkGuard(Expression guard, Type actualType, TypeEnv env) = env;
