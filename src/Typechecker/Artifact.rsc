module Typechecker::Artifact

import Syntax::Abstract::Glagol;
import Typechecker::Env;
import Typechecker::Declarations;

public TypeEnv checkArtifact(e:entity(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, e, checkRedefine(e, env));

public TypeEnv checkArtifact(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, r, checkRepositoryEntity(r, env));

private TypeEnv checkRedefine(e:entity(GlagolID name, _), TypeEnv env) = 
	env[errors = env.errors + <e@src, 
		"Cannot redefine \"<name>\" in <e@src.path> on line <e@src.begin.line> " +
		"previously imported on line <env.imported[name]@src.begin.line>">]
	when name in env.imported;

private TypeEnv checkRedefine(e:entity(GlagolID name, _), TypeEnv env) = env when name notin env.imported;

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    env[errors = env.errors + <r@src, "Entity \"<name>\" not imported in <r@src.path>">]
    when name notin env.imported;

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    env[errors = env.errors + <r@src, "\"<name>\" is not an entity imported in <r@src.path> on line <env.imported[name]@src.begin.line>">]
    when name in env.imported && isInAST(env.imported[name], env) && entity(_, _) !:= getArtifactFromAST(env.imported[name], env);

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    env when name in env.imported && isInAST(env.imported[name], env) && entity(_, _) := getArtifactFromAST(env.imported[name], env);
