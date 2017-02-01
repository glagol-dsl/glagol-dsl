module Typechecker::Artifact

import Syntax::Abstract::Glagol;
import Typechecker::Env;
import Typechecker::Declarations;
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
    checkDeclarations(declarations, c, checkControllerFileName(c, env));

private TypeEnv checkControllerFileName(c:controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations), TypeEnv env) = 
    env[errors = env.errors + <env.location, "Controller does not follow the convetion \<Identifier\>Controller.g in <c@src.path>">]
    when /^[A-Z][A-Za-z]+?Controller$/ !:= replaceLast(c@src.file, ".<c@src.extension>", "");
    
private TypeEnv checkControllerFileName(c:controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations), TypeEnv env) = 
    env when /^[A-Z][A-Za-z]+?Controller$/ := replaceLast(c@src.file, ".<c@src.extension>", "");

private TypeEnv checkRedefine(Declaration decl, TypeEnv env) = 
	env[errors = env.errors + <decl@src, 
		"Cannot redefine \"<decl.name>\" in <decl@src.path> on line <decl@src.begin.line> " +
		"previously imported on line <env.imported[decl.name]@src.begin.line>">]
	when decl.name in env.imported;

private TypeEnv checkRedefine(Declaration decl, TypeEnv env) = env when decl.name notin env.imported;

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    env[errors = env.errors + <r@src, "Entity \"<name>\" not imported in <r@src.path>">]
    when name notin env.imported;

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    env[errors = env.errors + <r@src, "\"<name>\" is not an entity imported in <r@src.path> on line <env.imported[name]@src.begin.line>">]
    when name in env.imported && isInAST(env.imported[name], env) && entity(_, _) !:= getArtifactFromAST(env.imported[name], env);

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    env when name in env.imported && isInAST(env.imported[name], env) && entity(_, _) := getArtifactFromAST(env.imported[name], env);
