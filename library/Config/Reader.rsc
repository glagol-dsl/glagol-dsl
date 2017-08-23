module Config::Reader

import Config::Config;
import Exceptions::ConfigExceptions;
import lang::json::IO;
import lang::json::ast::JSON;
import List;
import String;
import IO;

alias Config = tuple[
	Framework framework,
	ORM orm
];

public Config newConfig() = <lumen(), doctrine()>;

public Framework getFramework(Config config) = config.framework;
public ORM getORM(Config config) = config.orm;
