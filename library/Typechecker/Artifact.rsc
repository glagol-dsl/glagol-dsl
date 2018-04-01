module Typechecker::Artifact

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Typechecker::Env;
import Typechecker::Declaration;
import Typechecker::Expression;
import Typechecker::Route;
import Typechecker::Errors;
import Typechecker::Type;
import Typechecker::Redeclare;

import String;
import List;
import IO;

public TypeEnv checkArtifact(e:entity(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, e, checkRedefine(e, checkRedeclare(e, env)));

public TypeEnv checkArtifact(u:util(GlagolID name, list[Declaration] declarations, Proxy pr), TypeEnv env) =
    checkDeclarations(declarations, u, checkRedefine(u, checkRedeclare(u, env)));

public TypeEnv checkArtifact(v:valueObject(GlagolID name, list[Declaration] declarations, Proxy pr), TypeEnv env) =
    checkToDbValMethod(v, declarations, checkDeclarations(declarations, v, checkRedefine(v, checkRedeclare(v, env))));

public TypeEnv checkArtifact(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, r, checkRepositoryEntity(r, checkRedeclare(r, env)));

public TypeEnv checkArtifact(c:controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations), TypeEnv env) =
    checkDeclarations(declarations, c, checkRoute(route, checkControllerFileName(c, env)));

public TypeEnv checkForDuplicatedRepositories(TypeEnv env) = checkForDuplicatedRepositories(mapRepositoriesToEntities(env), env);

private map[Declaration, list[Declaration]] mapRepositoriesToEntities(TypeEnv env) = 
	(m : collectRepositories(m, env) | file(_, m: \module(Declaration ns, _, e: entity(GlagolID n, list[Declaration] ds))) <- getAST(env));

private list[Declaration] collectRepositories(\module(Declaration namespace, list[Declaration] _i, entity(GlagolID name, list[Declaration] ds)), TypeEnv env) =
	[r | 
		file(_, \module(Declaration rns, list[Declaration] imports, r: repository(GlagolID rname, list[Declaration] rds))) <- getAST(env),
		\import(GlagolID iName, Declaration iNs, GlagolID as) <- imports,
		rname == as && iName == name && iNs == namespace
	];

public TypeEnv checkForDuplicatedRepositories(map[Declaration, list[Declaration]] erMap, TypeEnv env) = 
	(env | checkForDuplicatedRepositories(m, erMap[m], it) | m <- erMap);

public TypeEnv checkForDuplicatedRepositories(m: \module(Declaration namespace, list[Declaration] is, e: entity(GlagolID name, list[Declaration] declarations)), list[Declaration] repos, TypeEnv env) = 
	addError(m, "More than one repository declared for entity <namespaceToString(namespace, "::")>::<name>", env)
	when size(repos) > 1;

public default TypeEnv checkForDuplicatedRepositories(Declaration m, list[Declaration] repos, TypeEnv env) = env;

private TypeEnv checkControllerFileName(c:controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations), TypeEnv env) = 
    addError(c, "Controller does not follow the convetion \<Identifier\>Controller.g", env)
    when /^[A-Z][A-Za-z]+?Controller$/ !:= replaceLast(c@src.file, ".<c@src.extension>", "");

private TypeEnv checkControllerFileName(c:controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations), TypeEnv env) = 
    env when /^[A-Z][A-Za-z]+?Controller$/ := replaceLast(c@src.file, ".<c@src.extension>", "");

private TypeEnv checkRedefine(Declaration decl, TypeEnv env) = 
	addError(decl, "Cannot redefine \"<decl.name>\"", env)
	when decl.name in env.imported;

private TypeEnv checkRedefine(Declaration decl, TypeEnv env) = addImported(getContext(env), env);

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    addError(r, notImported(r), env) when !isImported(r, env);

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) =
    addError(r, notEntity(r), env)
    when isImported(r, env) && !isEntity(lookupImported(name, env), env);

private TypeEnv checkRepositoryEntity(r:repository(GlagolID name, list[Declaration] declarations), TypeEnv env) = env;
	
private TypeEnv checkToDbValMethod(v, list[Declaration] declarations, TypeEnv env) = 
	addError(v, "toDatabaseValue() cannot return void", env)
	when hasToDbValMethod(declarations) && hasVoidToDbValMethod(declarations);
	
private TypeEnv checkToDbValMethod(v, list[Declaration] declarations, TypeEnv env) = 
	checkValueConstructor(v, env)
	when hasToDbValMethod(declarations);
	
private TypeEnv checkToDbValMethod(v, list[Declaration] declarations, TypeEnv env) = env;

private Type findToDbValMethodType(list[Declaration] ds) = (\any() | t | m: method(\public(), t, "toDatabaseValue", [], _, _) <- ds);
private Type findToDbValMethod(list[Declaration] ds) = (emptyDecl() | m | m: method(\public(), t, "toDatabaseValue", [], _, _) <- ds);
private bool hasToDbValMethod(list[Declaration] ds) = (false | true | method(\public(), _, "toDatabaseValue", [], _, _) <- ds);
private bool hasVoidToDbValMethod(list[Declaration] ds) = (false | true | method(\public(), voidValue(), "toDatabaseValue", [], _, _) <- ds);

private TypeEnv checkValueConstructor(v: valueObject(str name, list[Declaration] ds, notProxy()), TypeEnv env) = 
	addError(v, "Value object should implement a constructor matching <name>(<toString(findToDbValMethodType(ds))>)", env)
	when !hasConstructor(ds, findToDbValMethodType(ds), env);
	
private TypeEnv checkValueConstructor(v: valueObject(str name, list[Declaration] ds, notProxy()), TypeEnv env) = env;
	
private bool hasConstructor(list[Declaration] ds, Type t, TypeEnv env) = (false | true | constructor(params, _, _) <- ds, isSignatureMatching([t], params, env));
	
private TypeEnv checkValueConstructor(v: valueObject(str name, list[Declaration] ds, notProxy()), TypeEnv env) = env;
