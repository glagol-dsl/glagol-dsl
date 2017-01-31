module Typechecker::Artifact

import Syntax::Abstract::Glagol;
import Typechecker::Env;

public TypeEnv checkArtifact(e:entity(GlagolID name, list[Declaration] declarations), TypeEnv env) =
	checkRedefine(e, env);

private TypeEnv checkRedefine(e:entity(GlagolID name, _), TypeEnv env) = 
	env[errors = env.errors + <e@src, 
		"Cannot redefine \"<name>\" in <e@src.path> on line <e@src.begin.line> " +
		"previously imported on line <env.imported[name]@src.begin.line>">]
	when name in env.imported;

private TypeEnv checkRedefine(e:entity(GlagolID name, _), TypeEnv env) = env when name notin env.imported;
