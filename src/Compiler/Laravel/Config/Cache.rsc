module Compiler::Laravel::Config::Cache

import Syntax::Abstract::PHP;
import Compiler::Laravel::Config::Abstract;
import Compiler::PHP::Compiler;

public str createCacheConfig() = 
    toCode(phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
        "default": env("CACHE_DRIVER", "file"),
        "stores": array((
            "apc": array((
                "driver": string("apc")
            )),
    
            "array": array((
                "driver": string("array")
            )),
    
            "database": array((
                "driver": string("database"),
                "table": string("cache"),
                "connection": \null()
            )),
    
            "file": array((
                "driver": string("file"),
                "path": storagePath("framework/cache")
            )),
    
            "memcached": array((
                "driver": string("memcached"),
                "persistent_id": env("MEMCACHED_PERSISTENT_ID"),
                "sasl": array([
                    env("MEMCACHED_USERNAME"),
                    env("MEMCACHED_PASSWORD")
                ]),
                "options": array(()),
                "servers": array([
                    array((
                        "host": env("MEMCACHED_HOST", "127.0.0.1"),
                        "port": env("MEMCACHED_PORT", "11211"),
                        "weight": integer(100)
                    ))
                ])
            )),
    
            "redis": array((
                "driver": string("redis"),
                "connection": string("default")
            ))
        ))
    )))))]));
