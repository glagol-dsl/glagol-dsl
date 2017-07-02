module Typechecker::Declaration

import Typechecker::Env;
import Typechecker::Property;
import Typechecker::Method;
import Syntax::Abstract::Glagol;

public TypeEnv checkDeclarations(list[Declaration] declarations, Declaration e, TypeEnv env) =
	(env | checkDeclaration(d, e, it) | d <- declarations);

public TypeEnv checkDeclaration(p: property(_, _, _), Declaration, TypeEnv env) = addDefinition(p, checkProperty(p, env));
public TypeEnv checkDeclaration(m: method(_, _, _, _, _, _), Declaration d, TypeEnv env) = checkMethod(m, d, env);

