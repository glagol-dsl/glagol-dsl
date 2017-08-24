module Typechecker::Property::DefaultValue

extend Typechecker::DefaultValue;

import Typechecker::Env;
import Syntax::Abstract::Glagol;
import IO;

public TypeEnv checkDefaultValue(g:get(_), TypeEnv env) = 
	addError(g, "Get is not allowed in entities and value objects", env)
	when isEntity(getArtifact(getContext(env))) || isValueObject(getArtifact(getContext(env)));

@doc="Typecheck unimported usages of artifacts"
public TypeEnv checkDefaultValue(g:get(a:artifact(Name name)), TypeEnv env) =
    addError(g, notImported(a), env) when !isImported(name, env);
    
@doc="Success only: typecheck imported usages of artifacts"
public TypeEnv checkDefaultValue(g:get(a:artifact(Name name)), TypeEnv env) =
    env when isImported(name, env);

// TODO use isImported() instead of notin
@doc{
Typecheck unimported usages of repository
}
public TypeEnv checkDefaultValue(g:get(r:repository(Name name)), TypeEnv env) =
    addError(g, notImported(r), env) when !isImported(name, env);

@doc{
Typecheck usages of repository which is not targeting an actual entity
}
public TypeEnv checkDefaultValue(g:get(r:repository(Name name)), TypeEnv env) =
    addError(g, notEntity(r), env) when isImported(name, env) && !isEntity(lookupImported(name, env), env);

@doc="Success only: typecheck repository targeting an actual entity"
public TypeEnv checkDefaultValue(g:get(r:repository(Name name)), TypeEnv env) =
    env when isImported(name, env) && isEntity(lookupImported(name, env), env);

public TypeEnv checkDefaultValue(get(selfie()), TypeEnv env) = env;

@doc="Any other type of expression is not allowed as default value for properties"
public TypeEnv checkDefaultValue(Expression expr, TypeEnv env) = 
	addError(expr, notAllowed(expr), env);
	
