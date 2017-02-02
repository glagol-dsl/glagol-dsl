module Typechecker::Property

import Typechecker::Env;
import Syntax::Abstract::Glagol;

public TypeEnv checkProperty(
    p:property(Type \type, GlagolID name, set[AccessProperty] valueProperties, Expression defaultValue), 
    TypeEnv env) = 
    env;
