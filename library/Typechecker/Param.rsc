module Typechecker::Param

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Type;
import Typechecker::Expression;
import Typechecker::Param::DefaultValue;
import Syntax::Abstract::Glagol;

public TypeEnv checkParams(list[Declaration] params, TypeEnv env) = (env | checkParam(p, it) | p <- params);

public TypeEnv checkParam(p: param(Type paramType, GlagolID name, emptyExpr()), TypeEnv env) = addDefinition(p, env);
	
public TypeEnv checkParam(p: param(Type paramType, GlagolID name, Expression defaultValue), TypeEnv env)
	= addDefinition(p, checkTypeMismatch(lookupType(defaultValue, env), paramType, checkDefaultValue(defaultValue, env)));
	
private TypeEnv checkTypeMismatch(Type valueType, Type \type, TypeEnv env) = env when valueType == \type;
private TypeEnv checkTypeMismatch(Type valueType, Type \type, TypeEnv env) =
    addError(\type@src, typeMismatch(\type, valueType), env);
