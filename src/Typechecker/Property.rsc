module Typechecker::Property

import Typechecker::Env;
import Typechecker::Type;
import Typechecker::Property::DefaultValue;
import Syntax::Abstract::Glagol;

public TypeEnv checkProperty(
    p:property(Type \type, GlagolID name, set[AccessProperty] valueProperties, Expression defaultValue), 
    TypeEnv env) = checkDefaultValue(defaultValue, checkType(\type, p, env));
