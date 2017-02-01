module Typechecker::Declarations

import Typechecker::Env;
import Syntax::Abstract::Glagol;

public TypeEnv checkDeclarations(list[Declaration] declarations, entity(GlagolID name, _), TypeEnv env) = env;
public TypeEnv checkDeclarations(list[Declaration] declarations, repository(GlagolID name, _), TypeEnv env) = env;
