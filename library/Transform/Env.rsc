module Transform::Env

import Typechecker::Env;
import Config::Config;
import Config::Reader;
import Syntax::Abstract::Glagol;

alias TransformEnv = tuple[
	Framework framework, 
	ORM orm, 
    map[GlagolID, Definition] definitions
];

public TransformEnv newTransformEnv(Config config) = <getFramework(config), getORM(config), ()>;
public TransformEnv newTransformEnv() = <lumen(), doctrine(), ()>;
public TransformEnv newTransformEnv(Framework f, ORM orm) = <f, orm, ()>;

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
