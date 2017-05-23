module Typechecker::Env

import Syntax::Abstract::Glagol;
import Map;
import List;

data Definition
    = field(Declaration d)
    | param(Declaration d)
    | localVar(Statement stmt)
    ;

alias TypeEnv = tuple[
    loc location,
    map[GlagolID, Definition] definitions,
    map[GlagolID, Declaration] imported,
    list[Declaration] ast,
    list[tuple[loc src, str message]] errors,
    Declaration context
];

public TypeEnv newEnv(loc location) = <location, (), (), [], [], emptyDecl()>;

public TypeEnv addDefinition(p:property(_, GlagolID name, _, _), TypeEnv env) = 
    addError(p@src, "Cannot redefine \"<name>\". Already defined in <p@src.path> on line <env.definitions[name].d@src.begin.line>.", env) 
    when name in env.definitions;

public TypeEnv addDefinition(p:property(_, GlagolID name, _, _), TypeEnv env) = 
    env[definitions = env.definitions + (name: field(p))] 
    when name notin env.definitions;

public TypeEnv addDefinition(p:param(Type paramType, GlagolID name, Expression defaultValue), TypeEnv env) =
    env[definitions = env.definitions + (name: param(p))];

public TypeEnv addDefinition(d:declare(Type varType, variable(GlagolID name), Statement defaultValue), TypeEnv env) = 
    env[definitions = env.definitions + (name: localVar(d))]
    when name notin env.definitions || (name in env.definitions && field(_) := env.definitions[name]);

public TypeEnv addDefinition(d:declare(Type varType, variable(GlagolID name), Statement defaultValue), TypeEnv env) = 
    addError(d@src, "Cannot decleare \"<name>\". Already decleared in <d@src.path> on line <env.definitions[name].d@src.begin.line>.", env) 
    when name in env.definitions && field(_) !:= env.definitions[name];

public TypeEnv addError(loc src, str message, TypeEnv env) = env[errors = env.errors + <src, message>];

public TypeEnv addErrors(list[tuple[loc, str]] errors, TypeEnv env) = (env | addError(src, message, it) | <loc src, str message> <- errors);

public TypeEnv addImported(d: entity(GlagolID name, _), TypeEnv env) = env[imported = env.imported + (name: d)];
public TypeEnv addImported(d: util(GlagolID name, _), TypeEnv env) = env[imported = env.imported + (name: d)];
public TypeEnv addImported(d: valueObject(GlagolID name, _), TypeEnv env) = env[imported = env.imported + (name: d)];
public TypeEnv addImported(d: repository(GlagolID name, _), TypeEnv env) = env[imported = env.imported + ("<name>Repository": d)];
public TypeEnv addImported(i: \import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = env[imported = env.imported + (as: head(findArtifact(i, env)))];

public bool isImported(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = as in env.imported;
public bool isImported(artifact(GlagolID name), TypeEnv env) = name in env.imported;

public bool isInAST(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    (false | true | file(_, \module(Declaration ns, _, artifact)) <- env.ast, artifact.name == name && ns == namespace);

public list[Declaration] findArtifact(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) =
	[artifact | file(_, \module(Declaration ns, _, artifact)) <- env.ast, artifact.name == name && ns == namespace];

public bool isEntity(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    [entity(_, _)] := findArtifact(i, env);
    
public bool isEntity(artifact(GlagolID name), TypeEnv env) = 
    entity(_, _) := env.imported[name];
    
public bool isUtil(artifact(GlagolID name), TypeEnv env) = 
    util(_, _) := env.imported[name];

public TypeEnv addToAST(Declaration file, TypeEnv env) = env[ast = env.ast + file];
public TypeEnv addToAST(list[Declaration] files, TypeEnv env) = env[ast = env.ast + files];
