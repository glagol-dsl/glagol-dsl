module Typechecker::Type

import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Utils::Glue;

public TypeEnv checkType(selfie(), Declaration d, TypeEnv env) = 
    addError(d, "Selfie cannot be used as property type", env);

public TypeEnv checkType(voidValue(), p:property(_, _, _), TypeEnv env) = 
    addError(p, "Void type cannot be used on property", env);

public TypeEnv checkType(voidValue(), p:param(Type paramType, GlagolID name, _), TypeEnv env) = 
    addError(p, "Void type cannot be used on param \"<name>\"", env);

public TypeEnv checkType(voidValue(), Declaration d, TypeEnv env) = env;

public TypeEnv checkType(\list(Type \type), Declaration d, TypeEnv env) = checkType(\type, d, env);

public TypeEnv checkType(\map(Type key, Type v), Declaration d, TypeEnv env) = checkType(key, d, checkType(v, d, env));

// TODO replace .localName with isImported() function call

public TypeEnv checkType(a:artifact(Name name), Declaration d, TypeEnv env) = 
	env when hasLocalArtifact(name.localName, env);

public TypeEnv checkType(a:artifact(Name name), Declaration d, TypeEnv env) =
    addError(a, notImported(a), env) when !isImported(name, env);

public TypeEnv checkType(a:artifact(Name name), p: property(_, _, get(selfie())), TypeEnv env) = 
	env when isImported(name, env) && isUtil(lookupImported(name, env), env);
	
public TypeEnv checkType(a:artifact(Name name), p: property(_, _, get(selfie())), TypeEnv env) = 
	addError(p, "Get selfie cannot be applied for type other than repositories and utils/services", env)
	when isImported(name, env) && !isUtil(lookupImported(name, env), env);
	
public TypeEnv checkType(a:artifact(Name name), Declaration d, TypeEnv env) = 
	env when isImported(name, env);
	
public TypeEnv checkType(r:repository(Name name), Declaration d, TypeEnv env) =
    env when hasLocalArtifact(name.localName, env);

public TypeEnv checkType(r:repository(Name name), Declaration d, TypeEnv env) =
    addError(r, notImported(r), env) when !isImported(name, env);
    
public TypeEnv checkType(r:repository(Name name), Declaration d, TypeEnv env) =
    addError(r, notEntity(r), env)
    when isImported(name, env) && !isEntity(lookupImported(name, env), env);

public TypeEnv checkType(r:repository(Name name), Declaration d, TypeEnv env) =
    env when isImported(name, env) && isEntity(lookupImported(name, env), env);

public TypeEnv checkType(_, p: property(_, _, get(selfie())), TypeEnv env) = 
	addError(p, "Get selfie cannot be applied for type other than repositories and utils/services", env);

public TypeEnv checkType(s:selfie(), Declaration d, TypeEnv env) = 
    addError(s, "Cannot use selfie as type", env);

public TypeEnv checkType(integer(), Declaration d, TypeEnv env) = env when !hasGetSelfie(d);
public TypeEnv checkType(float(), Declaration d, TypeEnv env) = env when !hasGetSelfie(d);
public TypeEnv checkType(string(), Declaration d, TypeEnv env) = env when !hasGetSelfie(d);
public TypeEnv checkType(boolean(), Declaration d, TypeEnv env) = env when !hasGetSelfie(d);

private bool hasGetSelfie(property(_, _, get(selfie()))) = true;
private bool hasGetSelfie(_) = false;

public str toString(list[Type] types, str d) = glue([toString(t) | t <- types], d);
public str toString(integer()) = "integer";
public str toString(float()) = "float";
public str toString(string()) = "string";
public str toString(voidValue()) = "void";
public str toString(boolean()) = "bool";
public str toString(\list(Type \type)) = "<toString(\type)>[]";
public str toString(artifact(Name name)) = "<name.localName>";
public str toString(repository(Name name)) = "<name.localName> repository";
public str toString(\map(Type key, Type v)) = "map (<toString(key)>: <toString(v)>)";
public str toString(selfie()) = "selfie";
public str toString(self()) = "self";
public str toString(unknownType()) = "unknown_type";
