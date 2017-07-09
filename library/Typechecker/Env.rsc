module Typechecker::Env

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Map;
import List;

import IO;

data Definition
    = field(Declaration d)
    | param(Declaration d)
    | localVar(Statement stmt)
    | method(Declaration d)
    ;

alias TypeEnv = tuple[
    loc location,
    map[GlagolID, Definition] definitions,
    map[GlagolID, Declaration] imported,
    list[Declaration] ast,
    list[tuple[loc src, str message]] errors,
    Declaration context,
    int loopLevel
];

public TypeEnv newEnv(loc location) = <location, (), (), [], [], emptyDecl(), 0>;

public TypeEnv incrementLoopLevel(TypeEnv env) = env[loopLevel = env.loopLevel + 1];
public TypeEnv decrementLoopLevel(TypeEnv env) = env[loopLevel = env.loopLevel - 1];

public TypeEnv addDefinition(p:property(_, GlagolID name, _), TypeEnv env) = 
    addError(p@src, "Cannot redefine \"<name>\". Already defined in <p@src.path> on line <env.definitions[name].d@src.begin.line>.", env) 
    when name in env.definitions;

public TypeEnv addDefinition(p:property(_, GlagolID name, _), TypeEnv env) = 
    env[definitions = env.definitions + (name: field(p))] 
    when name notin env.definitions;

public TypeEnv addDefinition(p:param(Type paramType, GlagolID name, Expression defaultValue), TypeEnv env) = 
    addError(p@src, "Cannot redefine \"<name>\". Already defined in <p@src.path> on line <env.definitions[name].d@src.begin.line>.", env) 
    when name in env.definitions && param(_) := env.definitions[name];
    
public TypeEnv addDefinition(p:param(Type paramType, GlagolID name, Expression defaultValue), TypeEnv env) =
    env[definitions = env.definitions + (name: param(p))];
    
public TypeEnv addDefinition(d:declare(Type varType, variable(GlagolID name), Statement defaultValue), TypeEnv env) = 
    env[definitions = env.definitions + (name: localVar(d))]
    when name notin env.definitions || (name in env.definitions && isField(env.definitions[name]));

public TypeEnv addDefinition(d:declare(Type varType, variable(GlagolID name), Statement defaultValue), TypeEnv env) = 
    addError(d@src, "Cannot decleare \"<name>\" in <d@src.path> on line <d@src.begin.line>. " + 
    				"Already decleared in <d@src.path> on line <env.definitions[name].d@src.begin.line>.", env) 
    when name in env.definitions && field(_) !:= env.definitions[name];

public bool isDefined(variable(GlagolID name), TypeEnv env) = name in env.definitions;
public bool isDefined(fieldAccess(str field), TypeEnv env) = field in env.definitions;
public bool isDefined(fieldAccess(this(), str field), TypeEnv env) = field in env.definitions && isField(env.definitions[field]);
public bool isDefined(Expression expr, TypeEnv env) = false;

public TypeEnv addError(loc src, str message, TypeEnv env) = env[errors = env.errors + <src, message>];

public TypeEnv addErrors(list[tuple[loc, str]] errors, TypeEnv env) = (env | addError(src, message, it) | <loc src, str message> <- errors);

public TypeEnv addImported(i: \import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = env[imported = env.imported + (as: i)];

public bool isImported(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
	(false | true | i <- range(env.imported), i.artifactName == name && i.namespace == namespace);
	
public bool isImported(artifact(Name name), TypeEnv env) = name.localName in env.imported;

public bool isInAST(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    (false | true | file(_, \module(Declaration ns, _, artifact)) <- env.ast, artifact.name == name && ns == namespace);

public list[Declaration] findArtifact(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) =
	[artifact | file(_, \module(Declaration ns, _, artifact)) <- env.ast, !isRepository(artifact) && !isController(artifact) && artifact.name == name && ns == namespace];

public bool isEntity(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    [entity(_, _)] := findArtifact(i, env);
    
public bool isEntity(a: artifact(e: external(_, _, _)), TypeEnv env) = isEntity(toNamespace(e), env);
public bool isEntity(a: artifact(local(_)), TypeEnv env) = isEntity(externalize(a, env), env);
    
public bool isValueObject(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    [valueObject(_, _)] := findArtifact(i, env);
    
public bool isUtil(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    [util(_, _)] := findArtifact(i, env);
    
public bool isUtil(artifact(Name name), TypeEnv env) =
	[util(_, _)] := findArtifact(env.imported[name.localName], env);

public bool isField(field(_)) = true;
public bool isField(_) = false;

public TypeEnv addToAST(Declaration file, TypeEnv env) = env[ast = env.ast + file];
public TypeEnv addToAST(list[Declaration] files, TypeEnv env) = env[ast = env.ast + files];

public TypeEnv setContext(Declaration ctx, TypeEnv env) = env[context = ctx];
public Declaration getContext(TypeEnv env) = env.context;
public TypeEnv clearContext(TypeEnv env) = setContext(emptyDecl(), env);

public bool hasLocalArtifact(str name, TypeEnv env) = hasLocalArtifact(name, getContext(env), env);
public bool hasLocalArtifact(str name, emptyDecl(), TypeEnv env) = false;
public bool hasLocalArtifact(str name, Declaration d, TypeEnv env) = isInAST(\import(name, getContextNamespace(d), name), env);

public Name getFullNameOfLocalArtifact(str name, TypeEnv env) = external(name, getContextNamespace(env), name);

public Declaration getContextNamespace(TypeEnv env) = getContextNamespace(getContext(env));
public Declaration getContextNamespace(\module(Declaration namespace, _, _)) = namespace;

public Type externalize(artifact(local(str name)), TypeEnv env) = artifact(getFullNameOfLocalArtifact(name, env)) when hasLocalArtifact(name, env);
public Type externalize(artifact(local(str name)), TypeEnv env) = unknownType() when !hasLocalArtifact(name, env);
public Type externalize(repository(local(str name)), TypeEnv env) = repository(getFullNameOfLocalArtifact(name, env)) when hasLocalArtifact(name, env);
public Type externalize(repository(local(str name)), TypeEnv env) = unknownType() when !hasLocalArtifact(name, env);
public Type externalize(Type t, TypeEnv env) = t;

public Declaration findModule(artifact(Name name), TypeEnv env) = findModule(toNamespace(name), env);
public Declaration findModule(repository(external(str name, Declaration ns, str original)), TypeEnv env) = 
	head([m | file(_, m: \module(ns, _, repository(original, _))) <- env.ast]);
	
public Declaration findModule(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
	head([m | file(_, m: \module(Declaration ns, _, artifact)) <- env.ast, !isRepository(artifact) && !isController(artifact) && artifact.name == name && ns == namespace]);

public bool hasModule(artifact(Name name), TypeEnv env) = size(findArtifact(toNamespace(name), env)) > 0;
public bool hasModule(repository(external(str name, Declaration ns, str original)), TypeEnv env) = 
	(false | true | file(_, m: \module(ns, _, repository(original, _))) <- env.ast);
public bool hasModule(_, TypeEnv env) = false;

public bool hasLocalProperty(GlagolID name, TypeEnv env) {
	visit (getContext(env)) {
		case property(_, name, _): 
			return true;
	}
	return false;
}


public Declaration findLocalProperty(GlagolID name, TypeEnv env) {
	visit (getContext(env)) {
		case p: property(_, name, _): 
			return p;
	}

	throw "Property not found";
}

public bool hasLocalRelation(GlagolID name, TypeEnv env) {
	visit (getContext(env)) {
		case relation(_, _, _, name): 
			return true;
	}
	return false;
}

public Declaration findLocalRelation(GlagolID name, TypeEnv env) {
	visit (getContext(env)) {
		case r: relation(_, _, _, name): 
			return r;
	}
	
	throw "Relation not found";
}
