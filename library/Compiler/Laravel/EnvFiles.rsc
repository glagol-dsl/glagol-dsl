module Compiler::Laravel::EnvFiles

import Config::Config;
import Config::Reader;
import Compiler::PHP::Compiler;
import Compiler::Laravel::Bootstrap::App;
import Compiler::Laravel::Bootstrap::Autoload;
import Compiler::Laravel::Public::Index;
import Compiler::Laravel::Public::Htaccess;
import Compiler::Laravel::Public::WebConfig;
import Compiler::Laravel::Config::App;
import Compiler::Laravel::Config::Compile;
import Compiler::Laravel::Config::Cache;
import Compiler::Laravel::Config::View;
import Compiler::Laravel::Config::Doctrine;
import Compiler::Laravel::Config::Database;
import Compiler::Laravel::Config::EnvFile;
import Compiler::Laravel::Routes::Api;
import Compiler::Laravel::Routes::Console;
import Compiler::Laravel::Server;
import Compiler::Laravel::Artisan;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import IO;

public map[loc, str] generateFrameworkFiles(laravel(), Config config, list[Declaration] ast) = (
	getCompilePath(config) + "bootstrap/app.php": createAppFile(),
    getCompilePath(config) + "bootstrap/autoload.php": createAutoloadFile(),
    getCompilePath(config) + "bootstrap/cache/.gitignore": "",
	getCompilePath(config) + "public/index.php": createIndexFile(),
	getCompilePath(config) + "public/.htaccess": createHtaccess(),
    getCompilePath(config) + "public/web.config": createWebConfig(),
    getCompilePath(config) + "artisan": createArtisan(),
    getCompilePath(config) + "config/app.php": createAppConfig(config, ast),
    getCompilePath(config) + "config/cache.php": createCacheConfig(),
    getCompilePath(config) + "config/compile.php": createCompileConfig(),
    getCompilePath(config) + "config/view.php": createViewConfig(),
    getCompilePath(config) + "config/doctrine.php": createDoctrineConfig(),
    getCompilePath(config) + "config/database.php": createDatabaseConfig(),
    getCompilePath(config) + "routes/api.php": createRoutesApi(ast),
    getCompilePath(config) + "routes/console.php": createRoutesConsole(),
    getCompilePath(config) + "server.php": createServerFile(),
    getCompilePath(config) + ".env": createEnvFile(config)
) + getRepositoryProviders(getORM(config), config, ast);

private list[Declaration] getRepositories(list[Declaration] ast) = 
    [e | file(_, e: \module(_, _, repository(_, _))) <- ast];

private map[loc, str] getRepositoryProviders(doctrine(), Config config, list[Declaration] ast) = 
    (getCompilePath(config) + "app/Provider/<e.artifact.name>RepositoryProvider.php": createProvider(doctrine(), e) | e <- getRepositories(ast));

private str createProvider(doctrine(), m: \module(ns, _, repository(str name, list[Declaration] declarations))) = 
    toCode(phpScript([
        phpNamespace(
            phpSomeName(phpName("App\\Provider")),
            [
                phpUse({
                    phpUse(phpName("Illuminate\\Support\\ServiceProvider"), phpNoName()),
                    phpUse(phpName(namespaceToString(ns, "\\") + "\\<name>Repository"), phpNoName())
                }),
                phpClassDef(phpClass("<name>RepositoryProvider", {}, phpSomeName(phpName("ServiceProvider")), [], [
                    phpMethod("register", {phpPublic()}, false, [], [
                        phpExprstmt(phpMethodCall(phpPropertyFetch(phpVar("this"), phpName(phpName("app"))), phpName(phpName("bind")), [
                            phpActualParameter(phpFetchClassConst(phpName(phpName("<name>Repository")), "class"), false),
                            phpActualParameter(phpClosure([
                                phpExprstmt(phpAssign(phpVar("em"), phpMethodCall(phpVar("app"), phpName(phpName("make")), [
                                    phpActualParameter(phpScalar(phpString("em")), false)
                                ]))),
                                phpExprstmt(phpAssign(phpVar("meta"), phpMethodCall(
                                    phpVar("em"),
                                    phpName(phpName("getClassMetadata")),
                                    [
                                        phpActualParameter(phpFetchClassConst(
                                        phpName(phpName("<getTargetEntityWithNamespace(m)>")),
                                        "class"), false)
                                    ]
                                ))),
                                phpReturn(phpSomeExpr(phpNew(phpName(phpName("<name>Repository")), [
                                    phpActualParameter(phpVar("em"), false),
                                    phpActualParameter(phpVar("meta"), false)
                                ])))
                            ], [phpParam("app", phpNoExpr(), phpNoName(), false, false)], [], false, false), false)
                        ]))
                    ], phpNoName())
                ]))
            ]
        )
    ]));

private str getTargetEntityWithNamespace(\module(Declaration ns, list[Declaration] imports, repository(str name, _))) {
    for (a: \import(str realName, Declaration namespace, str as) <- imports, as == name) {
        return "\\" + namespaceToString(namespace, "\\") + "\\<realName>";
    }
    
    throw "Cannot find entity <name> used in <name>Repository";
}
