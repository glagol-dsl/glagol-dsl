module Typechecker::Statement

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Expression;
import Syntax::Abstract::Glagol;

public TypeEnv checkStatement();
