module Transform::Env

import Config::Config;
import Config::Reader;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Definitions;

alias TransformEnv = tuple[
	Framework framework, 
	ORM orm, 
    map[GlagolID, Definition] definitions,
    Declaration context,	
    list[Declaration] ast
];

public TransformEnv newTransformEnv(Config config, list[Declaration] ast) = <getFramework(config), getORM(config), (), emptyDecl(), ast>;
public TransformEnv newTransformEnv() = <lumen(), doctrine(), (), emptyDecl(), []>;
public TransformEnv newTransformEnv(Declaration context) = <lumen(), doctrine(), (), context, []>;
public TransformEnv newTransformEnv(Framework f, ORM orm) = <f, orm, (), emptyDecl(), []>;

public TransformEnv setAST(list[Declaration] ds, TransformEnv env) = env[ast = ds];
public TransformEnv setContext(Declaration ctx, TransformEnv env) = env[context = ctx];
public Declaration getContext(TransformEnv env) = env.context;

public str getArtifactName(TransformEnv env) = getArtifactName(getContext(env));
public str getArtifactName(file(loc file, Declaration \module)) = getArtifactName(\module);
public str getArtifactName(\module(Declaration namespace, list[Declaration] imports, Declaration artifact)) = getArtifactName(artifact);
public str getArtifactName(entity(GlagolID name, list[Declaration] declarations)) = name;
public str getArtifactName(repository(GlagolID name, list[Declaration] declarations)) = "repository\<<name>\>";
public str getArtifactName(valueObject(GlagolID name, list[Declaration] declarations)) = name;
public str getArtifactName(util(GlagolID name, list[Declaration] declarations)) = name;
public str getArtifactName(controller(GlagolID name, ControllerType controllerType, Route route, list[Declaration] declarations)) = name;

public Declaration getNamespace(TransformEnv env) = env.context.namespace;

public bool isInEntity(TransformEnv env) = \module(Declaration ns, list[Declaration] imports, entity(str name, list[Declaration] ds)) := env.context;

public TransformEnv addDefinitions(list[Declaration] properties, TransformEnv env) = (env | addDefinition(p, it) | p <- properties);

public TransformEnv addDefinition(p:property(_, GlagolID name, _), TransformEnv env) = env when name in env.definitions;

public TransformEnv addDefinition(p:property(_, GlagolID name, _), TransformEnv env) = 
    env[definitions = env.definitions + (name: field(p))] 
    when name notin env.definitions;

public TransformEnv addDefinition(p:param(Type paramType, GlagolID name, Expression defaultValue), TransformEnv env) = 
	env when name in env.definitions && param(_) := env.definitions[name];
    
public TransformEnv addDefinition(p:param(Type paramType, GlagolID name, Expression defaultValue), TransformEnv env) =
    env[definitions = env.definitions + (name: param(p))];
    
public TransformEnv addDefinition(d:declare(Type varType, variable(GlagolID name), Statement defaultValue), TransformEnv env) = 
    env[definitions = env.definitions + (name: localVar(d))]
    when name notin env.definitions || (name in env.definitions && isField(env.definitions[name]));

public TransformEnv addDefinition(d:declare(Type varType, variable(GlagolID name), Statement defaultValue), TransformEnv env) = 
    env when name in env.definitions && field(_) !:= env.definitions[name];

public bool usesLumen(TransformEnv env) = env.framework == lumen();
public bool usesDoctrine(TransformEnv env) = env.orm == doctrine();

public bool isField(str name, TransformEnv env) = isField(env.definitions[name]) when name in env.definitions;
public default bool isField(str name, TransformEnv env) = false;

public bool isValueObject(artifact(fullName(str localName, Declaration ns, str originalName)), TransformEnv env) {
	top-down visit (env.ast) {
		case valueObject(originalName, list[Declaration] ds): return true;
	}
	return false;
}

public default bool isValueObject(value _, TransformEnv env) = false;

public bool isEntity(artifact(fullName(str localName, Declaration ns, str originalName)), TransformEnv env) {
	top-down visit (env.ast) {
		case entity(originalName, list[Declaration] ds): return true;
	}
	return false;
}

public default bool isEntity(value _, TransformEnv env) = false;

public Declaration findRepository(artifact(fullName(str localName, Declaration ns, str originalName)), TransformEnv env) {
	top-down visit (env.ast) {
		case r: repository(originalName, list[Declaration] ds): return r;
	}
	return emptyDecl();
}
