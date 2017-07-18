module Typechecker::Artifact

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Typechecker::Env;
import Typechecker::Declaration;
import Typechecker::Route;
import Typechecker::Errors;
import String;

public TypeEnv checkArtifact(e:entity(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, e, checkRedefine(e, env));

public TypeEnv checkArtifact(u:util(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, u, checkRedefine(u, env));

public TypeEnv checkArtifact(v:valueObject(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, v, checkRedefine(v, env));

public TypeEnv checkArtifact(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, r, checkRepositoryEntity(r, env));

public TypeEnv checkArtifact(c:controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, c, checkRoute(route, checkControllerFileName(c, env)));

private TypeEnv checkControllerFileName(c:controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations), TypeEnv env) = 
    addError(c, "Controller does not follow the convetion \<Identifier\>Controller.g", env)
    when /^[A-Z][A-Za-z]+?Controller$/ !:= replaceLast(c@src.file, ".<c@src.extension>", "");

private TypeEnv checkControllerFileName(c:controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations), TypeEnv env) = 
    env when /^[A-Z][A-Za-z]+?Controller$/ := replaceLast(c@src.file, ".<c@src.extension>", "");

private TypeEnv checkRedefine(Declaration decl, TypeEnv env) = 
	addError(decl, "Cannot redefine \"<decl.name>\"", env)
	when decl.name in env.imported;

private TypeEnv checkRedefine(Declaration decl, TypeEnv env) = env when decl.name notin env.imported;

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    addError(r, notImported(r), env) when name notin env.imported;

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    addError(r, notEntity(r), env)
    when name in env.imported && !isEntity(env.imported[name], env);

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    env when name in env.imported && isEntity(env.imported[name], env);
