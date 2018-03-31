module Typechecker::Redeclare

import Typechecker::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

public TypeEnv checkRedeclare(Declaration d, TypeEnv env) = 
	addError(d, "<namespaceToString(getNamespace(env), "::")>::<d.name> has duplicate(s)", env)
	when !isRepository(d) && hasDuplicatedDeclaration(d.name, getNamespace(env), env);

public default TypeEnv checkRedeclare(Declaration d, TypeEnv env) = env;

private bool hasDuplicatedDeclaration(GlagolID name, Declaration ns, TypeEnv env) = countNonRepositories(findModules(name, ns, env)) > 1;

private int countNonRepositories(list[Declaration] modules) = (0 | it + 1 | \module(_, _, Declaration artifact) <- modules, !isRepository(artifact));
