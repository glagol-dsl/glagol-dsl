module Typechecker::Env

import Syntax::Abstract::Glagol;
import Map;

data Definition
    = field(Declaration d)
    | localVar(Statement stmt)
    ;

alias TypeEnv = tuple[
    loc location,
    map[GlagolID, Definition] definitions,
    map[GlagolID, Declaration] imported,
    list[Declaration] ast,
    list[tuple[loc src, str message]] errors
];

public TypeEnv addDefinition(p:property(_, GlagolID name, _, _), TypeEnv env) = 
    addError(p@src, "Cannot redefine \"<name>\". Property with the same name already defined in <p@src.path> on line <env.definitions[name].d@src.begin.line>.", env) when name in env.definitions;

public TypeEnv addDefinition(p:property(_, GlagolID name, _, _), TypeEnv env) = 
    env[definitions = env.definitions + (name: field(p))] when name notin env.definitions;

public TypeEnv addError(loc src, str message, TypeEnv env) = env[errors = env.errors + <src, message>];

public TypeEnv addErrors(list[tuple[loc, str]] errors, TypeEnv env) = (env | addError(src, message, it) | <loc src, str message> <- errors);

public bool isImported(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    (false | true | i <- range(env.imported), i.artifactName == name && i.namespace == namespace);

public bool isInAST(\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    (false | true | file(_, \module(Declaration ns, _, artifact)) <- env.ast, artifact.name == name && ns == namespace);

public Declaration getArtifactFromAST(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) {
    for (file(_, \module(Declaration ns, _, artifact)) <- env.ast, artifact.name == name && ns == namespace) {
        return artifact;
    }
    // TODO make a better exception
    throw "Cannot happen";
}

public bool isEntity(i:\import(GlagolID name, Declaration namespace, GlagolID as), TypeEnv env) = 
    entity(_, _) !:= getArtifactFromAST(i, env);
