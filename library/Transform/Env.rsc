module Transform::Env

import Config::Config;
import Config::Reader;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Definitions;

alias TransformEnv = tuple[
	Framework framework, 
	ORM orm, 
    map[GlagolID, Definition] definitions,
    Declaration context
];

public TransformEnv newTransformEnv(Config config) = <getFramework(config), getORM(config), (), emptyDecl()>;
public TransformEnv newTransformEnv() = <lumen(), doctrine(), (), emptyDecl()>;
public TransformEnv newTransformEnv(Declaration context) = <lumen(), doctrine(), (), context>;
public TransformEnv newTransformEnv(Framework f, ORM orm) = <f, orm, (), emptyDecl()>;

public TransformEnv setContext(Declaration ctx, TransformEnv env) = env[context = ctx];

public bool isInEntity(TransformEnv env) = entity(str name, list[Declaration] ds) := env.context;

public TransformEnv addDefinitions(list[Declaration] properties, TransformEnv env) = (env | addDefinition(p, env) | p <- properties);

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
