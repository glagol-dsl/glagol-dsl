module Typechecker::Param::DefaultValue

import Typechecker::Env;
import Typechecker::Type;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Map;

extend Typechecker::DefaultValue;

@doc="Any other type of expression is not allowed as default value for properties"
public TypeEnv checkDefaultValue(Expression expr, TypeEnv env) = 
	addError(expr, notAllowed(expr), env);

