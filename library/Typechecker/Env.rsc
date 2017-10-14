module Typechecker::Env

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Map;
import List;

extend Syntax::Abstract::Glagol::Definitions;

alias Error = tuple[loc src, str message];

alias TypeEnv = tuple[
    loc location,
    map[GlagolID, Definition] definitions,
    map[GlagolID, Declaration] imported,
    list[Declaration] ast,
    list[Error] errors,
    Declaration context,
    int controlLevel,
    int dimension
];

public int getDimension(TypeEnv env) = env.dimension;
public TypeEnv incrementDimension(TypeEnv env) = env[dimension = env.dimension + 1];
public TypeEnv decrementDimension(TypeEnv env) = env[dimension = env.dimension - 1];

public TypeEnv newEnv() = <|tmp:///|, (), (), [], [], emptyDecl(), 0, 0>;
public TypeEnv newEnv(list[Declaration] ast) = <|tmp:///|, (), (), ast, [], emptyDecl(), 0, 0>;
public TypeEnv newEnv(loc location) = <location, (), (), [], [], emptyDecl(), 0, 0>;
public TypeEnv cleanCopy(TypeEnv env) {
	env.definitions = ();
	env.imported = ();
	env.controlLevel = 0;
	env.dimension = 0;
	return env;
}

public TypeEnv setLocation(loc src, TypeEnv env) = env[location = src];

public TypeEnv incrementControlLevel(TypeEnv env) = env[controlLevel = env.controlLevel + 1];
public TypeEnv decrementControlLevel(TypeEnv env) = env[controlLevel = env.controlLevel - 1];
public bool isControlLevelCorrect(int level, TypeEnv env) = env.controlLevel >= level;

public TypeEnv copyDefinitions(TypeEnv origin, TypeEnv env) = origin[definitions = env.definitions]; 

public map[GlagolID, Definition] nonLocalDefinitions(TypeEnv env) = 
	(d : env.definitions[d] | d <- env.definitions, param(_) !:= env.definitions[d] && localVar(_) !:= env.definitions[d]);

public TypeEnv addDefinition(p:property(_, GlagolID name, _), TypeEnv env) = 
    addError(env.definitions[name].d, "Cannot redefine \"<name>\". Already defined", env)
    when name in env.definitions;

public TypeEnv addDefinition(p:property(_, GlagolID name, _), TypeEnv env) = 
    env[definitions = env.definitions + (name: field(p))] 
    when name notin env.definitions;

public TypeEnv addDefinition(p:param(Type paramType, GlagolID name, Expression defaultValue), TypeEnv env) = 
    addError(enclosedNode(env.definitions[name]), "Cannot redefine \"<name>\". Already defined", env)
    when name in env.definitions && param(_) := env.definitions[name];
    
public TypeEnv addDefinition(p:param(Type paramType, GlagolID name, Expression defaultValue), TypeEnv env) =
    env[definitions = env.definitions + (name: param(p))];
    
public TypeEnv addDefinition(d:declare(Type varType, variable(GlagolID name), Statement defaultValue), TypeEnv env) = 
    env[definitions = env.definitions + (name: localVar(d))]
    when name notin env.definitions || (name in env.definitions && isField(env.definitions[name]));

public TypeEnv addDefinition(d:declare(Type varType, variable(GlagolID name), Statement defaultValue), TypeEnv env) = 
    addError(enclosedNode(env.definitions[name]), "Cannot redecleare \"<name>\"", env) 
    when name in env.definitions && field(_) !:= env.definitions[name];

private Declaration enclosedNode(field(Declaration d)) = d;
private Declaration enclosedNode(param(Declaration d)) = d;
private Declaration enclosedNode(method(Declaration d)) = d;
private default Statement enclosedNode(localVar(Statement stmt)) = stmt;

public bool isDefined(variable(GlagolID name), TypeEnv env) = name in env.definitions;
public bool isDefined(fieldAccess(s: symbol(str field)), TypeEnv env) = field in env.definitions;
public bool isDefined(fieldAccess(this(), s: symbol(str field)), TypeEnv env) = field in env.definitions && isField(env.definitions[field]);
public bool isDefined(Expression expr, TypeEnv env) = false;

public TypeEnv addError(loc src, str message, TypeEnv env) = env[errors = env.errors + <src, message>];
public TypeEnv addError(Declaration element, str message, TypeEnv env) = addError(element@src, message, env);
public TypeEnv addError(Statement element, str message, TypeEnv env) = addError(element@src, message, env);
public TypeEnv addError(Expression element, str message, TypeEnv env) = addError(element@src, message, env);
public TypeEnv addError(Modifier element, str message, TypeEnv env) = addError(element@src, message, env);
public TypeEnv addError(ControllerType element, str message, TypeEnv env) = addError(element@src, message, env);
public TypeEnv addError(Route element, str message, TypeEnv env) = addError(element@src, message, env);
public TypeEnv addError(Type element, str message, TypeEnv env) = addError(element@src, message, env);
public TypeEnv addError(Name element, str message, TypeEnv env) = addError(element@src, message, env);
public TypeEnv addError(AssignOperator element, str message, TypeEnv env) = addError(element@src, message, env);
public TypeEnv addError(Annotation element, str message, TypeEnv env) = addError(element@src, message, env);

public bool hasErrors(TypeEnv env) = size(env.errors) > 0;
public list[Error] getErrors(TypeEnv env) = env.errors;

public TypeEnv addImported(i: \import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = env[imported = env.imported + (as: i)];
public TypeEnv addImported(\module(ns, _, Declaration a), TypeEnv env) = addImported(\import(a.name, ns, a.name), env);
public TypeEnv addImported(emptyDecl(), TypeEnv env) = env;

public Declaration lookupImported(Name name, TypeEnv env) = lookupImported(name.localName, env);
public Declaration lookupImported(GlagolID name, TypeEnv env) = env.imported[name] when name in env.imported;
public Declaration lookupImported(GlagolID name, TypeEnv env) = localArtifactAsImport(name, env) when hasLocalArtifact(name, env);

public bool isImported(repository(GlagolID name, list[Declaration] declarations), TypeEnv env) = 
	name in env.imported || hasLocalArtifact(name, env);

public bool isImported(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
	(false | true | i <- range(env.imported), i.artifactName == name && i.namespace == namespace);
	
public bool isImported(artifact(Name name), TypeEnv env) = isImported(name, env);
public bool isImported(Name name, TypeEnv env) = name.localName in env.imported || hasLocalArtifact(name.localName, env);

public bool isInAST(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    (false | true | file(_, \module(Declaration ns, _, a)) <- env.ast, a.name == name && ns == namespace);

public list[Declaration] findArtifact(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) =
	[a | file(_, \module(Declaration ns, _, Declaration a)) <- env.ast, !isRepository(a) && !isController(a) && a.name == name && ns == namespace];
 
public bool isEntity(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    [entity(_, _)] := findArtifact(i, env);
    
public bool isEntity(a: artifact(e: fullName(_, _, _)), TypeEnv env) = isEntity(toNamespace(e), env);
    
public bool isValueObject(TypeEnv env) = isValueObject(getContext(env).artifact);
public bool isValueObject(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    [valueObject(_, _)] := findArtifact(i, env);
    
public bool isUtil(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    [util(_, _)] := findArtifact(i, env);
    
public bool isUtil(artifact(Name name), TypeEnv env) =
	[util(_, _)] := findArtifact(env.imported[name.localName], env);

public Type contextAsType(TypeEnv env) = contextAsType(getContext(env));
public Type contextAsType(\module(ns, _, repository(name, _))) = repository(fullName(name, ns, name));
public Type contextAsType(\module(ns, _, entity(name, _))) = artifact(fullName(name, ns, name));
public Type contextAsType(\module(ns, _, valueObject(name, _))) = artifact(fullName(name, ns, name));
public Type contextAsType(\module(ns, _, util(name, _))) = artifact(fullName(name, ns, name));
public Type contextAsType(\module(ns, _, Declaration)) = unknownType();

public TypeEnv addToAST(Declaration file, TypeEnv env) = env[ast = env.ast + file];
public TypeEnv addToAST(list[Declaration] files, TypeEnv env) = env[ast = env.ast + files];

public TypeEnv setContext(Declaration ctx, TypeEnv env) = env[context = ctx];
public Declaration getContext(TypeEnv env) = env.context;
public TypeEnv clearContext(TypeEnv env) = setContext(emptyDecl(), env);

public Declaration getArtifact(\module(_, _, Declaration artifact)) = artifact;
public Declaration getArtifact(a: emptyDecl()) = a;

public Declaration getNamespace(TypeEnv env) = env.context.namespace;

public bool hasLocalArtifact(str name, TypeEnv env) = hasLocalArtifact(name, getContext(env), env);
public bool hasLocalArtifact(str name, emptyDecl(), TypeEnv env) = false;
public bool hasLocalArtifact(str name, Declaration d, TypeEnv env) = isInAST(\import(name, getContextNamespace(d), name), env);

public Declaration localArtifactAsImport(str name, TypeEnv env) = \import(name, getContextNamespace(env), name);
public Name getFullNameOfLocalArtifact(str name, TypeEnv env) = fullName(name, getContextNamespace(env), name);

public Declaration getContextNamespace(TypeEnv env) = getContextNamespace(getContext(env));
public Declaration getContextNamespace(\module(Declaration namespace, _, _)) = namespace;

public Declaration findModule(new(Name name, _), TypeEnv env) = findModule(toNamespace(name), env);
public Declaration findModule(artifact(Name name), TypeEnv env) = findModule(toNamespace(name), env);
public Declaration findModule(repository(fullName(str name, Declaration ns, str original)), TypeEnv env) = 
	head([m | file(_, m: \module(ns, _, repository(original, _))) <- env.ast]);
	
public Declaration findModule(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) {
	findings = [m | file(_, m: \module(Declaration ns, _, a)) <- env.ast, !isRepository(a) && !isController(a) && a.name == name && ns == namespace];
	
	return size(findings) > 0 ? head(findings) : emptyDecl();
}
public bool hasModule(artifact(Name name), TypeEnv env) = size(findArtifact(toNamespace(name), env)) > 0;
public bool hasModule(repository(fullName(str name, Declaration ns, str original)), TypeEnv env) = 
	(false | true | file(_, m: \module(ns, _, repository(original, _))) <- env.ast);
public bool hasModule(Type _, TypeEnv env) = false;

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

public bool isField(GlagolID name, TypeEnv env) = name in env.definitions && field(_) := env.definitions[name];
