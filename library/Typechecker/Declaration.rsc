module Typechecker::Declaration

import Typechecker::Env;
import Typechecker::Property;
import Typechecker::Method;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

import IO;
import List;

public TypeEnv checkDeclarations(list[Declaration] ds, Declaration e, TypeEnv env) =	
	checkBehaviors(behaviors(ds), e, checkProperties(properties(ds), e, env));

public TypeEnv checkProperties(list[Declaration] declarations, Declaration e, TypeEnv env) = 
	(env | checkDeclaration(d, e, it) | d <- declarations);
	
public TypeEnv checkBehaviors(list[Declaration] declarations, Declaration e, TypeEnv env) = 
	(env | checkDeclaration(d, e, copyDefinitions(it, env)) | d <- declarations);

public TypeEnv checkDeclaration(p: property(_, _, _), Declaration, TypeEnv env) = addDefinition(p, checkProperty(p, env));
public TypeEnv checkDeclaration(m: method(_, _, _, _, _, _), Declaration d, TypeEnv env) = checkMethod(m, d, env);
public TypeEnv checkDeclaration(c: constructor(_, _, _), Declaration d, TypeEnv env) = checkMethod(c, d, env);
public TypeEnv checkDeclaration(a: action(_, _, _), Declaration d, TypeEnv env) = 
	addError(a, "Actions are only permitted in controllers", env) when !isController(d);
public TypeEnv checkDeclaration(a: action(_, _, _), Declaration d, TypeEnv env) = checkAction(a, d, env);
public TypeEnv checkDeclaration(Declaration, Declaration d, TypeEnv env) = env;

public list[Declaration] properties(list[Declaration] ds) = [d | d <- ds, isProperty(d)];
public list[Declaration] behaviors(list[Declaration] ds) = [d | d <- ds, !isProperty(d)];
