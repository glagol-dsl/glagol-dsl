module Test::Compiler::Lumen::Config::Database

import Compiler::Lumen::Config::Database;
import Syntax::Abstract::PHP;
import Compiler::Lumen::Config::Abstract;
import Compiler::PHP::Compiler;

test bool shouldCreateLumenDatabaseConfig() =
    createDatabaseConfig() == toCode(phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
        "connections": array((
            "mysql": array((
                "driver": string("mysql"),
                "host": env("DB_HOST", "127.0.0.1"),
                "port": env("DB_PORT", "3306"),
                "database": env("DB_DATABASE", "glagol"),
                "username": env("DB_USERNAME", "root"),
                "password": env("DB_PASSWORD", ""),
                "charset": string("utf8"),
                "collation": string("utf8_unicode_ci"),
                "prefix": string(""),
                "strict": boolean(true),
                "engine": null()
            ))
        ))
    )))))]));
