module Compiler::Lumen::Config::Doctrine

import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::Lumen::Config::Abstract;
import Compiler::PHP::Compiler;
import Compiler::PHP::Code;

public str createDoctrineConfig(list[Syntax::Abstract::Glagol::Declaration] ast) = 
    implode(toCode(phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
        "managers": array((
            "default": array((
                "dev": env("APP_DEBUG"),
                "meta": env("DOCTRINE_METADATA", "annotations"),
                "connection": env("DB_CONNECTION", "mysql"),
                "namespaces": array([
                    string("App")
                ]),
                "paths": array([
                    basePath("app")
                ]),
                "repository": class("Doctrine\\ORM\\EntityRepository"),
                "proxies": array((
                    "namespace": boolean(false),
                    "path": storagePath("proxies"),
                    "auto_generate": env("DOCTRINE_PROXY_AUTOGENERATE", false)
                )),
                "events": array((
                    "listeners": array([]),
                    "subscribers": array([])
                )),
                "filters": array([]),
                "mapping_types": array(())
            ))
        )),
        "extensions": array([]),
        "custom_types": array(createCustomTypesMapping(ast)),
        "custom_datetime_functions": array([]),
        "custom_numeric_functions": array([]),
        "custom_string_functions": array([]),
        "logger": env("DOCTRINE_LOGGER", false),
        "cache": array((
            "default": env("DOCTRINE_CACHE", "array"),
            "namespace": \null(),
            "second_level": boolean(false)
        )),
        "gedmo": array((
            "all_mappings": boolean(false)
        )),
        "doctrine_presence_verifier": boolean(true),
        "notifications": array((
            "channel": string("database")
        ))
    )))))])));

private map[Conf, Conf] createCustomTypesMapping(list[Syntax::Abstract::Glagol::Declaration] ast) = 
	(string("json"): class("LaravelDoctrine\\ORM\\Types\\Json")) + 
	(class("\\App\\Types\\<namespaceToString(ns)><name>Type", "TYPE_NAME"): class("\\App\\Types\\<namespaceToString(ns)><name>Type") |
		Syntax::Abstract::Glagol::file(_, 
			Syntax::Abstract::Glagol::\module(ns, _, 
				Syntax::Abstract::Glagol::valueObject(str name, _))) <- ast);

