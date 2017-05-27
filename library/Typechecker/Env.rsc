module Typechecker::Env

import Syntax::Abstract::Glagol;
import Map;
import List;

import IO;

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

public TypeEnv addImported(i: \import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = env[imported = env.imported + (as: i)];

public bool isImported(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
	(false | true | i <- range(env.imported), i.artifactName == name && i.namespace == namespace);
	
public bool isImported(artifact(Name name), TypeEnv env) = name.localName in env.imported;

public bool isInAST(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    (false | true | file(_, \module(Declaration ns, _, artifact)) <- env.ast, artifact.name == name && ns == namespace);

public list[Declaration] findArtifact(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) =
	[artifact | file(_, \module(Declaration ns, _, artifact)) <- env.ast, artifact.name == name && ns == namespace];

public bool isEntity(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    [entity(_, _)] := findArtifact(i, env);
    
public bool isUtil(artifact(Name name), TypeEnv env) =
	[util(_, _)] := findArtifact(env.imported[name.localName], env);

public TypeEnv addToAST(Declaration file, TypeEnv env) = env[ast = env.ast + file];
public TypeEnv addToAST(list[Declaration] files, TypeEnv env) = env[ast = env.ast + files];

public TypeEnv setContext(Declaration ctx, TypeEnv env) = env[context = ctx];
public Declaration getContext(TypeEnv env) = env.context;
public TypeEnv clearContext(TypeEnv env) = setContext(emptyDecl(), env);

public TypeEnv populateTypes(list[Declaration] ast, TypeEnv env) = (env | populateTypes(e, it) | e <- ast);

public TypeEnv populateTypes(file(loc file, Declaration m), TypeEnv env) =
	env[types = env.types + constructTypesMap(m)];

public map[GlagolID, Type] gatherTypes(\module(Declaration namespace, _, a: entity(str name, list[Declaration] ds))) =
	("<methodHash(namespace, a, m)>": t | m: method(_, t, _, _, _, _) <- getPublicMethods(ds));

public str hash(Declaration namespace, entity(str name, _), method(_, _, m, _, _, _)) =
	"<namespaceToString(namespace, "::")>::<name>#<m>";


