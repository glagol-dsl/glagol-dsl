module Typechecker::Property::DefaultValue

extend Typechecker::Param::DefaultValue;

import Typechecker::Env;
import Syntax::Abstract::Glagol;

public TypeEnv checkDefaultValue(get(selfie()), TypeEnv env) = env;
