module Typechecker::Method

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Type;
import Typechecker::Param;
import Typechecker::Method::Guard;
import Typechecker::Method::Body;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import List;

public TypeEnv checkMethod(c: constructor(list[Declaration] params, list[Statement] body, Expression guard), Declaration parent, TypeEnv env) =
	checkBody(body, voidValue(), c, parent, checkGuard(guard, checkParams(params, checkDuplicates(c, parent.declarations, env))));

public TypeEnv checkMethod(m: method(_, Type t, _, list[Declaration] params, list[Statement] body, Expression guard), Declaration parent, TypeEnv env) =
	checkBody(body, t, m, parent, 
		checkGuard(guard, 
			checkParams(params, 
				checkReturnType(m, parent.declarations, 
					checkAccessModifiers(m, parent.declarations, 
						checkDuplicates(m, parent.declarations, env)
	)))));

public TypeEnv checkDuplicates(m: method(_, _, GlagolID name, _, _, _), list[Declaration] declarations, TypeEnv env) = 
	addError(m, "Method <name> has been defined more than once with a duplicating signature", env)
	when hasDuplicates(m, declarations);
	
public TypeEnv checkDuplicates(c: constructor(_, _, _), list[Declaration] declarations, TypeEnv env) = 
	addError(c, "Constructor has duplicating signature", env)
	when hasDuplicates(c, declarations);

public TypeEnv checkDuplicates(Declaration, list[Declaration] declarations, TypeEnv env) = env;

public TypeEnv checkAccessModifiers(m: method(_, _, GlagolID name, _, _, _), list[Declaration] declarations, TypeEnv env) = 
	addError(m,
		"Method <name> is defined more than once with different access modifiers", env)
	when isDefinedWithDifferentAccessModifier(m, declarations);
	
public TypeEnv checkAccessModifiers(Declaration, list[Declaration] declarations, TypeEnv env) = env;

public TypeEnv checkReturnType(m: method(_, t, GlagolID name, _, _, _), list[Declaration] declarations, TypeEnv env) = 
	addError(m,
		"Method <name> is defined more than once with different return types", env)
	when isDefinedWithDifferentReturnTypes(m, declarations);
	
public TypeEnv checkReturnType(Declaration, list[Declaration] declarations, TypeEnv env) = env;
	
private bool hasDuplicates(method(_, _, n, p, _, g), list[Declaration] declarations) = 
	size([d | d: method(_, _, n, p, _, g) <- declarations]) > 1;
	
private bool hasDuplicates(constructor(p, _, g), list[Declaration] declarations) = 
	size([d | d: constructor(p, _, g) <- declarations]) > 1;

private bool isDefinedWithDifferentAccessModifier(method(originalMod, _, n, _, _, _), list[Declaration] declarations) =
	size([d | d: method(modifier, _, n, _, _, _) <- declarations, modifier != originalMod]) > 0;

private bool isDefinedWithDifferentReturnTypes(method(_, originalReturnType, n, _, _, _), list[Declaration] declarations) =
	size([d | d: method(_, returnType, n, _, _, _) <- declarations, returnType != originalReturnType]) > 0;


