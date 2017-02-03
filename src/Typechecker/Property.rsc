module Typechecker::Property

import Typechecker::Env;
import Typechecker::Type;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;

public TypeEnv checkProperty(
    p:property(Type \type, GlagolID name, set[AccessProperty] valueProperties, Expression defaultValue), 
    TypeEnv env) = checkDefaultValue(defaultValue, checkType(\type, p, env));

private TypeEnv checkDefaultValue(get(selfie()), TypeEnv env) = env;
private TypeEnv checkDefaultValue(emptyExpr(), TypeEnv env) = env;
private TypeEnv checkDefaultValue(g:get(a:artifact(str name)), TypeEnv env) = 
    addError(g@src, notImported(g@src, a), env) when name notin env.imported;


