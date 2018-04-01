module Test::Compiler::Lumen::Config::Doctrine

import Compiler::Lumen::Config::Doctrine;
import Syntax::Abstract::PHP;
import Compiler::Lumen::Config::Abstract;
import Compiler::PHP::Compiler;
import Compiler::PHP::Code;

test bool shouldCreateLumenDoctrineConfig() =
    createDoctrineConfig([]) == implode(toCode(phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
        "managers": array((
            "default": array((
                "dev": env("APP_DEBUG"),
                "meta": env("DOCTRINE_METADATA", "annotations"),
                "connection": env("DB_CONNECTION", "mysql"),
                "namespaces": array([
                    stringVal("App")
                ]),
                "paths": array([
                    basePath("app")
                ]),
                "repository": class("Doctrine\\ORM\\EntityRepository"),
                "proxies": array((
                    "namespace": booleanVal(false),
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
            stringVal("json"): class("LaravelDoctrine\\ORM\\Types\\Json")
        )),
        "custom_datetime_functions": array([]),
        "custom_numeric_functions": array([]),
        "custom_string_functions": array([]),
        "logger": env("DOCTRINE_LOGGER", false),
        "cache": array((
            "default": env("DOCTRINE_CACHE", "array"),
            "namespace": \null(),
            "second_level": booleanVal(false)
        )),
        "gedmo": array((
            "all_mappings": booleanVal(false)
        )),
        "doctrine_presence_verifier": booleanVal(true),
        "notifications": array((
            "channel": stringVal("database")
        ))
    )))))])));
