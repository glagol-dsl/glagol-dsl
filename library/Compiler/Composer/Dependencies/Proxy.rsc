module Compiler::Composer::Dependencies::Proxy

import Config::Config;
import Syntax::Abstract::Glagol::Helpers;
import lang::json::IO;
import lang::json::ast::JSON;

public map[str, JSON] getProxyDependencies(list[Syntax::Abstract::Glagol::Declaration] ast) = dependencies(requirements(ast));

private map[str, JSON] dependencies(list[Syntax::Abstract::Glagol::Declaration] ds) = (package : string(version) | require(str package, str version) <- ds);
