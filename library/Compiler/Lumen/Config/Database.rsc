module Compiler::Lumen::Config::Database

import Syntax::Abstract::PHP;
import Compiler::Lumen::Config::Abstract;
import Compiler::PHP::Compiler;
import Compiler::PHP::Code;

public str createDatabaseConfig() = 
    implode(toCode(phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
        "connections": array((
            "mysql": array((
                "driver": stringVal("mysql"),
                "host": env("DB_HOST", "127.0.0.1"),
                "port": env("DB_PORT", "3306"),
                "database": env("DB_DATABASE", "glagol"),
                "username": env("DB_USERNAME", "root"),
                "password": env("DB_PASSWORD", ""),
                "charset": stringVal("utf8"),
                "collation": stringVal("utf8_unicode_ci"),
                "prefix": stringVal(""),
                "strict": booleanVal(true),
                "engine": null()
            ))
        ))
    )))))])));
    
