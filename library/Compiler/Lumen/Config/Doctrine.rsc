module Compiler::Lumen::Config::Doctrine

import Syntax::Abstract::Glagol;
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
                    stringVal("App")
                ]),
                "paths": array([
                    basePath("app")
                ]),
                "repository": class("Doctrine\\ORM\\EntityRepository"),
                "proxies": array((
                    "namespace": booleanVal(false),
                    "path": env("DOCTRINE_PROXY_PATH", storagePath("proxies")),
                    "auto_generate": env("DOCTRINE_PROXY_AUTOGENERATE", true)
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

private map[Conf, Conf] createCustomTypesMapping(list[Declaration] ast) = 
	(stringVal("json"): class("LaravelDoctrine\\ORM\\Types\\Json")) + 
	(class(typeClass(ns, name, v), "TYPE_NAME"): class(typeClass(ns, name, v)) | 
		file(_, \module(ns, _, v: valueObject(str name, _, Proxy proxy))) <- ast,
		(proxyClass(str prc) := proxy && (v@annotations?)) ? (
			[*l, annotation("typeFactory", [annotationVal(str tFactory)]), *r] := v@annotations
		) : (proxyClass(str prc) := proxy && !(v@annotations?)) ? false : true
	);
		
private str typeClass(Declaration ns, str name, Declaration artifact) = 
	factory when (artifact@annotations?) && [*l, annotation("typeFactory", [annotationVal(str factory)]), *r] := artifact@annotations;
private str typeClass(Declaration ns, str name, Declaration artifact) = "\\App\\Types\\<namespaceToString(ns)><name>Type";

