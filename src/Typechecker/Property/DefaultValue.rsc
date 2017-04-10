module Typechecker::Property::DefaultValue

import Typechecker::Env;
import Typechecker::Type;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;

public TypeEnv checkDefaultValue(get(selfie()), TypeEnv env) = env;
public TypeEnv checkDefaultValue(emptyExpr(), TypeEnv env) = env;
public TypeEnv checkDefaultValue(integer(_), TypeEnv env) = env;
public TypeEnv checkDefaultValue(float(_), TypeEnv env) = env;
public TypeEnv checkDefaultValue(boolean(_), TypeEnv env) = env;
public TypeEnv checkDefaultValue(string(_), TypeEnv env) = env;
public TypeEnv checkDefaultValue(\bracket(Expression expr), TypeEnv env) = checkDefaultValue(expr, env);

@doc="Typecheck for allowed list items in property"
public TypeEnv checkDefaultValue(\list(list[Expression] items), TypeEnv env) = 
	(env | addError(item@src, notAllowed(item), it) | item <- items, isArrayItemAllowed(item));

@doc="Typecheck for allowed/matching types in map"
public TypeEnv checkDefaultValue(\map(map[Expression key, Expression \value] items), TypeEnv env) = 
	(
		(env | addError(key@src, notAllowed(key), it) | key <- domain(items), isArrayKeyAllowed(key)) |
		 addError(val@src, notAllowed(val), it) | 
		 val <- range(items), isArrayItemAllowed(val)
	);

@doc="Typecheck unimported usages of artifacts"
public TypeEnv checkDefaultValue(g:get(a:artifact(str name)), TypeEnv env) = 
    addError(g@src, notImported(a), env) when name notin env.imported;
    
@doc="Success only: typecheck imported usages of artifacts"
public TypeEnv checkDefaultValue(g:get(a:artifact(str name)), TypeEnv env) = 
    env when name in env.imported;

@doc{
Typecheck unimported usages of repository
}
public TypeEnv checkDefaultValue(g:get(r:repository(str name)), TypeEnv env) = 
    addError(g@src, notImported(r), env) when name notin env.imported;

@doc{
Typecheck usages of repository which is not targeting an actual entity
}
public TypeEnv checkDefaultValue(g:get(r:repository(str name)), TypeEnv env) = 
    addError(g@src, notEntity(r), env) when name in env.imported && !isEntity(env.imported[name], env);

@doc="Success only: typecheck repository targeting an actual entity"
public TypeEnv checkDefaultValue(g:get(r:repository(str name)), TypeEnv env) = 
    env when name in env.imported && isEntity(env.imported[name], env);
    
@doc="Any other type of expression is not allowed as default value for properties"
public TypeEnv checkDefaultValue(Expression expr, TypeEnv env) = 
	addError(expr@src, notAllowed(expr));

private bool isArrayItemAllowed(integer(_)) = true;
private bool isArrayItemAllowed(float(_)) = true;
private bool isArrayItemAllowed(boolean(_)) = true;
private bool isArrayItemAllowed(string(_)) = true;
private bool isArrayItemAllowed(Expression expr) = false;
