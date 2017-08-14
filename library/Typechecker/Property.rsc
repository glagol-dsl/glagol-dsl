module Typechecker::Property

import Typechecker::Env;
import Typechecker::Type;
import Typechecker::Errors;
import Typechecker::Expression;
import Typechecker::Property::DefaultValue;
import Syntax::Abstract::Glagol;

@doc{
Typecheck property:
    - Checks if property type is legal
    - Checks if property default value is legal
    - Checks for type mismatch
}
public TypeEnv checkProperty(
    p:property(Type \type, GlagolID name, emptyExpr()), 
    TypeEnv env) = checkType(\type, p, env);

public TypeEnv checkProperty(
    p:property(Type \type, GlagolID name, Expression defaultValue), 
    TypeEnv env) = checkTypeMismatch(externalize(lookupType(defaultValue, env), env), externalize(\type, env), checkDefaultValue(defaultValue, checkType(\type, p, env)));

public TypeEnv checkTypeMismatch(selfie(), artifact(_), TypeEnv env) = env;
public TypeEnv checkTypeMismatch(selfie(), repository(_), TypeEnv env) = env;
public TypeEnv checkTypeMismatch(\list(voidValue()), \list(_), TypeEnv env) = env;
public TypeEnv checkTypeMismatch(\map(voidValue(), voidValue()), \map(_, _), TypeEnv env) = env;
public TypeEnv checkTypeMismatch(Type valueType, Type \type, TypeEnv env) = env when valueType == \type;
public TypeEnv checkTypeMismatch(Type valueType, Type \type, TypeEnv env) =
    addError(\type@src, typeMismatch(\type, valueType), env);
