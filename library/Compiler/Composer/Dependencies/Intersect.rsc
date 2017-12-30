module Compiler::Composer::Dependencies::Intersect

import Config::Config;
import lang::json::IO;
import lang::json::ast::JSON;

public map[str, JSON] getIntersectDependencies(lumen(), doctrine()) = ();

public default map[str, JSON] getIntersectDependencies(_, _) = ();
