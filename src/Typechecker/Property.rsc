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
    p:property(Type \type, GlagolID name, set[AccessProperty] valueProperties, Expression defaultValue), 
    TypeEnv env) = checkTypeMismatch(lookupType(defaultValue, env), \type, checkDefaultValue(defaultValue, checkType(\type, p, env)));

public TypeEnv checkTypeMismatch(Type valueType, Type \type, TypeEnv env) =
    addError(typeMismatch(\type, valueType), env) when !isTypeCompatibleWith(\type, valueType);

public TypeEnv checkTypeMismatch(Type valueType, Type \type, TypeEnv env) = env when isTypeCompatibleWith(\type, valueType);

@todo="Decompose"
private bool isTypeCompatibleWith(_, _) = true;
