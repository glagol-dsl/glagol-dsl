module Typechecker::Declaration

import Typechecker::Env;
import Typechecker::Property;
import Typechecker::Method;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

import IO;
import List;

public TypeEnv checkDeclarations(list[Declaration] declarations, Declaration e, TypeEnv env) = 
	(env | resetLocalDefinitions(checkDeclaration(d, e, it)) | d <- declarations);

public TypeEnv checkDeclaration(p: property(_, _, _), Declaration, TypeEnv env) = addDefinition(p, checkProperty(p, env));
public TypeEnv checkDeclaration(m: method(_, _, _, _, _, _), Declaration d, TypeEnv env) = checkMethod(m, d, env);
public TypeEnv checkDeclaration(c: constructor(_, _, _), Declaration d, TypeEnv env) = checkMethod(c, d, env);
public TypeEnv checkDeclaration(Declaration, Declaration d, TypeEnv env) = env;


private list[Declaration] sortDeclarations(list[Declaration] declarations) = 
	[d | d <- declarations, isProperty(d)] +
	[d | d <- declarations, isRelation(d)] +
	[d | d <- declarations, !isProperty(d) && !isRelation(d)];
