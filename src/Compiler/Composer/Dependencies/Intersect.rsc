module Compiler::Composer::Dependencies::Intersect

import Config::Config;
import lang::json::IO;
import lang::json::ast::JSON;

public map[str, JSON] getIntersectDependencies(laravel(), doctrine()) = (
	"laravel-doctrine/orm": string("1.2.*")
);

public default map[str, JSON] getIntersectDependencies(_, _) = ();
