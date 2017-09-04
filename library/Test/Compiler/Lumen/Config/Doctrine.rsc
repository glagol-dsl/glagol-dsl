module Test::Compiler::Lumen::Config::Doctrine

import Compiler::Lumen::Config::Doctrine;
import Syntax::Abstract::PHP;
import Compiler::Lumen::Config::Abstract;
import Compiler::PHP::Compiler;

test bool shouldCreateLumenDoctrineConfig() =
    createDoctrineConfig([]) == toCode(phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
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
        "custom_types": array((
            string("json"): class("LaravelDoctrine\\ORM\\Types\\Json")
        )),
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
    )))))]));
