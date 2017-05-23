module Typechecker::Type

import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

public TypeEnv checkType(integer(), Declaration d, TypeEnv env) = env;
public TypeEnv checkType(float(), Declaration d, TypeEnv env) = env;
public TypeEnv checkType(string(), Declaration d, TypeEnv env) = env;
public TypeEnv checkType(boolean(), Declaration d, TypeEnv env) = env;

public TypeEnv checkType(voidValue(), p:property(_, _, _, _), TypeEnv env) = 
    addError(p@src, "Void type cannot be used on property in <p@src.path> on line <p@src.begin.line>", env);

public TypeEnv checkType(voidValue(), p:param(Type paramType, GlagolID name, _), TypeEnv env) = 
    addError(p@src, "Void type cannot be used on param \"<name>\" in <p@src.path> on line <p@src.begin.line>", env);

public TypeEnv checkType(voidValue(), Declaration d, TypeEnv env) = env;

public TypeEnv checkType(\list(Type \type), Declaration d, TypeEnv env) = checkType(\type, d, env);

public TypeEnv checkType(\map(Type key, Type v), Declaration d, TypeEnv env) = checkType(key, d, checkType(v, d, env));

public TypeEnv checkType(a:artifact(str name), Declaration d, TypeEnv env) = 
    addError(a@src, notImported(a), env) when name notin env.imported;

public TypeEnv checkType(a:artifact(str name), Declaration d, TypeEnv env) = env when name in env.imported;

public TypeEnv checkType(r:repository(str name), Declaration d, TypeEnv env) = 
    addError(r@src, notImported(r), env) when name notin env.imported;
    
public TypeEnv checkType(r:repository(str name), Declaration d, TypeEnv env) = 
    addError(r@src, notEntity(r), env)
    when name in env.imported && !isEntity(env.imported[name]);
    
public TypeEnv checkType(r:repository(str name), Declaration d, TypeEnv env) = 
    env when name in env.imported && isEntity(env.imported[name]);

public TypeEnv checkType(s:selfie(), property(_, _, _, get(selfie())), TypeEnv env) = env;
	
public TypeEnv checkType(s:selfie(), Declaration d, TypeEnv env) = 
    addError(s@src, "Cannot use selfie as type in <d@src.path> on line <d@src.begin.line>", env);
