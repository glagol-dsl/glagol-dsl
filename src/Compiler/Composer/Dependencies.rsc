module Compiler::Composer::Dependencies

import Compiler::Composer::Dependencies::Framework;
import Compiler::Composer::Dependencies::ORM;
import Compiler::Composer::Dependencies::Intersect;
import Syntax::Abstract::Glagol;
import Config::Config;
import Config::Reader;
import Utils::JSON;
import lang::json::IO;
import lang::json::ast::JSON;

public JSON setDependencies(object(map[str, JSON] properties), Config config) = object(merge(properties, (
    "require": object((
        "php": string("^7.0"),
        "bulgaria-php/glagol-php-overriding": string("^0.1"),
        "bulgaria-php/glagol-php-ds": string("^0.1")
    ) + getFrameworkDependencies(getFramework(config))
      + getORMDependencies(getORM(config))
      + getIntersectDependencies(getFramework(config), getORM(config))
    )))
);
