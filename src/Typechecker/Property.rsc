module Typechecker::Property

import Typechecker::Env;
import Typechecker::Type;
import Syntax::Abstract::Glagol;

public TypeEnv checkProperty(
    p:property(Type \type, GlagolID name, set[AccessProperty] valueProperties, Expression defaultValue), 
    TypeEnv env) = checkType(\type, p, env);
