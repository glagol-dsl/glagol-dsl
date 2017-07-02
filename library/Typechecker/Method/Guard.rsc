module Typechecker::Method::Guard

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Type;
import Typechecker::Expression;
import Syntax::Abstract::Glagol;

public TypeEnv checkGuard(Expression guard, TypeEnv env) = checkGuard(guard, lookupType(guard, env), env);

public TypeEnv checkGuard(Expression guard, Type actualType, TypeEnv env) = 
	addError(guard@src, 
		"Method guard should evaluate to boolean, resulted as <toString(actualType)> in <guard@src.path> on line <guard@src.begin.line>", env)
	when actualType != boolean();

public TypeEnv checkGuard(Expression guard, Type actualType, TypeEnv env) = env;
