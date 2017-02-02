module Typechecker::Type

import Typechecker::Env;
import Syntax::Abstract::Glagol;

public TypeEnv checkType(integer(), Declaration d, TypeEnv env) = env;
public TypeEnv checkType(float(), Declaration d, TypeEnv env) = env;
public TypeEnv checkType(string(), Declaration d, TypeEnv env) = env;
public TypeEnv checkType(boolean(), Declaration d, TypeEnv env) = env;

public TypeEnv checkType(voidValue(), p:property(_, _, _, _), TypeEnv env) = 
    env[errors = env.errors + <p@src, "Void type cannot be used on property in <p@src.path> on line <p@src.begin.line>">];

public TypeEnv checkType(voidValue(), p:param(Type paramType, GlagolID name), TypeEnv env) = 
    env[errors = env.errors + <p@src, "Void type cannot be used on param \"<name>\" in <p@src.path> on line <p@src.begin.line>">];

public TypeEnv checkType(voidValue(), p:param(Type paramType, GlagolID name, _), TypeEnv env) = 
    env[errors = env.errors + <p@src, "Void type cannot be used on param \"<name>\" in <p@src.path> on line <p@src.begin.line>">];

public TypeEnv checkType(voidValue(), Declaration d, TypeEnv env) = env;

public TypeEnv checkType(\list(Type \type), Declaration d, TypeEnv env) = checkType(\type, d, env);

public TypeEnv checkType(\map(Type key, Type v), Declaration d, TypeEnv env) = checkType(key, d, checkType(v, d, env));

public TypeEnv checkType(a:artifact(str name), Declaration d, TypeEnv env) = 
    env[errors = env.errors + <a@src, "\"<name>\" not imported, but used as type in <a@src.path> on line <a@src.begin.line>">]
    when name notin env.imported;

public TypeEnv checkType(a:artifact(str name), Declaration d, TypeEnv env) = env when name in env.imported;

public TypeEnv checkType(r:repository(str name), Declaration d, TypeEnv env) = 
    env[errors = env.errors + <r@src, "\"<name>\" not imported, but used as for repository in <r@src.path> on line <r@src.begin.line>">]
    when name notin env.imported;
    
public TypeEnv checkType(r:repository(str name), Declaration d, TypeEnv env) = 
    env[errors = env.errors + <r@src, "\"<name>\" is not an entity in <r@src.path> on line <r@src.begin.line>">]
    when name in env.imported && isInAST(env.imported[name], env) && entity(name, _) !:= getArtifactFromAST(env.imported[name], env);
