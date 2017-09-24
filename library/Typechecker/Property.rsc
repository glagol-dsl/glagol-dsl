module Typechecker::Property

import Syntax::Abstract::Glagol;
import Typechecker::Env;
import Typechecker::Type;
import Typechecker::Errors;
import Typechecker::Expression;
import Typechecker::Property::DefaultValue;

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
    TypeEnv env) = checkTypeMismatch(lookupType(defaultValue, env), \type, checkDefaultValue(defaultValue, checkType(\type, p, env)));

public TypeEnv checkTypeMismatch(selfie(), artifact(_), TypeEnv env) = env;
public TypeEnv checkTypeMismatch(selfie(), repository(_), TypeEnv env) = env;
public TypeEnv checkTypeMismatch(\list(voidValue()), \list(Type t), TypeEnv env) = env;
public TypeEnv checkTypeMismatch(\map(voidValue(), voidValue()), \map(_, _), TypeEnv env) = env;
public TypeEnv checkTypeMismatch(Type valueType, Type \type, TypeEnv env) = env when valueType == \type;
public TypeEnv checkTypeMismatch(Type valueType, Type \type, TypeEnv env) =
    addError(\type@src, typeMismatch(\type, valueType), env);
